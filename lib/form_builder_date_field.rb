module ActionView
  module Helpers
    class FormBuilder

      # Make a field whose class includes 'date' and whose value is formatted to %m/%d/%Y
      def date_field method, options={}
        options[:value] = self.object.send(method).try(:to_date).try(:strftime, "%m/%d/%Y") rescue nil
        options[:class].is_a?(String) ? options[:class] += ' date' : options[:class] = 'date'
        text_field method, options
      end

    end
  end
end