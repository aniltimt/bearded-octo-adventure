module FormsHelper

  INPUT_AND_LABEL_DEFAULT_OPTIONS = {
      separator: ' ',
      outer_separator: ' ',
      input_values: [true, false],
      label_values: ['Yes','No'],
      input: {},
      label: {class:'inline'}
    }

  # Returns html for one radio tag and an accompanying label
  def radio_and_label_tags name, radio_value, label_value=nil, options={}
    options = INPUT_AND_LABEL_DEFAULT_OPTIONS.merge options
    _radio_and_label_tags name, radio_value, label_value, options
  end

  # Arg unit_options should be a multiplicity of Hashes, one for each radio button+label pair
  # Returns an array of html snippets, one for each button+label pair
  def radio_and_label_tag_sets name, global_options={}, *unit_options
    global_options = INPUT_AND_LABEL_DEFAULT_OPTIONS.merge global_options
    radio_values = global_options[:input_values]
    label_values = global_options[:label_values]
    snippets = []
    label_values.each_index do |i|
      snippet = radio_and_label_tags name, radio_values[i], label_values[i], global_options.merge(unit_options[i]||{})
      snippets << snippet
    end
    snippets
  end

  # Returns one radio button for showing a DOM element and one for hiding the same DOM element.
  # This must be paired with javascript that makes use of data-show and data-hide attrs.
  # Either options[:selector] should be present, or the id of the element you wish 
  # to toggle should be _<name>
  def view_toggling_radio_and_label_tags name, options={}
    # The selector is for the DOM element that shall be hidden and shown
    selector = options.delete(:selector) || "#_#{name}"
    return_format = options.delete(:return)
    options = INPUT_AND_LABEL_DEFAULT_OPTIONS.merge options
    options[:input] = {'data-show' => selector}.merge options[:input]
    show_html = _radio_and_label_tags name, options[:input_values][0], options[:label_values][0], options
    options[:input].delete 'data-show'
    options[:input] = {'data-hide' => selector}.merge options[:input]
    hide_html = _radio_and_label_tags name, options[:input_values][1], options[:label_values][1], options
    if return_format == 'array'
      [ show_html, hide_html ]
    else
      [ show_html, hide_html ].join(options[:outer_separator]).html_safe
    end
  end

  def check_and_label_tags name, label_value=nil, options={}
    options = INPUT_AND_LABEL_DEFAULT_OPTIONS.merge options
    label_name = "#{name}"
    if options[:form]
      check_args = [options[:input]]
      check_args << options[:checked_value] << options[:unchecked_value] if options.has_key? :checked_value
      check_html = options[:form].check_box name, *check_args
      label_html = options[:form].label label_name, label_value, options[:label]
    else
      check_html = check_box_tag name, options[:checked_value], options[:checked], options[:input]
      label_html = label_tag label_name, label_value, options[:label]
    end
    check_html + options[:separator] + label_html
  end

  def view_toggling_check_and_label_tags name, label_value=nil, options={}
    options[:input] = {'data-show' => "#_#{name}", 'data-hide' => "#_#{name}"}
    check_and_label_tags name, label_value, options
  end

  private

  def _radio_and_label_tags name, radio_value, label_value, options
    label_name = "#{name}_#{radio_value}"
    form = options[:form]
    if form.present?
      button_html = form.radio_button name, radio_value, options[:input]
      label_html = form.label label_name, label_value, options[:label]
    else
      button_html = radio_button_tag name, radio_value, options[:checked], options[:input]
      label_html = label_tag label_name, label_value, options[:label]
    end
    [button_html, label_html].join options[:separator]
  end

end