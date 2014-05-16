# $ = window.jQuery

class CanvasGraph
  constructor: (@canvas, @data) ->
    @ctx = @canvas.getContext('2d')

    @smallestX = Math.min @data.x...
    @smallestY = Math.min @data.y...
    @largestX  = Math.max @data.x...
    @largestY  = Math.max @data.y...

    @dataLength = Math.min @data.x.length, @data.y.length

    @originalMin = @smallestX
    for xValue, idx in [@data.x...]
      @data.x[idx] = xValue - @smallestX

    # remove outliers and normalize
    @removeOutliers(nsigma=3)

    # update min/max values
    @smallestX = Math.min @data.x...
    @smallestY = Math.min @data.y...
    @largestX = Math.max  @data.x...
    @largestY = Math.max  @data.y...

    @prevZoomMin = @smallestX
    @prevZoomMax = @largestX

    @leftPadding = 60

  disableMarking: ->
    @markingDisabled = true

  enableMarking: ->
    @markingDisabled = false
    @marks = new Marks
    window.marks = @marks
    @canvas.addEventListener 'mousedown', (e) => @onMouseDown(e)
    @canvas.addEventListener 'touchstart', (e) => @addMarkToGraph(e)
    @canvas.addEventListener 'mousemove', (e) => @onMouseMove(e) # TODO: FIX (disabled for now)

  onMouseDown: (e) =>
    console.log 'onMouseDown()'
    xClick = e.pageX - e.target.getBoundingClientRect().left - window.scrollX
    return if xClick < 80 # display line instead 
    @addMarkToGraph(e)

  onMouseMove: (e) =>
    # console.log 'onMouseMove()'
    return if classifier.el.find('#graph').hasClass('is-zooming')
    zoomLevel = classifier.zoomLevel
    zoomRanges = classifier.zoomRanges
    val = +classifier.el.find("#ui-slider").val()
    xClick = e.pageX - e.target.getBoundingClientRect().left - window.scrollX
    yClick = e.pageY - e.target.getBoundingClientRect().top - window.scrollY
    
    # @plotPoints(classifier.prevZoomMin, classifier.prevZoomMax)
    @plotPoints(val, val+zoomRanges[zoomLevel])

    # # DEBUG CODE
    # console.log 'onClickZoom(): '
    # console.log 'SLIDER VALUE: ', val
    # console.log 'PLOT RANGE [', val, ',', val+zoomRanges[zoomLevel], ']'
    # console.log '--------------------------------------------------------'

    if xClick < 80
      @ctx.fillStyle = '#FC4542'      
      # draw triangle
      w = 10
      s = w*Math.tan(60)
      @ctx.beginPath()
      @ctx.moveTo(w,yClick)
      @ctx.lineTo(0,yClick+s)
      @ctx.lineTo(0,yClick-s)
      @ctx.fill()
      @ctx.font = '10pt Arial'
      @ctx.textAlign = 'left'
      @ctx.lineWidth = 1
      @ctx.strokeStyle = 'rgba(252,69,66,0.5)'
      @ctx.beginPath() 
      @ctx.moveTo( 60, yClick )
      @ctx.lineTo( @canvas.width, yClick )
      @ctx.moveTo( 0, yClick )
      @ctx.lineTo( 10, yClick )
      @ctx.fillText( @toDataYCoord((-yClick+@canvas.height)).toFixed(4), 15, yClick+5 ) # don't forget to flip y-axis values
      @ctx.stroke()

  removeOutliers: (nsigma) ->
    mean = @mean(@data.y)
    std = @std(@data.y)
    x_new = []
    y_new = []
    for value, i in [@data.y...]
      if Math.sqrt( Math.pow( value - mean, 2 ) ) > nsigma * std
        # console.log 'removed outlier!'
        continue
      else
        x_new.push @data.x[i]
        y_new.push @data.y[i]

    # normalize
    yMax = Math.max y_new...
    yMin = Math.min y_new...

    mean = @mean(y_new)
    std = @std(y_new)

    # console.log 'MEAN: ', mean
    # console.log 'STD : ', std

    for y, i in [ y_new... ]
      y_new[i] = (y-1)/(std)
      y_new[i] = y/(mean)
     
    @data.x = x_new
    @data.y = y_new


  std: (data) ->
    mean = @mean(data)
    sum = 0
    for value in data
      sum = sum + Math.pow( Math.abs(mean-value), 2 )
    return Math.sqrt( sum / data.length )

  mean: (data) ->
    # console.log 'mean()'
    # console.log 'length: ', data.length
    sum = 0
    for value in data
      sum = sum + value
    return sum / data.length

  showFakePrevMarks: () ->
    # console.log 'showFakePrevMarks()'
    @zoomOut( =>
      maxMarks = 5
      minMarks = 1 
      howMany = Math.floor( Math.random() * (maxMarks-minMarks) + minMarks )
      # console.log 'randomly generating ', howMany, ' (fake) marks' # DEBUG
      @generateFakePrevMarks( howMany )
      for entry in [@prevMarks...]
        # console.log '[',entry.xL,',',entry.xR,']' # DEBUG
        @highlightCurve(entry.xL,entry.xR)
      return howMany
    )

  generateFakePrevMarks: (n) ->
    minWid = 0.5 # [days]
    maxWid = 3.0
    xPos = []
    wid = []
    @prevMarks = []
    for i in [0...n]
      wid[i] = Math.random() * ( maxWid - minWid ) + minWid
      xPos[i] = Math.random() * (36-1) + 1
      @prevMarks[i] = { xL: xPos[i]-wid[i]/2, xR: xPos[i]+wid[i]/2 }

  showPrevMarks: ->
    for entry in [@prevMarks...]
      # console.log '[',entry.xL,',',entry.xR,']' # DEBUG
      @highlightCurve(entry.xL,entry.xR)

  highlightCurve: (xLeft,xRight) ->
    for i in [0...@dataLength]
      if @data.x[i] >= xLeft and @data.x[i] <= xRight
        x = ((+@data.x[i]-@xMin)/(@xMax-@xMin)) * @canvas.width
        y = ((+@data.y[i]-@yMin)/(@yMax-@yMin)) * @canvas.height
        y = -y + @canvas.height # flip y-values
        @ctx.fillStyle = "rgba(252, 69, 65, 0.65)" #"#fc4541"
        @ctx.fillRect(x+@leftPadding,y,2,2)
    return

  plotPoints: (xMin = @smallestX, xMax = @largestX, yMin = @smallestY, yMax = @largestY) ->
    @xMin = xMin
    @xMax = xMax
    @yMin = yMin
    @yMax = yMax
    @clearCanvas()

    val = classifier.el.find('#ui-slider').val()
    zoomRanges = classifier.zoomRanges
    zoomLevel  = classifier.zoomLevel

    # draw axes
    @drawXTickMarks(xMin, xMax)
    @drawYTickMarks(yMin, yMax)
    
    # plot points
    for i in [0...@dataLength]
      x = ((+@data.x[i]-xMin)/(xMax-xMin)) * @canvas.width
      y = ((+@data.y[i]-yMin)/(yMax-yMin)) * @canvas.height
      y = -y + @canvas.height # flip y-values
      @ctx.fillStyle = "#fff" #fc4541"
      @ctx.fillRect(x+@leftPadding,y,2,2)
    if @marks
      for mark in @marks.all
        scaledMin = ((mark.dataXMinRel - xMin) / (xMax - xMin)) * @canvas.width
        scaledMax = ((mark.dataXMaxRel - xMin) / (xMax - xMin)) * @canvas.width
        mark.element.style.width = (scaledMax-scaledMin) + "px"
        mark.element.style.left = (scaledMin) + "px"
        mark.save(scaledMin, scaledMax)
    # @highlightCurve(10,14) # test
    @scale = (@largestX - @smallestX) / (@xMax - @xMin)
    return

  drawXTickMarks: (xMin, xMax) ->
    # tick/text properties
    tickMinorLength = 5
    tickMajorLength = 10
    tickWidth = 1
    tickColor = '#323232'
    textColor = '#323232'
    textSpacing = 15

    # determine intervals
    xMag = Math.round( Math.abs(xMin-xMax) )
    if xMag <= 2 # days
      majorTickInterval = 4
      minorTickInterval = 16
      textInterval = 8
    else if xMag <= 10 # days
      majorTickInterval = 4
      minorTickInterval = 4
      textInterval = 4
    else # all days
      majorTickInterval = 2
      minorTickInterval = 1
      textInterval = 2

    # generate intervals
    xTicks = []
    xStep = 1/minorTickInterval
    i = 0
    xVal = Math.floor(xMin)
    while xVal <= Math.ceil(xMax)
      for j in [0...minorTickInterval]
        tick = xVal + j*xStep;
        unless tick > Math.ceil(xMax)
          xTicks.push tick
      i++
      xVal++

    for tick, i in [xTicks...]
      continue if i is 0 # skip first value

      # draw ticks (bottom)
      @ctx.beginPath() 
      @ctx.moveTo( @toCanvasXCoord(tick)+@leftPadding, @canvas.height )
      if i % majorTickInterval is 0
        @ctx.lineTo( @toCanvasXCoord(tick)+@leftPadding, @canvas.height - tickMajorLength ) # major tick
      else
        @ctx.lineTo( @toCanvasXCoord(tick)+@leftPadding, @canvas.height - tickMinorLength ) # minor tick
      @ctx.lineWidth = tickWidth
      @ctx.strokeStyle = tickColor
      @ctx.stroke()

      @ctx.font = '10pt Arial'
      @ctx.textAlign = 'center'
      @ctx.fillStyle = textColor

      # draw numbers (bottom)
      if (i % majorTickInterval) is 0 # zoomed out
        @ctx.fillText( tick, @toCanvasXCoord(tick), @canvas.height - textSpacing )
      else if (i % majorTickInterval) is 0
        @ctx.fillText( tick, @toCanvasXCoord(tick)+@leftPadding, @canvas.height - textSpacing )
      else if (i % majorTickInterval) is 0
        @ctx.fillText( tick, @toCanvasXCoord(tick)+@leftPadding, @canvas.height - textSpacing )

      # axis header
      @ctx.fillText( 'DAYS', textSpacing+10+@leftPadding, @canvas.height - textSpacing )

      # draw ticks (top)
      @ctx.beginPath() 
      @ctx.moveTo( @toCanvasXCoord(tick)+@leftPadding, 0 )
      if i % majorTickInterval is 0
        @ctx.lineTo( @toCanvasXCoord(tick)+@leftPadding, 0 + tickMajorLength ) # major tick
      else
        @ctx.lineTo( @toCanvasXCoord(tick)+@leftPadding, 0 + tickMinorLength ) # minor tick
      @ctx.lineWidth = tickWidth
      @ctx.strokeStyle = tickColor
      @ctx.stroke()

      # top numbers
      if (i % 4) is 0 # zoomed out
        @ctx.fillText( (tick + @originalMin).toFixed(2), @toCanvasXCoord(tick)+@leftPadding, 0 + textSpacing+10 )
      
  drawYTickMarks: (yMin, yMax) ->

    # console.log 'LIMITS [',yMin,',',yMax,']'
    
    # generate intervals
    yTicks = []
    yStep = Math.abs(yMin-yMax)/20
    meanTickIndexIsEven = false
    tickIdx = 0
    for stepFactor in [-10..10]
      tickValue = 1+stepFactor*yStep
      unless tickValue >= yMax or tickValue <=yMin
        if tickValue is 1.0 
          if (tickIdx%2 is 0)
            meanTickIndexIsEven = true
        yTicks.push tickValue
        tickIdx++

    if yStep < 0.001
      textDecimals = 4
    else
      textDecimals = 3

    tickMinorLength = 5
    tickMajorLength = 10
    tickWidth = 1
    tickColor = '#323232' #'rgba(200,20,20,1)' 
    textColor = '#323232'
    textSpacing = 15
    majorTickInterval = 2
    minorTickInterval = 1
    textInterval = 2

    # REQUIRED FOR MEAN NORMALIZATION
    yMean = @mean(@data.y)

    # # DRAW MEAN LINE (DEBUG PURPOSE)
    # yPos = -@toCanvasYCoord(yMean) + @canvas.height
    # @ctx.moveTo( 0, yPos )
    # @ctx.lineTo( @canvas.width, yPos ) # minor tick
    # @ctx.lineWidth = 1
    # @ctx.strokeStyle = tickColor
    # @ctx.stroke()

    for tick, i in [yTicks...]
      continue if i is 0               # skip first value
      continue if i is yTicks.length-1 # skip last value

      tickPos = @toCanvasYCoord(tick)     # transform to canvas coordinate
      tickPos = -tickPos + @canvas.height # flip y-axis

      # draw axis
      @ctx.font = '10pt Arial'
      @ctx.textAlign = 'left'
      @ctx.fillStyle = textColor
      @ctx.beginPath() 
      @ctx.moveTo( 0, tickPos )

      # make sure 1.00 (mean) tickmark is labeled
      if meanTickIndexIsEven
        if i % majorTickInterval is 0
          @ctx.lineTo( tickMajorLength, tickPos ) # major tick
          @ctx.fillText( tick.toFixed(textDecimals), 0+textSpacing, tickPos+5 )

        else
          @ctx.lineTo( tickMinorLength, tickPos ) # minor tick
      else
        if i % majorTickInterval-1 is 0
          @ctx.lineTo( tickMajorLength, tickPos ) # major tick
          @ctx.fillText( tick.toFixed(textDecimals), 0+textSpacing, tickPos+5 )

        else
          @ctx.lineTo( tickMinorLength, tickPos ) # minor tick

      @ctx.lineWidth = tickWidth
      @ctx.strokeStyle = tickColor
      @ctx.stroke()

  zoomInTo: (wMin, wMax) ->
    classifier.el.find('#graph').addClass('is-zooming')
    [cMin, cMax] = [@xMin, @xMax]

    zoom = setInterval (=>
      @plotPoints(cMin,cMax)
      cMin += 1.5 unless cMin >= wMin
      cMax -= 1.5 unless cMax <= wMax
      if cMin >= wMin and cMax <= wMax # when 'animation' is done...
        clearInterval zoom
        classifier.el.find('#graph').removeClass('is-zooming')
        @plotPoints(wMin,wMax)
    ), 30

  zoomOut: (callback) ->
    classifier.el.find('#graph').addClass('is-zooming')
    [cMin, cMax] = [@xMin, @xMax]
    [wMin, wMax] = [@smallestX, @largestX]
    zoom = setInterval (=>
      @plotPoints(cMin,cMax)
      cMin -= 1.5 unless cMin <= wMin
      cMax += 1.5 unless cMax >= wMax
      if cMin <= wMin and cMax >= wMax  # finished zooming
        clearInterval zoom
        classifier.el.find('#graph').removeClass('is-zooming')
        @plotPoints(wMin, wMax)
        unless callback is undefined 
          callback.apply()
          classifier.el.find("#zoom-button").removeClass("zoomed")
          classifier.el.find("#zoom-button").removeClass("allowZoomOut") # for last zoom level
          classifier.el.find('#ui-slider').attr('disabled',true)
          classifier.el.find('.noUi-handle').fadeOut(150)
    ), 30
    return

  clearCanvas: -> @ctx.clearRect(0,0,@canvas.width, @canvas.height)

  toCanvasXCoord: (dataPoint) -> ((dataPoint - @xMin) / (@xMax - @xMin)) * @canvas.width
  toCanvasYCoord: (dataPoint) -> ((dataPoint - @yMin) / (@yMax - @yMin)) * @canvas.height
  toDataXCoord: (canvasPoint) -> ((canvasPoint / @canvas.width) * (@xMax - @xMin)) + @xMin
  toDataYCoord: (canvasPoint) -> ((canvasPoint / @canvas.height) * (@yMax - @yMin)) + @yMin

  addMarkToGraph: (e) =>
    return if @markingDisabled
    e.preventDefault()
    if @marks.markTooCloseToAnotherMark(e, @scale, @originalMin)
      classifier.notify 'Marks may not overlap!'
      @shakeGraph()
      return

    # create new mark
    @mark = new Mark(e, @, @originalMin)
    # return unless @mark.containsPoints()
    @marks.appendElement(@mark)
    @mark.draw(e)
    @mark.onMouseDown(e)

  shakeGraph: ->
    graph = $('#graph-container')
    return if graph.hasClass('shaking')
    graph.addClass('shaking') 
    graph.effect( "shake", {times:4, distance: 2}, 700, =>
        graph.removeClass('shaking')
      ) # eventually remove jquery ui dependency?

