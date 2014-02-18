# Read about factories at https://github.com/thoughtbot/factory_girl

# Used for factories
def enum_value model
  if model.instance_variable_get('@row_count_for_factory_girl').nil?
    model.instance_variable_set('@row_count_for_factory_girl', model.count)
  end
  1 + rand(model.instance_variable_get('@row_count_for_factory_girl'))
end
