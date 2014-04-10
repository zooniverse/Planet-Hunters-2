$ = window.jQuery

class CanvasGraph
  constructor: (@canvas, @data) ->
    console.log 'CanvasGraph.constructor()'
    # debugger
    @ctx = @canvas.getContext('2d')

    @smallestX = Math.min @data.x...
    @smallestY = Math.min @data.y...

    @largestX = Math.max @data.x...
    @largestY = Math.max @data.y...

    # for value in [@data.y...]
    #   if value is +0
    #     console.log 'ZERO!'
    #     value = @smallestY

    # for value in [@data.x...]
    #   value = value - @smallestX


    @normalize(@data.y)


    @dataLength = Math.min @data.x.length, @data.y.length

  enableMarking: ->
    @marks = new Marks
    window.marks = @marks

    @canvas.addEventListener 'mousedown', (e) => @addMarkToGraph(e)
    @canvas.addEventListener 'touchstart', (e) => @addMarkToGraph(e)


  plotPoints: (xMin = @smallestX, xMax = @largestX) ->
    @xMin = xMin
    @xMax = xMax
    @clearCanvas()

    # console.log 'points: ', {@data.x, @data.y}
    for i in [0...@dataLength]
      x = ((+@data.x[i] - xMin) / (xMax - xMin)) * @canvas.width
      y = ((+@data.y[i] - @largestY) / (@smallestY - @largestY)) * @canvas.height
      @ctx.fillStyle = "#fff"
      @ctx.fillRect(x,y,2,2)

    if @marks
      for mark in @marks.all
        scaledMin = ((mark.dataXMin - xMin) / (xMax - xMin)) * @canvas.width
        scaledMax = ((mark.dataXMax - xMin) / (xMax - xMin)) * @canvas.width

        mark.element.style.width = (scaledMax-scaledMin) + "px"
        mark.element.style.left = (scaledMin) + "px"

        mark.save(scaledMin, scaledMax)

    @scale = (@largestX - @smallestX) / (@xMax - @xMin)

  normalize: (values) ->
    y_norm = []
    # console.log 'y_values: ', @data.y
    console.log 'yMin: ', @smallestY
    console.log 'yMax: ', @largestY

    for y, i in [@data.y...]
      y_norm[i] =  ( parseFloat(y) - @yMin ) / ( @yMax - @yMin )
    
    console.log 'y: ', @data.y
    console.log 'norm: ', y_norm

  zoomInTo: (wMin, wMax) ->
    [cMin, cMax] = [@xMin, @xMax]

    zoom = setInterval (=>
      @plotPoints(cMin,cMax)
      cMin += 1.5 unless cMin >= wMin
      cMax -= 1.5 unless cMax <= wMax
      if cMin >= wMin and cMax <= wMax
        clearInterval zoom
        @plotPoints(wMin,wMax)
    ), 30

  zoomOut: ->
    [cMin, cMax] = [@xMin, @xMax]
    [wMin, wMax] = [@smallestX, @largestX]

    zoom = setInterval (=>
      @plotPoints(cMin,cMax)
      cMin -= 1.5 unless cMin <= wMin
      cMax += 1.5 unless cMax >= wMax
      if cMin <= wMin and cMax >= wMax
        clearInterval zoom
        @plotPoints(wMin, wMax)
    ), 30

  clearCanvas: -> @ctx.clearRect(0,0,@canvas.width, @canvas.height)

  mirrorVertically: ->
    @ctx.translate(0,@canvas.height)
    @ctx.scale(1,-1)

  toCanvasXCoord: (dataPoint) -> ((dataPoint - @xMin) / (@xMax - @xMin)) * @canvas.width

  toDataXCoord: (canvasPoint) -> ((canvasPoint / @canvas.width) * (@xMax - @xMin)) + @xMin

  addMarkToGraph: (e) =>
    e.preventDefault()
    unless @marks.markTooCloseToAnotherMark(e, @scale)
      @mark = new Mark(e, @)
      @marks.create(@mark)
      @mark.draw(e)
      @mark.onMouseDown(e)

class Marks
  constructor: -> @all = []

  create: (mark) -> document.getElementById('marks-container').appendChild(mark.element)

  add: (mark) -> @all.push(mark)

  remove: (mark) ->
    @all.splice(@all.indexOf(mark), 1)
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

  toCanvasXPoint: (e) -> e.pageX - e.target.getBoundingClientRect().left - window.scrollX

  markTooCloseToAnotherMark: (e, scale) ->
    mouseLocation = @toCanvasXPoint(e)
    markBelow = Math.abs mouseLocation - @closestXBelow(mouseLocation)
    markAbove = Math.abs mouseLocation - @closestXAbove(mouseLocation)
    # 22 is width of mark plus some room on each side
    markBelow < (22*scale) or markAbove < (22*scale) or mouseLocation in @sortedXCoords()