class Marks
  constructor: -> @all = []
  appendElement: (mark) -> document.getElementById('marks-container').appendChild(mark.element)
  add: (mark) -> @all.push(mark)

  remove: (mark) ->
    @all.splice(@all.indexOf(mark), 1)
    document.getElementById('marks-container').removeChild(mark.element)

  destroyAll: ->
    mark.element.outerHTML = "" for mark in @all
    @all = []
    document.getElementById('marks-container')

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

# -------------------------
#  MARK CLASS
# -------------------------
class Mark
  constructor: (e, @canvasGraph, @originalMin) ->
    @canvas = @canvasGraph.canvas

    @element = document.createElement('div')
    @element.className = "mark"

    bgColor = "#fc4541"

    @element.innerHTML = """
      <div class="top-bar" style="position: relative; width:100%; height: 13px; top 0px; background-color: #{bgColor}; cursor: pointer;">
        <img class="close-icon" src="./images/icons/close-x.svg" style="position: relative; bottom: 4px;">
      </div>
      <div class="left-border" style="position: absolute; top: 0px; left: -1px;width: 2px; height: 100%; background-color: #{bgColor}; padding-bottom: 2px; z-index: 100; cursor: ew-resize;">
        <div class="left-handle" style="position: absolute; left: -5px; width: 12px; height: 12px; background-color: #{bgColor}; top: 50%; border-radius: 3px; color: #b7061e; font-size: 8px; letter-spacing: 1px;">III</div>
      </div>
      <div class="right-border" style="position: absolute; top: 0px; right: -1px; width: 2px; height: 100%; background-color: #{bgColor}; padding-bottom: 2px; z-index: 100; cursor: ew-resize;">
        <div class="right-handle" style="position: absolute; right: -5px; width: 12px; height: 12px; background-color: #{bgColor}; top: 50%; border-radius: 3px; color: #b7061e; font-size: 8px; letter-spacing: 1px;">III</div>
      </div>
    """

    # @element.getElementsByClassName('.left-handle').fadeOut()
    # # @element.find('.right-handle').fadeOut()

    @element.style.left = @toCanvasXPoint(e) + "px"
    @element.style.position = 'absolute'
    @element.style.top = e.target.offsetTop + "px"
    @element.style.height = (@canvas.height - 2) + 'px'
    @element.style.backgroundColor = 'rgba(252,69,65,.4)'
    @element.style.borderBottom = "2px solid #{bgColor}"
    @element.style.pointerEvents = 'auto'
    @element.style.textAlign = 'center'
    @element.style.cursor = "move"

    @startingPoint = @toCanvasXPoint(e) - (@minWidth()/2)
    @dragging = true
    @element.addEventListener 'mousedown', @onMouseDown
    @element.addEventListener 'touchstart', @onMouseDown
    @element.addEventListener 'mouseover', @onMouseOver
    @element.addEventListener 'mouseout', @onMouseOut

  minWidth: ->    @canvasGraph.scale * 10 #15 * (@canvasGraph.scale || 1)
  maxWidth: ->    @canvasGraph.scale * 75 #150 * (@canvasGraph.scale || 1)
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
    @dataXMinRel = @canvasGraph.toDataXCoord(@canvasXMin)
    @dataXMaxRel = @canvasGraph.toDataXCoord(@canvasXMax)
    @dataXMinGlobal = @dataXMinRel + @originalMin    
    @dataXMaxGlobal = @dataXMaxRel + @originalMin

  onMouseOver: (e) =>
    @element.style.backgroundColor = 'rgba(252,69,65,.6)'
    @element.children[1].children[0].style.visibility = "visible"
    @element.children[2].children[0].style.visibility = "visible"

  onMouseOut: (e) =>
    @element.style.backgroundColor = 'rgba(252,69,65,.4)'
    @element.children[1].children[0].style.visibility = "hidden"
    @element.children[2].children[0].style.visibility = "hidden"

  onMouseDown: (e) =>
    e.preventDefault()
    window.addEventListener 'mousemove', @onMouseMove
    window.addEventListener 'mouseup', @onMouseUp
    window.addEventListener 'touchmove', @onMouseMove
    window.addEventListener 'touchend' , @onTouchEnd

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

  toCanvasXPoint: (e) -> e.pageX - @canvas.getBoundingClientRect().left - window.scrollX

module?.exports = CanvasGraph: CanvasGraph, Marks: Marks, Mark: Mark
