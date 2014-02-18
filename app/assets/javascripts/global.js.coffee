$ ->
  # Add tooltip behaviour to right sidebar
  $rightSidebarButtons = $ '#rightbar a'
  $rightSidebarButtons.attr 'data-placement', 'left'
  $rightSidebarButtons.attr 'data-toggle', 'tooltip'
  $('[data-toggle=tooltip]').tooltip()
  globalLoadCallback()

# This should fire any time that a page or AJAX response is loaded
window.globalLoadCallback = () ->
  applyInputMasks()
  addViewTogglingBehaivourToRadios()
  addViewTogglingBehaivourToButtons()
  addViewTogglingBehaivourToCheckboxes()

# Add input masks where applicable
applyInputMasks = () ->
  $('input[type=tel]').mask '(999) 999-9999'
  $('input.date').mask '99/99/9999'
  $('input.zip').mask '99999'

# Find all inputs with attribute data-mirror
# Bind their contents to match all inputs of matching data-mirror value or name
window.addInputMirrorBehaviour = (selector) ->
  $elem = if typeof(selector) == 'undefined' then $('input[data-mirror]') else $(selector).find('input[data-mirror]')
  $elem.bind 'change', ->
    $this = $(this)
    mirror = $this.attr('data-mirror')
    if mirror == 'true'
      name = $this.attr('name')
      $('input[name="'+name+'"]').val $this.val()
    else
      $('input[data-mirror="'+mirror+'"]').val $this.val()

# Add show toggle behaviour to radios with data-show attrs
addViewTogglingBehaivourToRadios = () ->
  $radios = $('[type=radio][data-show],[type=radio][data-hide]')
  $radios.off  'change.viewToggling'
  $radios.bind 'change.viewToggling', ->
    $this = $(this)
    if $this.is(':checked')
      hideForElement $this
      showForElement $this
  # showAndHide element on startup if :checked
  $radios.each ->
    $this = $(this)
    if $this.is(':checked')
      hideForElement $this
      showForElement $this

# Add show toggle behaviour to buttons with data-show attrs
addViewTogglingBehaivourToButtons = () ->
  $buttons = $('button[data-show],button[data-hide]')
  $buttons.off  'click.viewToggling'
  $buttons.bind 'click.viewToggling', ->
    $this = $(this)
    hideForElement $this
    showForElement $this

# Add show toggle behaviour to checkboxes with data-show attrs
addViewTogglingBehaivourToCheckboxes = () ->
  $checkboxes = $('[type=checkbox][data-show],[type=checkbox][data-hide]')
  $checkboxes.off  'change.viewToggling'
  $checkboxes.bind 'change.viewToggling', ->
    $this = $(this)
    if $this.is(':checked') then showForElement $this else hideForElement $this
  # show element on startup if :checked
  $checkboxes.each ->
    $this = $(this)
    if $this.is(':checked') then showForElement $this else hideForElement $this

# Shows DOM elements selected by data-show on $elem
showForElement = ($elem) ->
  showables_selector = $elem.attr 'data-show'
  $showables = $(showables_selector)
  $showables.show()
  if $elem.attr('data-disable-hidden')
    $showables.children('input,select,textarea').prop('disabled',false)

# Hides DOM elements selected by data-hide on $elem
hideForElement = ($elem) ->
  hideables_selector = $elem.attr 'data-hide'
  $hideables = $(hideables_selector)
  $hideables.hide()
  if $elem.attr('data-disable-hidden')
    $hideables.children('input,select,textarea').prop('disabled',true)

# Finds a script/template for templateId
# renders the template, appends it to $(containerSelector)
window.addFromTemplate = (containerSelector, templateId) ->
  $container = $( containerSelector )
  $template  = $( 'script#' + templateId )
  # render template
  childIndex = 1 + $container.children().length
  content = $template.html().replace(/__i__/g, childIndex)
  # insert into DOM
  $container.append(content);

# Finds button's ancestor matching $(button.data-selector),
# removes it from the DOM
window.rmFromTemplate = (trigger, ancestorSelector) ->
  $(trigger).closest(ancestorSelector).remove()

window.showFromSiblings = (selector, scrollTop, elemToScroll) ->
  $elem = $(selector)
  $elem.siblings().hide()
  $elem.show()
  scrollTop = 0 if scrollTop == true
  if typeof(scrollTop) == 'number'
    elemToScroll = window if typeof(elemToScroll) == 'undefined'
    $(elemToScroll).scrollTop(scrollTop)