module ActiveRecord
  class Base

    def self.parse_to_scope(parameter_string, field_names_for_simple_search=[])
      # Build initial scope
      relation = self.where(nil)
      # Split parameter_string into search terms (separated by non-quoted whitespace)
      params = parameter_string.scan(/[A-z_\.]+[!]{0,1}[=<>]{1,2}'.\S.+?'|[A-z_\.]+[!]{0,1}[=<>]{1,2}".\S.+?"|[\S]+/)
      # Create string for prepared statement for simple search
      prepared_string = field_names_for_simple_search.map{|name| "#{name} = ?" }.join(' OR ')
      # Build and merge scopes for each search term
      params.each do |param|
        relation = relation.merge parse_single_term_to_scope(param, field_names_for_simple_search, prepared_string)
      end
      # Return
      relation
    end

    def self.parse_single_term_to_scope(key_value_text, field_names_for_simple_search, prepared_string)
      # split key from value on pattern <key><operator><value>
      key, operator, value = key_value_text.partition(/(=~)|(!=)|(>=)|(<=)|=|>|</)

      # Simple search (only works for string args, only works on fields on current model)
      if operator.blank?
        
        # scope value for each of the field_names_for_simple_search
        value = key
        prepared_args = field_names_for_simple_search.map{ value }
        return self.where [prepared_string, *prepared_args]
     
      # Complex search
      else

        # get value as string (without quotation marks)
        value = value.gsub("\'", "").gsub("\"", "")

        # parse key into associations chain and field name
        associations = key.split('.').map(&:to_sym)
        field_name = associations.pop
        
        # Prepare to find class for furthest association
        klass = self

        # Return relation for search type %s=%s (i.e. no associations are involved)
        if associations.empty?
          value = _type_cast_value(klass, field_name, value)
          return self.where("#{klass.table_name}.#{field_name} #{operator} ?", value)
        end

        # Iterate through associations to get class of last association
        associations.each do |assoc|
          klass = klass.reflections[assoc].klass
        end

        # Determine table name for last association
        table_name = klass.table_name
        
        # Build argument for self::joins
        join_arg = associations.first
        associations[1..-1].each do |assoc|
          join_arg = { join_arg => assoc }
        end

        # Build & return relation
        value = _type_cast_value(klass, field_name, value)
        self.joins(join_arg).where("#{table_name}.#{field_name} #{operator} ?", value)
      end
    end

    private

    def self._type_cast_value(klass, field_name, value)
      raise "value arg must be String" unless value.is_a?(String)
      case Hash[ klass.columns.map{|col| [col.name, col.type] } ][field_name.to_s]
      when :integer
        value.to_i
      when :float, :decimal
        value.to_f
      when :date
        Date.parse value
      when :datetime
        Time.parse value
      when :string
        value.to_s
      when :boolean
        (value =~ (/(true|t|yes|y|1)$/i)).present?
      end
    end

  end
end
