module Processing
  class ExamOne
    module FieldFormatter
      def format_field(length, text = nil, strip_formatting = false)
        formatted_string = ""

        if text
          formatted_string = text
          formatted_string = text.slice 0..(length-1) if text.length > length
        end

        formatted_string.tr!("\n", "")
        formatted_string = remove_erroneous_characters(formatted_string) if strip_formatting
        formatted_string.ljust(length)
      end

      private

      def remove_erroneous_characters(string)
        string.tr(' ', '').tr('(', '').tr(')', '').tr('-', '')
      end
    end
  end
end
