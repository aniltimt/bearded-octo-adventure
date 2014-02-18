# class for making use of <script type=text/template>
class window.Template
  # valueSourceSelector is optional, indicates where in document to seek values
  constructor: (selector, valueSourceSelector) ->
    @body = $(selector).html()
    @valueSource = $(valueSourceSelector) if valueSourceSelector?
  sub: (pattern, selector) ->
    $elem = null
    if @valueSource?
      $elem = @valueSource.find(selector)
    if $elem == null
      $elem = $(selector)
    this.subValue pattern, $elem.val()
  subValue: (pattern, value) ->
    regex = new RegExp pattern, 'g'
    @body = @body.replace regex, value

onQuoterFormSubmit = (evt) ->
  # put quoter summary and (empty) quotes div in quotes_pane
  $quoter = $('#quoter_pane')
  template = new Template('#quotes-pane-template')
  template.subValue "{{full_name}}", "todo"
  template.sub "{{birth_date}}", "#connection_birth"
  $('#quotes_pane').html template.body
  # show quotes pane
  $('#quote-template > div').hide()
  $('#quotes_pane').show()

# Add or remove DOM field sets for naming ill relatives
window.addOrRemoveFamilyDiseaseFieldSets = (input) ->
  $wrapper = $('#family-disease-field-sets')
  targetN = parseInt $(input).val()
  currentN = $wrapper.children().length
  # remove
  if currentN > targetN
    $wrapper.children().last().remove() for i in [targetN...currentN]
  # add
  else if targetN > currentN
    for i in [currentN...targetN]
      elem = $('script#family-disease-template').html().replace( /{{i}}/g, i ).replace( /__i__/g, i )
      $wrapper.append elem

# Add or remove DOM field sets for naming beneficiaries
window.buildOrDestroyChildBeneficiaryFieldSets = (input) ->
  $wrapper = $('#child-bene-field-sets')
  currentN = $wrapper.children().length
  targetN = parseInt $(input).val()
  # destroy children
  if targetN < currentN
    $wrapper.children().last().remove() for i in [targetN...currentN]
  # build children  
  else if targetN > currentN
    $wrapper.append $('script#child-beneficiary').html() for i in [targetN...currentN]

# Fires when user clicks 'apply' button next to a quote
window.chooseQuote = (quote) ->
  $lead_pane = $('#lead_pane')
  $lead_pane.html '<i class="icon-spin icon-spinner"></i>'
  $('#quote-template > div').hide()
  $lead_pane.show()
  postData =
    quote: quote
    crm_connection_id: window.crmConnectionId
    crm_case: window.crmCaseParams
  # crmConnectionId (should be set by script that fires quotesloadedcallback)
  $.get '/quoting/leads/new.js', postData

window.onQuoterFormLoad = () ->
  # Attach submit behaviour to quote form
  $('#quoter_form').submit onQuoterFormSubmit
  # Pre-load sprites images
  img = new Image()
  img.src = "http://quoter.pinneyapps.com/images/carriers.png"

window.quotesLoadedCallback = () ->
  # add click behaviour to the 'click for details' tabs
  $('#quotes_pane .nether').click () ->
    $(this).find('.details').slideToggle()

window.showQuoterPane = () ->
  $quoterPane = $('#quoter_pane')
  $quoterPane.siblings().hide()
  $quoterPane.show()
