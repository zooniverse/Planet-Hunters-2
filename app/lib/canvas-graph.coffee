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
    @removeOutliers(3)
    @data.y = @normalize(@data.y)





    # # normalize
    # yNorm = []
    # yMin = Math.min @data.y...
    # yMax = Math.max @data.y...
    # for yValue, i in [ @data.y... ]
    #   yNorm[i] = (+yValue-yMin)/(yMax-yMin)
    # @data.y = yNorm


    # normalize y values to unity mean
    yMean = @mean(@data.y)
    console.log 'yMean: ', yMean

    # for yValue, i in [ @data.y... ]
    #   @data.y[i] =  (@data.y[i]-@smallestY) / (@largestY-@smallestY)
      # console.log 'y: ', @data.y[i]

    # for yValue, i in [ @data.y... ]
    #   @data.y[i] = @data.y[i] / yMean
    #   console.log 'y: ', @data.y[i]


    # update min/max values
    @smallestX = Math.min @data.x...
    @smallestY = Math.min @data.y...
    @largestX = Math.max  @data.x...
    @largestY = Math.max  @data.y...

  normalize: (values) ->
    vMax = Math.max values...
    vMin = Math.min values...
    vMean = @mean(values)
    v_norm = []
    for v, i in [ values... ]
      v_norm[i] = (v-vMin)/(vMax-vMin)
      # v_norm[i] = v_norm[i] / vMean
    return v_norm 

  disableMarking: ->
    @markingDisabled = true

  enableMarking: ->
    @markingDisabled = false
    @marks = new Marks
    window.marks = @marks
    @canvas.addEventListener 'mousedown', (e) => @addMarkToGraph(e)
    @canvas.addEventListener 'touchstart', (e) => @addMarkToGraph(e)

  # drawYTickMarks: (domain, range, minorInt, majorInt) ->
  #   # draw scales
  #   tickMinorInterval = minorInt
  #   tickMajorInterval = majorInt
  #   tickMinorLength = 5
  #   tickMajorLength = 10
  #   tickWidth = 1
  #   tickColor = '#323232'
  #   textColor = '#323232'
  #   textSpacing = 15

  #   domainMin = Math.min(domain...)
  #   domainMax = Math.max(domain...)
  #   rangeMin = Math.min(range...)
  #   rangeMax = Math.max(range...)

  #   for i in domain
  #     # do not draw first, last tickmarks
  #     continue unless i isnt +Math.max(domain...)-1
  #     continue unless i isnt +Math.min(domain...)+1
  
  #     # draw minor tickmarks
  #     tick_y = Math.round ( (( +i - domainMin) / (domainMax - domainMin)) * rangeMax )
  #     if i % majorInt is 0
  #       @ctx.beginPath()
  #       @ctx.moveTo( rangeMin, tick_y )
  #       @ctx.lineTo( rangeMin+tickMajorLength, tick_y )
  #       @ctx.lineWidth = tickWidth
  #       @ctx.strokeStyle = tickColor
  #       @ctx.stroke()
  #     else if i % minorInt is 0
  #       @ctx.beginPath()
  #       @ctx.moveTo( rangeMin, tick_y )
  #       @ctx.lineTo( rangeMin+tickMinorLength, tick_y )
  #       @ctx.lineWidth = tickWidth
  #       @ctx.strokeStyle = tickColor
  #       @ctx.stroke()
  #       # print labels
  #       @ctx.font = '10pt Arial'
  #       @ctx.textAlign = 'center'
  #       @ctx.fillStyle = textColor
  #       y_scaled = 1 - +i/domainMax
  #       @ctx.fillText( y_scaled.toFixed(2), rangeMin+tickMajorLength+textSpacing, tick_y+tickMinorLength )

  removeOutliers: (nsigma) ->
    mean = @mean(@data.y)
    std = @std(@data.y)
    x_new = []
    y_new = []
    for value, i in [@data.y...]
      if Math.sqrt( Math.pow( value - mean, 2 ) ) > nsigma * std
        console.log 'removed outlier!'
        continue
      else
        x_new.push @data.x[i]
        y_new.push @data.y[i]
    @data.x = x_new
    @data.y = y_new

  std: (data) ->
    mean = @mean(data)
    sum = 0
    for value in data
      sum = sum + Math.pow( Math.abs(mean-value), 2 )
    return Math.sqrt( sum / data.length )

  mean: (data) ->
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
        @ctx.fillRect(x,y,2,2)
    return

  plotPoints: (xMin = @smallestX, xMax = @largestX, yMin = @smallestY, yMax = @largestY) ->
    @xMin = xMin
    @xMax = xMax
    @yMin = yMin
    @yMax = yMax
    @clearCanvas()

    # lightcurve on top of tickmarks?
    # @drawYTickMarks([0..20], [0..@canvas.height], 1, 2)
    # console.log 'LIMITS: [',xMin,',',xMax,']' 
    # @drawXTickMarks(xMin, xMax)
    @drawYTickMarks(yMin, yMax)
    
    # plot points
    for i in [0...@dataLength]
      x = ((+@data.x[i]-xMin)/(xMax-xMin)) * @canvas.width
      y = ((+@data.y[i]-yMin)/(yMax-yMin)) * @canvas.height
      y = -y + @canvas.height # flip y-values
      @ctx.fillStyle = "#fff" #fc4541"
      @ctx.fillRect(x,y,2,2)
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

  drawXTickMarks: (xMin, xMax, nIntervals) ->
    # generate intervals
    xTicks = []
    nIntervals = 8
    xStep = 1/nIntervals
    i = 0
    xVal = Math.floor(xMin)
    while xVal <= Math.ceil(xMax)
      for j in [0...nIntervals]
        tick = xVal + j*xStep;
        unless tick > Math.ceil(xMax)
          xTicks.push tick
      i++
      xVal++

    tickMinorLength = 5
    tickMajorLength = 10
    tickWidth = 1
    tickColor = '#323232'
    textColor = '#323232'
    textSpacing = 15

    for tick, i in [xTicks...]
      continue if i is 0 # skip first value
      # draw ticks
      @ctx.beginPath() 
      @ctx.moveTo( @toCanvasXCoord(tick), @canvas.height )
      if i % nIntervals is 0
        @ctx.lineTo( @toCanvasXCoord(tick), @canvas.height - tickMajorLength ) # major tick
      else
        @ctx.lineTo( @toCanvasXCoord(tick), @canvas.height - tickMinorLength ) # minor tick
      @ctx.lineWidth = tickWidth
      @ctx.strokeStyle = tickColor
      @ctx.stroke()

      # draw numbers
      if i % nIntervals is 0
        @ctx.font = '10pt Arial'
        @ctx.textAlign = 'center'
        @ctx.fillStyle = textColor
        @ctx.fillText( tick, @toCanvasXCoord(tick), @canvas.height - textSpacing )

  drawYTickMarks: (yMin, yMax, nIntervals) ->
    console.log 'yLimits: [',yMin,',',yMax,']'
    # generate intervals
    yTicks = []
    nIntervals = 10
    yStep = 1/nIntervals
    i = 0
    yVal = yMin
    while yVal <= yMax
      for j in [0...nIntervals]
        tick = yVal + j*yStep;
        console.log 'tick: ', tick, ' -> ', @toCanvasYCoord(tick)
        unless tick > yMax
          yTicks.push tick
      i++
      yVal++

    tickMinorLength = 5
    tickMajorLength = 10
    tickWidth = 1
    tickColor = '#323232'
    textColor = '#323232'
    textSpacing = 15

    for tick, i in [yTicks...]
      # continue if i is 0 # skip first value
      console.log 'tick: ', tick

      tickPos = @toCanvasYCoord(tick)       # transform to canvas coordinate
      tickPos = -tickPos + @canvas.height   # flip y-axis

      # draw ticks
      @ctx.beginPath() 
      @ctx.moveTo( 0, tickPos )
      if i % nIntervals is 0
        @ctx.lineTo( tickMajorLength, tickPos ) # major tick
      else
        @ctx.lineTo( tickMinorLength, tickPos ) # minor tick
      @ctx.lineWidth = tickWidth
      @ctx.strokeStyle = tickColor
      @ctx.stroke()

      # draw numbers
      # if i % nIntervals is 0
      @ctx.font = '10pt Arial'
      @ctx.textAlign = 'center'
      @ctx.fillStyle = textColor
      # @ctx.fillText( tick.toFixed(2), 0+textSpacing+10, -(@toCanvasYCoord(tick)+5)+@canvas.height )
      # flip about y-axis
      @ctx.fillText( tick.toFixed(2), 0+textSpacing+10, tickPos+5 )

    # # X-AXIS
    # # display 'days' label
    # @ctx.font = '10pt Arial'
    # @ctx.textAlign = 'left'
    # @ctx.fillStyle = textColor
    # @ctx.fillText( 'DAYS', 10, @canvas.height - textSpacing )
    # for i in [0...@dataLength]
    #   if i % 1 is 0 and i isnt 0
    #     # top
    #     tick_x = ((+i - xMin) / (xMax - xMin)) * @canvas.width
    #     @ctx.beginPath()
    #     @ctx.moveTo( tick_x, 0 )
    #     @ctx.lineTo( tick_x, tickMinorLength )
    #     @ctx.lineWidth = tickWidth
    #     @ctx.strokeStyle = tickColor
    #     @ctx.stroke()

    #     # bottom tickmarks
    #     @ctx.beginPath()
    #     @ctx.moveTo( tick_x, @canvas.height )
    #     @ctx.lineTo( tick_x, @canvas.height - tickMinorLength )
    #     @ctx.lineWidth = tickWidth
    #     @ctx.strokeStyle = tickColor
    #     @ctx.stroke()

    #   if i % 2 is 0 and i isnt 0
    #     # tick_x = ((+i - xMin) / (xMax - xMin)) * @canvas.width
        
    #     # bottom lines
    #     @ctx.beginPath()
    #     @ctx.moveTo( tick_x, @canvas.height )
    #     @ctx.lineTo( tick_x, @canvas.height-tickMajorLength )
    #     @ctx.lineWidth = tickWidth
    #     @ctx.strokeStyle = tickColor
    #     @ctx.stroke()

    #     #bottom numbers
    #     @ctx.font = '10pt Arial'
    #     @ctx.textAlign = 'center'
    #     @ctx.fillStyle = textColor
    #     @ctx.fillText( @toDataXCoord(tick_x).toFixed(), tick_x, @canvas.height - textSpacing )

    #   if i % 4 is 0 and i isnt 0
    #     tick_x = ((+i - xMin) / (xMax - xMin)) * @canvas.width
        
    #     # top numbers
    #     @ctx.font = '10pt Arial'
    #     @ctx.textAlign = 'center'
    #     @ctx.fillStyle = textColor
    #     x_value = @toDataXCoord(tick_x)+Math.round(@originalMin)
    #     @ctx.fillText( x_value, tick_x, tickMajorLength+textSpacing )

    #     # top lines
    #     @ctx.beginPath()
    #     @ctx.moveTo( tick_x, 0 )
    #     @ctx.lineTo( tick_x, tickMajorLength )
    #     @ctx.lineWidth = tickWidth
    #     @ctx.strokeStyle = tickColor
    #     @ctx.stroke()

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

  zoomOut: (callback) ->
    [cMin, cMax] = [@xMin, @xMax]
    [wMin, wMax] = [@smallestX, @largestX]
    zoom = setInterval (=>
      @plotPoints(cMin,cMax)
      cMin -= 1.5 unless cMin <= wMin
      cMax += 1.5 unless cMax >= wMax
      if cMin <= wMin and cMax >= wMax  # finished zooming
        clearInterval zoom
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
    graph.effect( "shake", {times:4, distance: 5}, 500, =>
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

  onMouseMove: (e) =>
    e.preventDefault()
    @draw(e) if @dragging
    @move(e) if @moving

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
      classifier.notify 'Marks must contains points!'
      @canvasGraph.shakeGraph()
    $(document).trigger("mark-change")

  containsPoints: (xValues) =>
    for value in xValues
      if value <= @dataXMaxRel and value >= @dataXMinRel
        return true
    return false

  toCanvasXPoint: (e) -> e.pageX - @canvas.getBoundingClientRect().left - window.scrollX

module?.exports = CanvasGraph: CanvasGraph, Marks: Marks, Mark: Mark
