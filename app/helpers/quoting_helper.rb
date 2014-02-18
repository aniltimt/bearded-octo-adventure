module QuotingHelper

  def annual_premium quote, options={}
    options[:suffix] = "/yr" unless options.has_key? :suffix
    format_premium quote.annual_premium, options
  end

  def bp_options_for_select values
    options_for_select( [['Don\'t know',-1],["< #{values[1]}",values[0]]] + values[1..-1] )
  end

  def carrier_sprite quote, tag=:div
    return unless quote.is_a? Quoting::PinneyQuoter::Results::Result
    if quote.sprite.present?
      content_tag( tag, '',
        :class => 'carrier-sprite',
        :style => "background-position: 0 #{quote.sprite}px"
        )
    else
      content_tag tag, quote.company_name, class:'carrier-sprite-alt'
    end
  end

	def driving_history_block f, name, paragraph
		span = content_tag :span, class:'pull-right' do
			checked = f.object.send(name).present?
			view_toggling_radio_and_label_tags(name, checked:checked)
		end
		p = content_tag :p, paragraph
		div = content_tag :div, id:"_#{name}" do
			f.select name, history_options_for_select
		end
		(span + p + div).html_safe
	end

  def financial_needs_calculator_row label, options={}, input_options={}
    options[:anchor_name] = label.parameterize if options[:anchor_name].nil?
    input_options[:id] ||= options[:anchor_name]
    input = tag(:input, input_options)
    link = unless options[:link] == false
      link_to("<i class='icon-question-sign'></i>".html_safe, "/help/financial-needs-calculator.html##{options[:anchor_name]}")
    else
      nil
    end
    %Q(<span class=pull-right>
        #{options[:input_prefix]}#{input}#{options[:input_suffix]}
      </span>
      <p>#{label} #{link}</p>
      <div class=clear></div>).html_safe
  end

  def format_premium value, options={}
    if value.blank?
      'n/a'
    else
      value = options[:exclude_decimal] ? value : value.to_i
      "$#{ number_with_delimiter value, delimiter:',' }#{options[:suffix]}"
    end
  end

  # Unused. Generates a bootstrap row for health history
  def health_history_row f, *args
    content_tag :div, class:'row', style:'margin:0' do
      args.map{ |arg|
        content = 
        if arg.is_a? String
          arg
        elsif arg.is_a? Symbol
          check_and_label_tags arg, arg.to_s.titleize
        elsif arg.is_a? Array
          check_and_label_tags *arg
        end
        content_tag :div, content, class:'span2'
        }.join("\n").html_safe
    end
  end

  def health_history_td f, *args
    content_tag :td do
      content_tag( :strong, args.shift, class:'underline' ) + raw('<br>') + \
      args.map{ |arg|
        content = 
        if arg.is_a? String
          arg
        elsif arg.is_a? Symbol
          check_and_label_tags arg, arg.to_s.titleize, form:f
        elsif arg.is_a? Array
          check_and_label_tags *arg, form:f
        end
        content_tag :span, content
        }.join(raw('<br>')).html_safe
    end
  end

  def history_options_for_select
    options_for_select(
      [['N/A',-1],['<= 6 months ago',0],['<= 1 year ago',1]] + \
      (2..10).map{|i| ["<= #{i} years ago", i]} + \
      [['<= 15 years ago', 15],[' > 15 years ago', 16]]
    )
  end

  def label_and_text_field label, field, form
    %Q(<div class=row>
      <div class=span4>#{label}</div>#{ form.text_field field }
      </div>).html_safe
  end

  def monthly_premium quote, options={}
    options[:suffix] = "/mo" unless options.has_key? :suffix
    format_premium quote.monthly_premium, options
  end

  # Outputs a label and input, nesting calls to fields_for if 'form' arg is an Array.
  # e.g. <%= nested_form_field nil, [builder, :approved_details], :collection_select, :my_model_id, MyModel.all, :id, :name %>
  # Make label_text nil for just the input tag, no wrapping elements.
  def nested_form_field label_text, form, method, field, *args
    if form.is_a? Array
      if form.length > 1
        form.shift.fields_for form.first do |builder|
          form[0] = builder
          nested_form_field label_text, form, method, field, *args
        end
      else
        nested_form_field label_text, form.first, method, field, *args
      end
    else
      if label_text.nil?
        form.send method, field, *args
      else
        %Q(<div class=row>
        <div class=span4>#{label_text}</div>
        #{ form.send method, field, *args }
        </div>).html_safe
      end
    end
  end

  def nested_text_field label_text, form, field, *args
    nested_form_field label_text, form, :text_field, field, *args
  end

  def star_rating val
    html = ""
    (0..val.to_i).each do 
      html << "<i class='icon-star'></i>"
    end
    html.html_safe
  end

end