class Mark
  constructor: (e, @canvasGraph) ->
    @canvas = @canvasGraph.canvas

    @element = document.createElement('div')
    @element.className = "mark"

    bgColor = "#fc4541"
    @element.innerHTML = """
      <div class="top-bar" style="position: relative; width:100%; height: 13px; top 0px; background-color: #{bgColor}; cursor: pointer;">
        <img class="close-icon" src="./images/icons/marking-closex.png" style="position: relative; bottom: 4px;">
      </div>
      <div class="left-border" style="position: absolute; top: 0px; left: -1px;width: 2px; height: 100%; background-color: #{bgColor}; padding-bottom: 2px; z-index: 100; cursor: ew-resize;">
        <div class="left-handle" style="position: absolute; left: -5px; width: 12px; height: 12px; background-color: #{bgColor}; top: 50%; border-radius: 3px; color: #b7061e; font-size: 8px; letter-spacing: 1px;">III</div>
      </div>
      <div class="right-border" style="position: absolute; top: 0px; right: -1px; width: 2px; height: 100%; background-color: #{bgColor}; padding-bottom: 2px; z-index: 100; cursor: ew-resize;">
        <div class="right-handle" style="position: absolute; right: -5px; width: 12px; height: 12px; background-color: #{bgColor}; top: 50%; border-radius: 3px; color: #b7061e; font-size: 8px; letter-spacing: 1px;">III</div>
      </div>
    """

    @element.style.left = @toCanvasXPoint(e) + "px"
    @element.style.position = 'absolute'
    @element.style.top = e.target.offsetTop + "px"
    @element.style.height = (@canvas.height - 2) + 'px'
    @element.style.backgroundColor = 'rgba(252,69,65,.6)'
    @element.style.borderBottom = "2px solid #{bgColor}"
    @element.style.pointerEvents = 'auto'
    @element.style.textAlign = 'center'
    @element.style.cursor = "move"

    @startingPoint = @toCanvasXPoint(e) - (@minWidth()/2)

    @dragging = true

    @element.addEventListener 'mousedown', @onMouseDown
    @element.addEventListener 'touchstart', @onMouseDown

  minWidth: -> 15 * (@canvasGraph.scale || 1)

  maxWidth: -> 150 * (@canvasGraph.scale || 1)

  handleWidth: -> 16 * (@canvasGraph.scale || 1)

  draw: (e) ->
    markLeftX = Math.max @startingPoint + @minWidth() - @maxWidth(),
                         Math.min @startingPoint, @toCanvasXPoint(e)

    markRightX = Math.max @startingPoint + @minWidth(), @toCanvasXPoint(e)

    # no overlapping of marks
    markLeftX = Math.max markLeftX,
                        (@closestXBelow + @handleWidth() || markLeftX),
                        (@canvasGraph.toCanvasXCoord(@canvasGraph.smallestX))

    markRightX = Math.min markRightX,
                         (@closestXAbove - @handleWidth() || markRightX),
                         (@canvasGraph.toCanvasXCoord(@canvasGraph.largestX))

    # max and min width on creating / resizing marks
    width = (Math.min (Math.max (Math.abs markRightX - markLeftX), @minWidth()), @maxWidth())

    @element.style.left = markLeftX + "px"
    @element.style.width = width + "px"

    @save(markLeftX, markLeftX+width)

  move: (e) ->
    markWidth = parseInt(@element.style.width, 10)

    # no overlapping of marks or moving out of canvas bounds
    leftXPos = Math.max (@toCanvasXPoint(e) - @pointerOffset),
                        (@closestXBelow || -@handleWidth()) + @handleWidth()
    leftXPos = Math.min leftXPos,
                        ((@closestXAbove || @canvas.width + @handleWidth()) - markWidth) - @handleWidth()

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

  onMouseMove: (e) =>
    e.preventDefault()
    @draw(e) if @dragging
    @move(e) if @moving

  onMouseDown: (e) =>
    e.preventDefault()
    window.addEventListener 'mousemove', @onMouseMove
    window.addEventListener 'mouseup', @onMouseUp
    window.addEventListener 'touchmove', @onMouseMove
    window.addEventListener 'touchend' , @onMouseUp

    @element.parentNode.appendChild(@element) #move to end of container for z index

    if e.target.className is "right-border" or e.target.className is "right-handle"
      @startingPoint = @canvasXMin
      @dragging = true
    else if e.target.className is "left-border" or e.target.className is "left-handle"
      @startingPoint = @canvasXMax - @minWidth()
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
    window.removeEventListener 'touchend', @onMouseUp
    @canvasGraph.marks.add(@) unless (@ in @canvasGraph.marks.all)
    @canvasGraph.marks.remove(@) if e.target.className is "top-bar" or e.target.className is "close-icon"
    for mark in @canvasGraph.marks.all
      mark.dragging = false
      mark.moving = false

    $(document).trigger("mark-change")

  toCanvasXPoint: (e) -> e.pageX - @canvas.getBoundingClientRect().left - window.scrollX

module?.exports = CanvasGraph: CanvasGraph, Marks: Marks, Mark: Mark
