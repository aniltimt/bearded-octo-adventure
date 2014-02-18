COST_PER_YEAR_OF_CHILD = 4000

window.runFinancialNeedsCalculator = () ->
  c = new Calculator '#financial-needs-calculator', '#coverage-recommendations'
  c.pullValues()
  c.putValues()
  $('#coverage-recommendations').slideDown()

window.selectCoverageRecommendation = (button, column) ->
  $elem = $('#coverage-recommendations')
  # set coverage amount
  faceAmount = parseInt $elem.find('.need input')[column].value
  setFaceAmount faceAmount
  # show next pane
  showFromSiblings('#basic_info', true)

class Calculator
  constructor: (widgetSelector, receptacleSelector) ->
    @widget = $ widgetSelector
    @receptacle = $ receptacleSelector
  needNum: (arg) ->
    name = if typeof(arg) == 'string' then arg else arg.attr("id")
    alert name + " needs a numeric value"
    return false
  pullValues: ->
    self = this
    @inflation = num(@widget.find('#estimated-inflation-rate')) / 100
    # general liabilities
    @liabilities = 0
    @widget.find('.liability').each ->
      self.liabilities += num($(this))
    # child needs
    @childNeeds = 0
    @widget.find('.child').each ->
      $this = $(this)
      self.childNeeds += num($this.find('.tuition'))
      age = num($this.find('.age'))
      self.childNeeds += COST_PER_YEAR_OF_CHILD * (18 - age) if age < 18
    # income replacement
    @income = num(@widget.find('#total-annual-income'))
    @yearsOfIncome = num(@widget.find('#how-many-years-should-income-be-provided'))
    # assets
    @assets = 0
    @widget.find('.asset').each ->
      self.assets += num($(this))
    # spouse income
    spouseAnnIncome = num(@widget.find('#what-is-your-spouse-s-annual-income'))
    spouseYearsofIncome = num(@widget.find('#how-many-years-does-your-spouse-expect-to-work'))
    spouseTaxMargin = num(@widget.find('#spouse-tax-rate')) / 100
    @assets += this.calcFutureValue spouseAnnIncome, spouseYearsofIncome, (sum, base) ->
      sum *= 1 - self.inflation
      sum += base * (1 - spouseTaxMargin)
  putValues: ->
    this.put '.children input', @childNeeds
    this.put '.continue-income .b.years', @yearsOfIncome + ' yrs'
    this.put '.other-cash input', @liabilities
    this.put '.current-assets input', @assets
    baseNeeds = @childNeeds + @liabilities - @assets
    incomeNeedsA = this.calcFutureValue(@income * .85, 3, this.oneYearsIncome, @inflation)
    incomeNeedsB = this.calcFutureValue(@income, @yearsOfIncome, this.oneYearsIncome, @inflation)
    incomeNeedsC = this.calcFutureValue(@income, 35, this.oneYearsIncome, @inflation)
    this.put '.continue-income .income.a', incomeNeedsA
    this.put '.continue-income .income.b', incomeNeedsB
    this.put '.continue-income .income.c', incomeNeedsC
    this.put '.need .a', baseNeeds + incomeNeedsA
    this.put '.need .b', baseNeeds + incomeNeedsB
    this.put '.need .c', baseNeeds + incomeNeedsC
  put: (selector, value) ->
    if typeof(value) == "number" and value % 1 != 0
      value = Math.round(value * 100) / 100
    @receptacle.find(selector).val value
  oneYearsIncome: (sum, base, inflation) ->
    sum *= 1 - inflation
    sum += base
  calcFutureValue: (base, years, fx, data) ->
    sum = 0
    (sum = fx(sum,base,data)) for x in [0...years]
    sum

# get numeric value from input or return false
num = ($elem) ->
  parseInt($elem.val()) || 0

setFaceAmount = (faceAmount) ->
  $select = $('#crm_case_quoted_details_attributes_face_amount')
  stillSearching = true
  $select.find('option').each ->
    value = num $(this)
    if value >= faceAmount
      $select.val(value)
      return stillSearching = false
  return unless stillSearching
  $select.val $select.find('option').last().val()