###
This code attaches behaviour to jQuery AJAX functions (ajax, post, get)
To change the value of the ajax-status icon in the navbar on three states:
waiting, success, error
###

$flashIcon   = null
$flashError  = null
$flashNotice = null

# Callback before AJAX request sends
cbBeforeSend = (jqXHR, settings) ->
  console.log jqXHR
  # initialize message/status elements
  $flashIcon.attr 'class', 'icon icon-refresh icon-spin'
  $flashError.html ''
  $flashNotice.html ''
  
# Callback when AJAX returns with success
cbSuccess = (data, textStatus, jqXHR) ->
  console.log 'success'
  $flashIcon.attr 'class', 'icon icon-ok-sign'
  window.globalLoadCallback()

# Callback when AJAX returns with error
cbError = (jqXHR, textStatus, errorThrown) ->
  console.log 'error'
  $flashIcon.attr 'class', 'icon icon-remove-circle'
  # Run the response javascript, even when the status indicates an error
  if /text\/javascript/.test jqXHR.getResponseHeader('Content-Type') 
    eval jqXHR.responseText

# Callback when AJAX returns
cbComplete = (jqXHR, textStatus) ->
  console.log 'cbComplete'
  if $flashIcon.is('.icon-refresh')
    $flashIcon.attr 'class', 'icon icon-warning-sign'

cbBeforeSendBound = (evt, request, options) ->
  cbBeforeSend request, options

cbSuccessBound = (evt, request, options) ->
  cbSuccess options, null, request

cbErrorBound = (evt, request, options) ->
  cbError request, options

cbCompleteBound = (evt, response, textStatus) ->
  cbComplete response, textStatus

# These callbacks seem to fire in response to links being clicked but not
# in response to $.post being actually called.
$(document).ready ->
  # Add interaction between AJAX requests and #ajax-status DOM element
  $flashInfo   = $('div.flash-info')
  $flashIcon   = $flashInfo.find('i#ajax-status')
  $flashError  = $flashInfo.find('#flash-error')
  $flashNotice = $flashInfo.find('#flash-notice')


$(document).bind 'ajax:beforeSend', cbBeforeSendBound
$(document).bind 'ajax:success', cbSuccessBound
$(document).bind 'ajax:error', cbErrorBound
$(document).bind 'ajax:complete', cbCompleteBound

$.ajaxSetup(
  beforeSend: cbBeforeSend
  success: cbSuccess
  error: cbError
  complete: cbComplete
  )