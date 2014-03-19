$ = window.jQuery

class CanvasGraph
  constructor: (@canvas, @data) ->
    @ctx = @canvas.getContext('2d')
    # window.ctx = @ctx
    # window.canvas = @canvas
    # window.canvasGraph = @

    @smallestX = Math.min @data.x...
    @smallestY = Math.min @data.y...

    @largestX = Math.max @data.x...
    @largestY = Math.max @data.y...

    @dataLength = Math.min @data.x.length, @data.y.length

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
    for i in [0...@dataLength]
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

    @scale = (@largestX - @smallestX) / (@xMax - @xMin)

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

  sortedXCoords: ->
    allXPoints = ([mark.canvasXMin, mark.canvasXMax] for mark in @all)
    [].concat.apply([], allXPoints).sort (a, b) -> a - b
    # or
    # (allXPoints.reduce (a, b) -> a.concat b).sort (a, b) -> a - b

  closestXBelow: (xCoord) -> (@sortedXCoords().filter (i) -> i < xCoord).pop()

  closestXAbove: (xCoord) -> (@sortedXCoords().filter (i) -> i > xCoord).shift()

class Mark
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

    @startingPoint = @toCanvasXPoint(e) - @minWidth()
    @dragging = false

    @element.addEventListener 'mousemove', @updateCursor
    @element.addEventListener 'mousedown', @onMouseDown

  minWidth: -> 15 * (@canvasGraph.scale || 1)

  maxWidth: -> 150 * (@canvasGraph.scale || 1)

  draw: (e) ->
    markLeftX = Math.max @startingPoint - @maxWidth(), Math.min @startingPoint, @toCanvasXPoint(e)
    markRightX = Math.max @startingPoint, @toCanvasXPoint(e)


    markLeftX = (Math.max markLeftX, (@closestXBelow || markLeftX))
    markRightX = (Math.min markRightX, (@closestXAbove || markRightX))

    width = (Math.min (Math.max (Math.abs markRightX - markLeftX), @minWidth()), @maxWidth())


    @element.style.left = markLeftX + "px"
    @element.style.width = width + "px"

    @save(markLeftX, markLeftX+width)

  move: (e) ->
    markWidth = parseInt(@element.style.width, 10)
    leftXPos = Math.max (@toCanvasXPoint(e) - @pointerOffset), (@closestXBelow || 0)
    leftXPos = Math.min leftXPos, ((@closestXAbove || @canvas.width) - markWidth)

    markRightX = leftXPos + markWidth

    @element.style.left = leftXPos + "px"
    @save(leftXPos, markRightX)

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

    @closestXBelow = @canvasGraph.marks.closestXBelow(@canvasXMin)
    @closestXAbove = @canvasGraph.marks.closestXAbove(@canvasXMax)

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

    $(document).trigger("mark-change")

  toCanvasXPoint: (e) -> e.pageX - @canvas.getBoundingClientRect().left - window.scrollX

module?.exports = CanvasGraph: CanvasGraph, Marks: Marks, Mark: Mark
