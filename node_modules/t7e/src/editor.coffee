t7e = window.t7e || require './t7e'

class t7e.Editor
  @init: ->
    editor = new @
    document.body.appendChild editor.controls
    editor

  template: '''
    <div class="t7e-controls">
      <span class="t7e-controls-title">T7e</span>
      <button name="start">Edit</button>
      <button name="stop">Preview</button>
      <button name="save">Save</button>

      <div class="t7e-attributes-container"></div>
    </div>
  '''

  selection = null

  constructor: ->
    @controls = do =>
      creationDiv = document.createElement 'div'
      creationDiv.innerHTML = @template
      creationDiv.children[0]

    @startButton = @controls.querySelector 'button[name="start"]'
    @stopButton = @controls.querySelector 'button[name="stop"]'
    @saveButton = @controls.querySelector 'button[name="save"]'
    @attributesContainer = @controls.querySelector '.t7e-attributes-container'

    @controls.addEventListener? 'click', @onControlsClick, false
    @attributesContainer.addEventListener? 'keyup', @onAttributeKeyUp, false

    @stopButton.disabled = true

  onControlsClick: (e) =>
    target = e.target || e.currentTarget
    @[target.name]? arguments...

  start: ->
    @startButton.disabled = true
    @stopButton.disabled = false
    @saveButton.disabled = true
    document.documentElement.classList.add 't7e-edit-mode'
    document.addEventListener? 'click', @onDocumentClick, false
    t7e.refresh document.body, literal: true

  onDocumentClick: (e) =>
    target = e.target || e.currentTarget

    return if target in @controls.querySelectorAll '*'

    @deselect()

    while target?
      break if target.hasAttribute? 'data-t7e-key'
      target = target.parentNode

    if target?
      @select target
      e.preventDefault()
      e.stopPropagation()

  select: (element) ->
    @selection = element
    element.classList.add 't7e-selected'
    element.contentEditable = true
    element.addEventListener? 'keyup', @onSelectionKeyUp, false
    element.focus()

    dataAttrs = t7e.dataAll element
    for attribute, key of dataAttrs when (attribute.indexOf 'attr-') is 0
      shortAttribute = attribute['attr-'.length...]
      currentValue = t7e key, literal: true

      @attributesContainer.innerHTML += """
        <label>
          <span class="t7e-attribute-label">#{shortAttribute}</span>
          <input type="text" name="#{shortAttribute}" value="#{currentValue}" />
        </label>
      """

  onSelectionKeyUp: =>
    t7e.dataSet @selection, 'modified', true

  onAttributeKeyUp: (e) =>
    target = e.target || e.currentTarget
    @selection.setAttribute target.name, target.value
    t7e.dataSet @selection, 'modified', true

  deselect: ->
    @selection?.classList.remove 't7e-selected'
    @selection?.contentEditable = 'inherit'
    @selection?.removeEventListener 'keyup', @onSelectionKeyUp, false
    @selection = null

    @attributesContainer.innerHTML = ''

  stop: ->
    @startButton.disabled = false
    @stopButton.disabled = true
    @saveButton.disabled = false

    document.documentElement.classList.remove 't7e-edit-mode'
    document.removeEventListener 'click', @onDocumentClick, false
    @deselect()

    modifiedElements = document.querySelectorAll '[data-t7e-modified]'
    newStrings = {}

    for element in modifiedElements
      key = t7e.dataGet element, 'key'
      newStrings[key] = element.innerHTML if key

      dataAttrs = t7e.dataAll element
      for attribute, key of dataAttrs when (attribute.indexOf 'attr-') is 0
        attribute = attribute['attr-'.length...]
        newStrings[key] = element.getAttribute attribute

    for key, value of newStrings
      segments = key.split '.'
      single = {}

      pointer = single
      for segment in segments[...-1]
        pointer[segment] ?= {}
        pointer = pointer[segment]

      pointer[segments[-1...]] = value

      t7e.load single

    t7e.refresh()

  save: ->
    open "data:application/json;charset=utf-8,#{encodeURIComponent JSON.stringify t7e.strings}"

  destroy: ->
    @stop()
    @controls.removeEventListener 'click', @onControlsClick, false
    @controls.parentNode.removeChild @controls

module?.exports = t7e.Editor
