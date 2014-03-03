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

    canvas.addEventListener 'mousemove', (e) =>
      e.preventDefault()
      @mark.draw(e) if @mark?.dragging
      @mark.move(e) if @mark?.moving
      @mark.resize(e) if @mark?.resizing
      @mark.updateCursor(e) if @mark?.hovering

  drawAxes: ->
    #draws non-scaled axes
    for num in [0..@canvas.width] by 100
      @ctx.moveTo(num-.5, 0)
      @ctx.lineTo(num-.5, @canvas.height)

    for num in [0..@canvas.height] by 100
      @ctx.moveTo(0, num-.5)
      @ctx.lineTo(@canvas.width, num-.5)

    @ctx.strokeStyle = "gray"
    @ctx.stroke()

  plotPoints: ->
    for point in @data
      x = ((point.x - @smallestX) / (@largestX - @smallestX)) * @canvas.width
      y = ((point.y - @largestY) / (@smallestY - @largestY)) * @canvas.height
      @ctx.fillStyle = "#fff"
      @ctx.fillRect(x, y,2,2)

    @scale = (@largestX - @smallestX) / @largestX

  plotZoomedPoints: (xMin, xMax) ->
    @clearCanvas()
    for point in @data
      x = ((point.x - xMin) / (xMax - xMin)) * @canvas.width
      y = ((point.y - @largestY) / (@smallestY - @largestY)) * @canvas.height
      @ctx.fillStyle = "#fff"
      @ctx.fillRect(x, y,2,2)

    @scale = 1 + (xMax - xMin) / @largestX

  rescale: ->
    @clearCanvas()
    @plotPoints()

  clearCanvas: -> @ctx.clearRect(0,0,@canvas.width, @canvas.height)

  mirrorVertically: ->
    @ctx.translate(0,@canvas.height)
    @ctx.scale(1,-1)

  toCanvasXCoord: (dataPoint) -> ((dataPoint - @smallestX) / (@largestX - @smallestX)) * @canvas.width

  toDataXCoord: (canvasPoint) -> (canvasPoint / @canvas.width) * (@largestX - @smallestX)

  # TODO: fix the math on this one....
  toDomXCoord: (dataPoint) -> ((dataPoint / @canvas.width) * (@largestX - @smallestX) * @canvas.width) + @canvas.getBoundingClientRect().left

class Marks
  constructor: -> @all = []

  create: (mark) -> document.getElementById('marks-container').appendChild(mark.element)

  add: (mark) -> @all.push(mark)

  remove: (mark) ->
    @all.splice(@all.indexOf(mark), 1)
    document.getElementById('marks-container').removeChild(mark.element)

  destroyAll: ->
    document.getElementById('marks-container').innerHTML = ""
    @all = []

class Mark
  constructor: (e, @canvasGraph) ->
    #TODO: make an active state

    @canvas = @canvasGraph.canvas

    @element = document.createElement('div')
    @element.className = "mark"

    @element.style.left = e.x + "px"
    @element.style.position =  'absolute'
    @element.style.top = e.target.offsetTop + "px"
    @element.style.height = @canvas.height - 13 + 'px' # subtract border height
    @element.style.backgroundColor = 'rgba(255,0,0,.5)'
    @element.style.border =  '2px solid red'
    @element.style.borderTop =  '13px solid red'

    @startingPoint = e.x
    @dragging = false

    @element.addEventListener 'mouseover', (e) => @hovering = true
    @element.addEventListener 'mousedown', (e) => @onMouseDown(e)
    @element.addEventListener 'mousemove', (e) => @onMouseMove(e)
    @element.addEventListener 'mouseup', (e) => @onMouseUp(e)
    @element.addEventListener 'click', (e) => @canvasGraph.marks.remove(@) if e.layerY < 15

  draw: (e) ->
    markLeftX = Math.min @startingPoint, e.x
    markRightX = Math.max @startingPoint, e.x

    @element.style.left = (Math.min markLeftX, markRightX) + "px"
    @element.style.width = (Math.abs markRightX - markLeftX) + "px"
    # @element.style.webkitTransform = "rotate(-2deg)" #whoa

    @save(markLeftX, markRightX)

  move: (e) ->
    leftXPos = (e.x-@pointerOffset)
    @element.style.left = leftXPos + "px"
    @save(leftXPos, leftXPos+parseInt(@element.style.width, 10))

  save: (markLeftX, markRightX) ->
    #dom coords
    @domXMin = markLeftX
    @domXMax = markRightX

    #canvas coords
    @canvasXMin = markLeftX - @canvasGraph.canvas.getBoundingClientRect().left
    @canvasXMax = markRightX - @canvasGraph.canvas.getBoundingClientRect().left

    #data coords
    @dataXMin = @canvasGraph.toDataXCoord(@canvasXMin)
    @dataXMax = @canvasGraph.toDataXCoord(@canvasXMax)

  updateCursor: (e) ->
    if ((Math.abs e.layerX - (@domXMax-@domXMin)) < 10) || e.layerX < 10
      @element.style.cursor = "ew-resize"
    else if e.layerY < 15
      @element.style.cursor = "pointer"
    else
      @element.style.cursor = "move"

  onMouseMove: (e) ->
    @draw(e) if @dragging
    @move(e) if @moving
    @updateCursor(e) if @hovering

  onMouseDown: (e) ->
    if (Math.abs e.layerX - (@domXMax-@domXMin)) < 10
      @startingPoint = @domXMin
      @dragging = true
    else if e.layerX < 10
      @startingPoint = @domXMax
      @dragging = true
    else if e.layerY > 15
      @moving = true
      @pointerOffset = (e.x-@domXMin)

  onMouseUp: (e) ->
    if @dragging
      @canvasGraph.marks.add(@)
      document.getElementById('points').innerHTML += "x1: #{@dataXMin}, x2: #{@dataXMax}</br>"
      console.log "Marks", @canvasGraph.marks
      @dragging = false
    else if @moving
      @save(@domXMin, @domXMax)
      @moving = false

module?.exports = CanvasGraph: CanvasGraph, Marks: Marks, Mark: Mark
