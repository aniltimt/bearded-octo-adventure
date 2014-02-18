=begin
	
One purpose of this patch is to set the _before_type_cast values of all
date fields to match a given string format.

This is useful to perform in a controller when you know the view is going
to have text inputs for the date fields. If this method is used, then the
dates in the text inputs will appear in the format you specify

=end

module ActiveRecord
	class Base

		# If column_names arg is nil, then all columns whose data type is :date
		# will be formatted.
		def format_date_strings! fmt='%m/%d/%Y', column_names=nil
			column_names ||= self.class.columns.select{|col| col.type == :date}.map(&:name)
			column_names.each do |name|
				if self.send(name).present?
					self.attributes = {name => self.send(name).strftime(fmt) } rescue self.send(name)
				end
			end
		end
		
	end
end