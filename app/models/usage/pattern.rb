class Usage::Pattern < ActiveRecord::Base
  attr_accessible :field_name, :model_for_pattern_id, :operator_id,
                  :owner_id, :ownership_id, :value

  # Associations
  belongs_to :operator, class_name: "Tagging::TagRuleOperator"
  belongs_to :model_for_pattern, class_name: "Crm::ModelForPattern"
  belongs_to :owner, class_name: "Usage::User"
  belongs_to :ownership, class_name: "Ownership"

  def to_scope
    datatype = Usage::User.columns_hash[self.field_name].type
    self.value = get_value_according_to_type(datatype)
    Usage::User.where("#{self.field_name} #{self.operator.name} #{self.value}")
  end

protected

  def get_value_according_to_type(datatype)
    case datatype
    when :integer
      self.value.to_i
    when :string
      self.value.to_s
    when :float
      self.value.to_f
    else
      self.value
    end
  end

end
