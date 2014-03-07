class CanvasGraph
  constructor: (@canvas, @data) ->
    @ctx = @canvas.getContext('2d')
    window.ctx = @ctx
    window.canvas = @canvas
    window.canvasGraph = @

    @smallestX = Math.min (point.x for point in @data)...
    @smallestY = Math.min (point.y for point in @data)...

    @largestX = Math.max (point.x for point in @data)...
    @largestY = Math.max (point.y for point in @data)...

    @marks = new Marks
    window.marks = @marks
    # @mirrorVertically()

    canvas.addEventListener 'mousedown', (e) =>
      e.preventDefault()
      @mark = new Mark(e, @)
      @marks.create(@mark)
      @mark.dragging = true
      @mark.draw(e)

  plotPoints: (xMin = @smallestX, xMax = @largestX) ->
    @xMin = xMin
    @xMax = xMax
    @clearCanvas()
    for point in @data
      x = ((point.x - xMin) / (xMax - xMin)) * @canvas.width
      y = ((point.y - @largestY) / (@smallestY - @largestY)) * @canvas.height
      @ctx.fillStyle = "#fff"
      @ctx.fillRect(x, y,2,2)

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

  update: (mark) -> @all[@all.indexOf(mark)] = mark

  remove: (mark) ->
    @all.splice(@all.indexOf(mark), 1)
    document.getElementById('marks-container').removeChild(mark.element)

  destroyAll: ->
    document.getElementById('marks-container').innerHTML = ""
    @all = []

class Mark
  MIN_WIDTH = 10
  MAX_WIDTH = 150

  #move to end of marks-container on mousedown => for mousedown event

  constructor: (e, @canvasGraph) ->
    @canvas = @canvasGraph.canvas

    @element = document.createElement('div')
    @element.className = "mark"

    @element.innerHTML = """
      <img class="close-icon" src="./images/icons/marking-closex.png" style="position: relative; top: -15px;">
      <div class="left-handle" style="position: absolute; left: -7px; width: 12px; height: 12px; background-color: red; top: 190px; border-radius: 3px;"></div>
      <div class="right-handle" style="position: absolute; right: -7px; width: 12px; height: 12px; background-color: red; top: 190px; border-radius: 3px;"></div>
    """

    @element.style.left = @pointerXInElement(e) + "px"
    @element.style.position = 'absolute'
    @element.style.top = e.target.offsetTop + "px"
    @element.style.height = @canvas.height - 15 + 'px' # subtract vertical borders
    @element.style.backgroundColor = 'rgba(255,0,0,.5)'
    @element.style.border =  '2px solid red'
    @element.style.borderTop =  '13px solid red'
    @element.style.pointerEvents = 'auto'
    @element.style.textAlign = 'center'

    @startingPoint = @toCanvasXPoint(e) - MIN_WIDTH
    @dragging = false

    @element.addEventListener 'mouseover', => @hovering = true
    @element.addEventListener 'mouseout', => @hovering = false
    @element.addEventListener 'mousedown',
      @onMouseDown
      window.addEventListener 'mousemove', @onMouseMove
      window.addEventListener 'mouseup', @onMouseUp
    @element.addEventListener 'mouseup', @onMouseUp
    @element.addEventListener 'click', (e) => @canvasGraph.marks.remove(@) if @pointerYInElement(e) < 15

  draw: (e) ->
    markLeftX = Math.min @startingPoint, @toCanvasXPoint(e)
    markRightX = Math.max @startingPoint, @toCanvasXPoint(e)

    width = (Math.min (Math.max (Math.abs markRightX - markLeftX), MIN_WIDTH), MAX_WIDTH)

    @element.style.left = (Math.min markLeftX, markRightX) + "px"
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
    if @pointerYInElement(e) < 15
      @element.style.cursor = "pointer"
    else if ((Math.abs @pointerXInElement(e) - (@canvasXMax-@canvasXMin)) < 10) || @pointerXInElement(e) < 10
      @element.style.cursor = "ew-resize"
    else
      @element.style.cursor = "move"

  onMouseMove: (e) =>
    e.preventDefault()
    @draw(e) if @dragging
    @move(e) if @moving
    @updateCursor(e) if @hovering

  onMouseDown: (e) =>
    e.preventDefault()

    console.log "E from onmousedown", e
    @element.parentNode.appendChild(@element) #move to end of container for z index
    if (Math.abs @pointerXInElement(e) - (@canvasXMax-@canvasXMin)) < 10
      @startingPoint = @canvasXMin
      @dragging = true
    else if @pointerXInElement(e) < 10
      @startingPoint = @canvasXMax
      @dragging = true
    else if @pointerYInElement(e) > 15
      @moving = true
      @pointerOffset = (@toCanvasXPoint(e) - @canvasXMin)

  onMouseUp: (e) =>
    e.preventDefault()
    for mark in @canvasGraph.marks.all
      mark.dragging = false
      mark.moving = false
    if (@ in @canvasGraph.marks.all) then @canvasGraph.marks.update(@) else @canvasGraph.marks.add(@)
    @dragging = false
    @moving = false
    window.removeEventListener 'mousemove', @onMouseMove
    window.removeEventListener 'mouseup', @onMouseUp

  toCanvasXPoint: (e) -> e.pageX - @canvas.getBoundingClientRect().left - window.scrollX

  pointerXInElement: (e) -> e.offsetX || e.clientX - e.target.offsetLeft + window.pageXOffset - @canvas.getBoundingClientRect().left

  pointerYInElement: (e) -> e.offsetY || e.clientY - e.target.offsetTop + window.pageYOffset - @canvas.getBoundingClientRect().top

module?.exports = CanvasGraph: CanvasGraph, Marks: Marks, Mark: Mark
