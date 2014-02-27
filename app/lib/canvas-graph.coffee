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
      @dragging = true
      @mark = new Mark(e, @)
      @marks.create(@mark)
      @mark.draw(e)

    canvas.addEventListener 'mousemove', (e) =>
      @mark.draw(e) if @dragging
        
    canvas.addEventListener 'mouseup', (e) =>
      @dragging = false
      @marks.add(@mark)

      document.getElementById('points').innerHTML += "x1: #{@mark.dataXMin}, x2: #{@mark.dataXMax}</br>"
      console.log @marks

      # console.log e.x-@getBoundingClientRect().left, e.y-@getBoundingClientRect().top

    # zoomBtn = document.getElementById('toggle-zoom')
    # zoomBtn.addEventListener 'click', (e) =>
    #   @zoomed = !@zoomed
    #   if @zoomed then canvasState.plotZoomedPoints(5,20) else canvasState.rescale()

    @dragging = false

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

  drawAll: (scale = 1) ->

class Mark
  constructor: (e, @canvasGraph) ->
    @element = document.createElement('div')
    @element.className = "mark"

    @element.style.left = e.x + "px"
    @element.style.position =  'absolute'
    @element.style.top = e.target.offsetTop + "px" # used to be .getBoundingClientRect().top
    @element.style.height = @canvasGraph.canvas.height - 13 + 'px' # subtract border height
    @element.style.backgroundColor = 'rgba(255,0,0,.5)'
    @element.style.border =  '2px solid red'
    @element.style.borderTop =  '13px solid red'
    @element.style.pointerEvents = 'none'

    @startingPoint = e.x

  draw: (e) ->
    markLeftX = Math.min @startingPoint, e.x
    markRightX = Math.max @startingPoint, e.x

    @element.style.left = (Math.min markLeftX, markRightX) + "px"
    @element.style.width = (Math.abs markRightX - markLeftX) + "px"
    # @element.style.webkitTransform = "rotate(-2deg)" #whoa

    #dom coords
    @domXMin = markLeftX
    @domXMax = markRightX

    #canvas coords
    @canvasXMin = markLeftX - @canvasGraph.canvas.getBoundingClientRect().left
    @canvasXMax = markRightX - @canvasGraph.canvas.getBoundingClientRect().left

    #data coords
    @dataXMin = @canvasGraph.toDataXCoord(@canvasXMin)
    @dataXMax = @canvasGraph.toDataXCoord(@canvasXMax)


  # move: ->

module?.exports = CanvasGraph: CanvasGraph, Marks: Marks, Mark: Mark
