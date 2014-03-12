class CanvasGraph
  constructor: (@canvas, @data) ->
    @ctx = @canvas.getContext('2d')
    window.ctx = @ctx
    window.canvas = @canvas
    window.canvasGraph = @

    @smallestX = Math.min @data.x...
    @smallestY = Math.min @data.y...

    @largestX = Math.max @data.x...
    @largestY = Math.max @data.y...

    @arrayLength = Math.min @data.x.length, @data.y.length

    @mirrorVertically()

  enableMarking: ->
    @marks = new Marks
    window.marks = @marks

    @canvas.addEventListener 'mousedown', (e) =>
      e.preventDefault()
      @mark = new Mark(e, @)
      @marks.create(@mark)
      @mark.onMouseDown(e)
      @mark.dragging = true
      @mark.draw(e)

  plotPoints: (xMin = @smallestX, xMax = @largestX) ->
    @xMin = xMin
    @xMax = xMax
    @clearCanvas()
    for i in [0...@arrayLength]
      x = ((+@data.x[i] - xMin) / (xMax - xMin)) * @canvas.width
      y = ((+@data.y[i] - @largestY) / (@smallestY - @largestY)) * @canvas.height
      @ctx.fillStyle = "#fff"
      @ctx.fillRect(x, y,2,2)

    if @marks
      for mark in @marks.all
        scaledMin = ((mark.dataXMin - xMin) / (xMax - xMin)) * @canvas.width
        scaledMax = ((mark.dataXMax - xMin) / (xMax - xMin)) * @canvas.width

        mark.element.style.width = (scaledMax-scaledMin) + "px"
        mark.element.style.left = (scaledMin) + "px"

        mark.save(scaledMin, scaledMax)

  clearCanvas: -> @ctx.clearRect(0,0,@canvas.width, @canvas.height)

  mirrorVertically: ->
    @ctx.translate(0,@canvas.height)
    @ctx.scale(1,-1)

  toCanvasXCoord: (dataPoint) -> ((dataPoint - @xMin) / (@xMax - @xMin)) * @canvas.width

  toDataXCoord: (canvasPoint) -> ((canvasPoint / @canvas.width) * (@xMax - @xMin)) + @xMin

class Marks
  constructor: -> @all = []

  create: (mark) -> document.getElementById('marks-container').appendChild(mark.element)

  add: (mark) -> @all.push(mark)

  remove: (mark) ->
    console.log @all.splice(@all.indexOf(mark), 1)
    document.getElementById('marks-container').removeChild(mark.element)

  destroyAll: ->
    mark.element.outerHTML = "" for mark in @all
    @all = []

class Mark
  MIN_WIDTH = 15
  MAX_WIDTH = 150

  #move to end of marks-container on mousedown => for mousedown event

  constructor: (e, @canvasGraph) ->
    @canvas = @canvasGraph.canvas

    @element = document.createElement('div')
    @element.className = "mark"

    @element.innerHTML = """
      <div class="top-bar" style="position: relative; width:100%; height: 13px; top 0px; background-color: red;">
        <img class="close-icon" src="./images/icons/marking-closex.png" style="position: relative; top: -2px;">
      </div>
      <div class="left-border" style="position: absolute; top: 0px; left: 0px;width: 2px; height: 100%; background-color: red;z-index: 100;">
        <div class="left-handle" style="position: absolute; left: -5px; width: 12px; height: 12px; background-color: red; top: 50%; border-radius: 3px;"></div>
      </div>
      <div class="right-border" style="position: absolute; top: 0px; right: 0px; width: 2px; height: 100%; background-color: red; z-index: 100;">
        <div class="right-handle" style="position: absolute; right: -5px; width: 12px; height: 12px; background-color: red; top: 50%; border-radius: 3px;"></div>
      </div>
    """

    @element.style.left = @toCanvasXPoint(e) + "px"
    @element.style.position = 'absolute'
    @element.style.top = e.target.offsetTop + "px"
    @element.style.height = @canvas.height + 'px'
    @element.style.backgroundColor = 'rgba(255,0,0,.5)'
    @element.style.pointerEvents = 'auto'
    @element.style.textAlign = 'center'

    @startingPoint = @toCanvasXPoint(e) - MIN_WIDTH
    @dragging = false

    @element.addEventListener 'mousemove', @updateCursor
    @element.addEventListener 'mousedown', @onMouseDown

  draw: (e) ->
    markLeftX = Math.max @startingPoint - MAX_WIDTH, Math.min @startingPoint, @toCanvasXPoint(e)
    markRightX = Math.max @startingPoint, @toCanvasXPoint(e)

    width = (Math.min (Math.max (Math.abs markRightX - markLeftX), MIN_WIDTH), MAX_WIDTH)

    @element.style.left = markLeftX + "px"
    @element.style.width = width + "px"

    @save(markLeftX, markLeftX+width)

  move: (e) ->
    leftXPos = (@toCanvasXPoint(e) - @pointerOffset)
    @element.style.left = leftXPos + "px"
    @save(leftXPos, leftXPos+parseInt(@element.style.width, 10))

  save: (markLeftX, markRightX) ->
    #canvas coords
    @canvasXMin = markLeftX
    @canvasXMax = markRightX

    #data coords
    @dataXMin = @canvasGraph.toDataXCoord(@canvasXMin)
    @dataXMax = @canvasGraph.toDataXCoord(@canvasXMax)

  updateCursor: (e) =>
    switch e.target.className
      when "mark" then @element.style.cursor = "move"
      when "left-border" then @element.style.cursor = "ew-resize"
      when "right-border" then @element.style.cursor = "ew-resize"
      when "top-bar" then @element.style.cursor = "pointer"

  onMouseMove: (e) =>
    e.preventDefault()
    @draw(e) if @dragging
    @move(e) if @moving

  onMouseDown: (e) =>
    e.preventDefault()
    window.addEventListener 'mousemove', @onMouseMove
    window.addEventListener 'mouseup', @onMouseUp
    window.addEventListener 'touchmove', @onMouseMove

    @element.parentNode.appendChild(@element) #move to end of container for z index

    if e.target.className is "right-border" or e.target.className is "right-handle"
      @startingPoint = @canvasXMin
      @dragging = true
    else if e.target.className is "left-border" or e.target.className is "left-handle"
      @startingPoint = @canvasXMax
      @dragging = true
    else if e.target.className is "mark"
      @moving = true
      @pointerOffset = (@toCanvasXPoint(e) - @canvasXMin)

  onMouseUp: (e) =>
    e.preventDefault()
    window.removeEventListener 'mousemove', @onMouseMove
    window.removeEventListener 'mouseup', @onMouseUp
    window.removeEventListener 'touchmove', @onMouseMove
    @canvasGraph.marks.add(@) unless (@ in @canvasGraph.marks.all)
    @canvasGraph.marks.remove(@) if e.target.className is "top-bar" or e.target.className is "close-icon"
    for mark in @canvasGraph.marks.all
      mark.dragging = false
      mark.moving = false

    mouseChange = new Event("mark-change")
    document.dispatchEvent(mouseChange)

  toCanvasXPoint: (e) -> e.pageX - @canvas.getBoundingClientRect().left - window.scrollX

module?.exports = CanvasGraph: CanvasGraph, Marks: Marks, Mark: Mark
