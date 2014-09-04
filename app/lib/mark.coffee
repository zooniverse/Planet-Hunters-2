class Mark
  constructor: (e, @canvasGraph, @originalMin) ->
    @timestamp = (new Date).toUTCString()
    @zoomLevelAtCreation = @canvasGraph.zoomLevel
    @canvas = @canvasGraph.canvas

    @element = document.createElement('div')
    @element.className = "mark"

    @element.innerHTML = """
      <div class="top-bar">
        <img src="./images/icons/close-x.svg" class="close-icon">
      </div>
      <div class="left-border">
        <div class="left-handle">III</div>
      </div>
      <div class="right-border">
        <div class="right-handle">III</div>
      </div>
    """

    @element.style.left = parseFloat(@toCanvasXPoint(e)) + "px"
    @element.style.top = e.target.offsetTop + "px"
    @element.style.height = (@canvas.height - 2) + 'px'

    val = classifier.el.find('#ui-slider').val()
    @initialLeft = @toCanvasXPoint(e) - (@minWidth()/2)
    @dragging = true

    # create event listeners
    @element.addEventListener 'mousedown', @onMouseDown
    @element.addEventListener 'touchstart', @onMouseDown
    @element.addEventListener 'mouseout', @onMouseOut

  toPixels: (dataPoint) -> ((parseFloat(dataPoint) - parseFloat(@xMin)) / (parseFloat(@xMax) - parseFloat(@xMin))) * (parseFloat(@canvas.width)-parseFloat(@leftPadding))

  minWidth: -> 10

  maxWidth: -> 200 * @canvasGraph.scale

  handleWidth: -> 16 * (@canvasGraph.scale || 1)

  draw: (e) ->
    markLeftX = Math.max @initialLeft + @minWidth() - @maxWidth(),
                         Math.min @initialLeft, @toCanvasXPoint(e)

    markRightX = Math.max @initialLeft + @minWidth(), @toCanvasXPoint(e)

    # no overlapping of marks
    markLeftX = Math.max markLeftX,
                        (@closestXBelow + @handleWidth()/2 || markLeftX),
                        (@canvasGraph.toPixels(@canvasGraph.smallestX))

    markRightX = Math.min markRightX,
                         (@closestXAbove - @handleWidth()/2 || markRightX),
                         (@canvasGraph.toPixels(@canvasGraph.largestX))

    # max and min width on creating / resizing marks
    width = Math.min (Math.max (Math.abs parseFloat(markRightX) - parseFloat(markLeftX)), parseFloat(@minWidth())), parseFloat(@maxWidth())
    # console.log 'WIDTH: ', parseFloat(width), ' (pixels)'
    # console.log 'WIDTH: ', @canvasGraph.toDays(parseFloat(width)), ' (days)'

    @element.style.left = parseFloat(markLeftX) + "px"
    @element.style.width = parseFloat(width) + "px"
    @save markLeftX, (markLeftX + width)

  move: (e) ->
    markWidth = parseFloat @element.style.width
    
    # no overlapping of marks or moving out of canvas bounds
    leftXPos = Math.max (@toCanvasXPoint(e) - @moveOffset),
                        (@closestXBelow || -@handleWidth()/2) + @handleWidth()/2,
                        @canvasGraph.leftPadding
    leftXPos = Math.min leftXPos,
                        ((@closestXAbove || @canvas.width + @handleWidth()/2) - markWidth) - @handleWidth()/2

    markRightX = leftXPos + markWidth
    @element.style.left = leftXPos + "px"
    @save leftXPos, markRightX

  save: (@canvasXMin, @canvasXMax) ->
    #data coords
    @dataXMinRel = @canvasGraph.toDays(@canvasXMin-@canvasGraph.leftPadding)
    @dataXMaxRel = @canvasGraph.toDays(@canvasXMax-@canvasGraph.leftPadding)
    @dataXMinGlobal = @dataXMinRel + @originalMin    
    @dataXMaxGlobal = @dataXMaxRel + @originalMin

  onMouseDown: (e) =>
    return if @canvasGraph.markingDisabled
    e.preventDefault()
    window.addEventListener 'mousemove', @onMouseMove
    window.addEventListener 'mouseup', @onMouseUp
    window.addEventListener 'touchmove', @onMouseMove
    window.addEventListener 'touchend' , @onTouchEnd

    @element.parentNode.appendChild(@element) #move to end of container for z index

    if e.target.className is "right-border" or e.target.className is "right-handle"
      @initialLeft = @canvasXMin
      @dragging = true
    else if e.target.className is "left-border" or e.target.className is "left-handle"
      @initialLeft = @canvasXMax - @minWidth()
      @dragging = true
    else if e.target.className is "mark"
      @moving = true

    @moveOffset = (@toCanvasXPoint(e) - @canvasXMin)
    @closestXBelow = @canvasGraph.marks.closestXBelow(@canvasXMin)
    @closestXAbove = @canvasGraph.marks.closestXAbove(@canvasXMax)

  onMouseMove: (e) =>
    e.preventDefault()
    @draw(e) if @dragging
    @move(e) if @moving

  onTouchEnd: (e) => # for touch devices
    e.preventDefault()
    window.removeEventListener 'mousemove', @onMouseMove
    window.removeEventListener 'mouseup', @onMouseUp
    window.removeEventListener 'touchmove', @onMouseMove
    window.removeEventListener 'touchend', @onTouchEnd
    
    @canvasGraph.marks.add(@) unless (@ in @canvasGraph.marks.all)
    @canvasGraph.marks.remove(@) if e.target.className is "top-bar" or e.target.className is "close-icon"
    for mark in @canvasGraph.marks.all
      mark.dragging = false
      mark.moving = false

  onMouseUp: (e) =>
    @onTouchEnd(e)
    # ensure points inside mark (otherwise delete)
    unless @containsPoints(@canvasGraph.data.x)
      marks.remove(@)
      classifier.notify 'You\'ve marked a gap (where we have no data about the star). Please ignore those regions.'
      @canvasGraph.shakeGraph()
    $(document).trigger("mark-change")

  containsPoints: (xValues) =>
    for value in xValues
      if value <= @dataXMaxRel and value >= @dataXMinRel
        return true
    return false

  toCanvasXPoint: (e) ->
    e.pageX - @canvas.getBoundingClientRect().left - window.scrollX

module.exports = Mark
