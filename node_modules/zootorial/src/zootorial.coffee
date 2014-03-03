class Tutorial
  progress: NaN
  steps: null
  first: 'first'

  parent: document.body

  # Defaults, overrideable per-step
  demoLabel: 'Show me'
  nextLabel: 'Continue'
  doneLabel: 'Done'
  attachment: [0.5, 0.5, window, 0.5, 0.5]

  startEvent: 'zootorial-start'
  endEvent: 'zootorial-end'
  loadStepEvent: 'zootorial-load-step'
  unloadStepEvent: 'zootorial-unload-step'
  abortEvent: 'zootorial-abort'

  current: null

  namedPoints:
    top: 0, middle: 0.5, bottom: 1
    left: 0, center: 0.5, right: 1

  # Set this to null if you'd prefer to use absolute left and top.
  transformProperty: if 'transform' of document.body.style
    'transform'
  else if 'mozTransform' of document.body.style
    '-moz-transform'
  else if 'msTransform' of document.body.style
    '-ms-transform'
  else if 'webkitTransform' of document.body.style
    '-webkit-transform'

  constructor: (params = {}) ->
    @[property] = value for property, value of params
    @steps ?= {}
    @progress ||= Math.max (progress for _, {progress} of @steps)...

    @container = @createElement 'div.zootorial-container'
    @el = @createElement 'div.zootorial-tutorial', @container

    @closeButton = @createElement 'button.zootorial-close', @el
    @closeButton.innerHTML = '&times;'
    @closeButton.onclick = =>
      @triggerEvent @abortEvent
      @end()

    @header = @createElement 'header.zootorial-header', @el
    @content = @createElement 'div.zootorial-content', @el
    @instruction = @createElement 'div.zootorial-instruction', @el
    @footer = @createElement 'footer.zootorial-footer', @el
    if @progress
      @progressEl = @createElement 'div.zootorial-progress', @el
      @createElement 'span.zootorial-progress-step', @progressEl for i in [0...@progress]
    @arrow = @createElement 'div.zootorial-arrow', @el

    @delegatedEventListeners = []

    @blockers = []
    @focusers =
      top: @createElement 'div.top.zootorial-focuser', @container
      right: @createElement 'div.right.zootorial-focuser', @container
      bottom: @createElement 'div.bottom.zootorial-focuser', @container
      left: @createElement 'div.left.zootorial-focuser', @container

    @actionables = []

    @parent.appendChild @container

    @attach() # Set a decent initial position.

    @end()

  createElement: (tagAndClassNames, parent) ->
    [tag, classNames...] = tagAndClassNames.split '.'
    el = document.createElement tag
    el.className = classNames.join ' '
    parent.appendChild el if parent?
    el

  triggerEvent: (eventName) ->
    e = document.createEvent 'CustomEvent'

    e.initCustomEvent eventName, true, true,
      tutorial: @
      stepName: (key for key, step of @steps when step is @current)[0]

    @el.dispatchEvent e

  start: ->
    @triggerEvent @startEvent
    @onBeforeStart?()
    @el.style.opacity = 0
    @el.style.display = ''
    @goTo @first
    @el.style.opacity = ''
    @onStart?()

  end: ->
    @onBeforeEnd?()
    @unloadCurrentStep()
    @el.style.display = 'none'
    @onEnd?()
    @triggerEvent @endEvent

  goTo: (step) ->
    if typeof step is 'function'
      @goTo step.call @

    if step?
      if typeof step is 'string'
        @unloadCurrentStep()
        @loadStep @steps[step]

      else if step is false
        times = parseFloat @instruction.getAttribute 'data-zootorial-attention'
        @instruction.setAttribute 'data-zootorial-attention', (times || 0) + 1

    else
      @end()

  loadStep: (@current) ->
    @triggerEvent @loadStepEvent
    @onBeforeLoadStep?()
    @current.onBeforeLoad?.call @

    for section in ['header', 'content', 'instruction']
      if @current?[section]?
        @[section].innerHTML = @current[section]
      else
        @[section].style.display = 'none'

    if @current.demo?
      @instruction.appendChild document.createTextNode '\n'
      demoButton = @createElement 'button.zootorial-demo', @instruction
      demoButton.innerHTML = @current.demoLabel || @demoLabel
      demoButton.onclick = => @current.demo.call @, arguments...

    if @current.next?
      if typeof @current.next in ['string', 'function']
        @footer.style.display = ''
        nextButton = @createElement 'button.zootorial-next', @footer
        nextButton.innerHTML = @current.nextLabel || @nextLabel
        nextButton.onclick = => @goTo @current.next

      else
        @footer.style.display = 'none'
        for eventNameAndSelector, nextStep of @current.next
          [eventName, selector...] = eventNameAndSelector.split /\s+/
          selector = selector.join(' ') || '*'

          do (eventName, selector, nextStep) =>
            delegatedHandler = (e) =>
              selection = document.querySelectorAll selector

              target = e.target
              while target?
                target = if target in selection
                  @goTo nextStep
                  null
                else
                  target.parentNode

            setTimeout =>
              @delegatedEventListeners.push [eventName, delegatedHandler]
              addEventListener eventName, delegatedHandler, false

    else
      doneButton = @createElement 'button.zootorial-next.zootorial-done', @footer
      doneButton.innerHTML = @current.doneLabel || @doneLabel
      doneButton.onclick = => @goTo null

    if @current.progress
      for child, i in @progressEl.children
        if i + 1 <= @current.progress
          child.setAttribute 'data-zootorial-progress', @current.progress
        else
          child.removeAttribute 'data-zootorial-progress'

    if @current.arrow?
      @arrow.setAttribute 'data-zootorial-position', @current.arrow
    else
      @arrow.removeAttribute 'data-zootorial-position'

    @attach() unless @current.attachment is false

    @doToElements @current.block, @block if @current.block

    if @current.focus?
      for _, focuser of @focusers
        focuser.style.display = ''

      @doToElements @current.focus, @focus if @current.focus?

    @doToElements @current.actionable, @actionable if @current.actionable

    @current.onLoad?.call @
    @onLoadStep?()

  attach: (attachment) ->
    attachment ?= @current?.attachment || @attachment
    @attachTo @el, attachment...

  setPosition: (el, left, top) ->
    offsetParent = el.offsetParent

    if offsetParent? and getComputedStyle(offsetParent).position is 'static'
      offsetParent = null

    [parentLeft, parentTop] = if offsetParent?
      parentRect = offsetParent.getBoundingClientRect()
      [parentRect.left + pageXOffset, parentRect.top + pageYOffset]
    else
      [0, 0]

    left -= parentLeft
    top -= parentTop

    if @transformProperty?
      el.style[@transformProperty] = "translate(#{Math.floor left}px, #{Math.floor top}px)"
    else
      el.style.position = 'absolute'
      el.style.left = "#{Math.floor left}px"
      el.style.top = "#{Math.floor top}px"

  attachTo: (el, eX, eY, target = window, tX, tY) ->
    el = document.querySelector el if typeof el is 'string'
    target = document.querySelector target if typeof target is 'string'

    eX = @namedPoints[eX] if eX of @namedPoints; eX = parseFloat eX
    eY = @namedPoints[eY] if eY of @namedPoints; eY = parseFloat eY
    tX = @namedPoints[tX] if tX of @namedPoints; tX = parseFloat tX
    tY = @namedPoints[tY] if tY of @namedPoints; tY = parseFloat tY

    if target is window
      targetLeft = pageXOffset
      targetTop = pageYOffset
      # NOTE: clientWidth/Height here return the viewport size minus scrollbars.
      targetWidth = document.documentElement.clientWidth
      targetHeight = document.documentElement.clientHeight
    else
      {left: targetLeft, top: targetTop} = target.getBoundingClientRect()
      targetLeft += pageXOffset
      targetTop += pageYOffset
      targetWidth = target.offsetWidth
      targetHeight = target.offsetHeight

    left = targetLeft + (tX * targetWidth) - (eX * el.offsetWidth)
    top = targetTop + (tY * targetHeight) - (eY * el.offsetHeight)

    @setPosition el, left, top
    [left, top]

  doToElements: (elOrElsOrSelector = [], fn, context) ->
    if elOrElsOrSelector instanceof HTMLElement
      elOrElsOrSelector = [elOrElsOrSelector]

    else if typeof elOrElsOrSelector is 'string'
      elOrElsOrSelector = document.querySelectorAll elOrElsOrSelector

    if elOrElsOrSelector instanceof NodeList
      elOrElsOrSelector = Array::slice.call elOrElsOrSelector

    elOrElsOrSelector.forEach fn, context || @

  block: (target) ->
    containerRect = @container.getBoundingClientRect()
    targetRect = target.getBoundingClientRect()

    blocker = @createElement 'div.zootorial-blocker', @container
    blocker.style.left = "#{(targetRect.left) - containerRect.left}px"
    blocker.style.top = "#{(targetRect.top) - containerRect.top}px"
    blocker.style.width = "#{target.offsetWidth}px"
    blocker.style.height = "#{target.offsetHeight}px"
    @blockers.push blocker

  focus: (target) ->
    html = document.documentElement
    containerRect = @container.getBoundingClientRect()
    targetRect = target.getBoundingClientRect()

    htmlWidth = Math.max html.clientWidth, html.offsetWidth
    htmlHeight = Math.max html.clientHeight, html.offsetHeight

    @focusers.top.style.left = "#{-containerRect.left - pageXOffset}px"
    @focusers.top.style.top = "#{-containerRect.top - pageYOffset}px"
    @focusers.top.style.width = "#{pageXOffset + htmlWidth}px"
    @focusers.top.style.height = "#{targetRect.top + pageYOffset}px"

    @focusers.right.style.left = "#{targetRect.right - containerRect.left}px"
    @focusers.right.style.top = "#{targetRect.top - containerRect.top}px"
    @focusers.right.style.width = "#{htmlWidth - (targetRect.left + target.offsetWidth)}px"
    @focusers.right.style.height = "#{target.offsetHeight}px"

    @focusers.bottom.style.left = "#{-containerRect.left - pageXOffset}px"
    @focusers.bottom.style.top = "#{-containerRect.top + targetRect.bottom}px"
    @focusers.bottom.style.width = "#{pageXOffset + htmlWidth}px"
    @focusers.bottom.style.height = "#{htmlHeight - (targetRect.bottom + pageYOffset)}px"

    @focusers.left.style.left = "#{-containerRect.left - pageXOffset}px"
    @focusers.left.style.top = "#{-containerRect.top + targetRect.top}px"
    @focusers.left.style.width = "#{targetRect.left + pageXOffset}px"
    @focusers.left.style.height = "#{target.offsetHeight}px"

  actionable: (target) ->
    target.setAttribute 'data-zootorial-actionable', true
    @actionables.push target

  unloadCurrentStep: ->
    if @current?
      @onBeforeUnloadStep?()
      @current.onBeforeUnload?.call @

      for section in ['header', 'content', 'instruction', 'footer']
        until @[section].childNodes.length is 0
          @[section].removeChild @[section].childNodes[0]

        @[section].style.display = ''

      until @delegatedEventListeners.length is 0
        [eventName, delegatedHandler] = @delegatedEventListeners.shift()
        removeEventListener eventName, delegatedHandler, false

      until @blockers.length is 0
        blocker = @blockers.shift()
        blocker.parentNode.removeChild blocker

      for _, focuser of @focusers
        focuser.style.display = 'none'

      until @actionables.length is 0
        @actionables.shift().removeAttribute 'data-zootorial-actionable'

      @instruction.removeAttribute 'data-zootorial-attention'

      @current.onUnload?.call @
      @onUnloadStep?()
      @triggerEvent @unloadStepEvent

    @current = null

  destroy: ->
    @onBeforeDestroy?()
    @end()
    @onDestroy?()

document.body.insertAdjacentHTML 'afterBegin', '''
  <div id="zootorial-temp" style="display: none;">
    <style class="zootorial-defaults">
      .zootorial-container {
        left: 0;
        position: absolute;
        top: 0;
        width: 100%;
      }

      .zootorial-tutorial {
        left: 0;
        position: absolute;
        top: 0;
      }

      .zootorial-arrow {
        position: absolute;
      }

      .zootorial-blocker {
        background: rgba(255, 0, 0, 0.1);
        cursor: not-allowed;
        position: absolute;
      }

      .zootorial-focuser {
        background: rgba(0, 0, 0, 0.5);
        position: absolute;
      }

      [data-zootorial-actionable] {}

      [data-zootorial-attention] {}
    </style>
  </div>
'''

tempDiv = document.getElementById 'zootorial-temp'
tempDiv.parentNode.insertBefore tempDiv.children[0], tempDiv
tempDiv.parentNode.removeChild tempDiv

zootorial = {Tutorial}
window.zootorial = zootorial
module?.exports = zootorial
