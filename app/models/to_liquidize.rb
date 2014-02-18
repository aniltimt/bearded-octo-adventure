module LiquidFilters
  include ActionView::Helpers::NumberHelper
  def currency(price)
    number_to_currency(price)
  end
end

class DaysFromNow < Liquid::Tag
  def initialize(tag_name, max, tokens)
     super
     @max = max.to_i
  end

  def render(context)
    @max.to_i.days.from_now
  end
end

module ToLiquidize
  def apply(user, profile, recipient, liquid_field_object_hash = nil)
    liquid_fields = {'profile' => profile, 'connection' => recipient, 'agent' => user}
    unless liquid_field_object_hash.blank?
      liquid_field_object_hash.each do |key, value|
        liquid_fields[key] = value
      end
    end
    liquidize self.replace_original_liquid, liquid_fields
  end

  def replace_original_liquid
    liquid_hash = Marketing::Email::Template.template_body_liquid_values
    original_message = self.body
    unless original_message.blank?
      liquid_hash.each do |key, value|
        original_message = original_message.gsub(key, value)
      end
    end
    return original_message
  end

  private

  def liquidize(content, arguments)
    Liquid::Template.register_tag('days_from_now', DaysFromNow)
    Liquid::Template.parse(content).render(arguments, :filters => [LiquidFilters])
  end
end

