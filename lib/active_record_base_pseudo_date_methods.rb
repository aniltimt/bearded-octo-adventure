=begin
	
The purpose of this patch is to make pseudo-date accessor and mutator methods.

So if you have a date field :red_letter on a class MyClass,
calling MyClass::pseudo_date_accessor(:red_letter, prev:true) can generate useful methods
  :years_since_red_letter
  :years_since_red_letter=
calling MyClass::pseudo_date_accessor(:red_letter, next:true) generates
  :years_until_red_letter
  :years_until_red_letter=

You can customize the names of the generated methods:
calling MyClass::pseudo_date_acecssor(:red_letter, prev:'years_since_she_left_me', next:'years_until_i_stop_crying') generates
  :years_since_she_left_me
  :years_since_she_left_me=
  :years_until_i_stop_crying
  :years_until_i_stop_crying=
...all of which get/set the attribute :red_letter

=end

module ActiveRecord
	class Base

		def self.pseudo_date_accessor attr_name, options={}

			def _make_date_options_for_pseudo_date_accessor value
				options = {}
				if value.is_a? String
					value = value.include?('.') ? Float(value) : Integer(value)
				end
				if value.is_a? Float
					options[:days] = ((value%1)*365).floor
				end
				options[:years] = value.floor
				options
			end

			if options[:prev]
				# define getter
				define_method(options[:prev]) {
					unless self.read_attribute(attr_name).nil?
						current_year - self.read_attribute(attr_name).year rescue nil
					end
				}
				# define setter
				define_method("#{options[:prev]}=") { |val|
					begin
						if val.blank?
							val = nil
						elsif not val.is_a? Date
							val = self.class._prev_date _make_date_options_for_pseudo_date_accessor(val)
						end
						self.send :write_attribute, attr_name, val
					rescue
					end
				}
				# attr accessible
				attr_accessible options[:prev] if self.accessible_attributes.include?(attr_name.to_s)
			end

			if options[:next]
				# define getter
				define_method(options[:next]) {
					unless self.read_attribute(attr_name).nil?
						current_year + self.read_attribute(attr_name).year rescue nil
					end
				}
				# define setter
				define_method("#{options[:next]}=") { |val|
					if val.blank?
						val = nil
					elsif not val.is_a? Date
						val = self.class._next_date _make_date_options_for_pseudo_date_accessor(val)
					end
					self.send :write_attribute, attr_name, val
				}
				# attr accessible
				attr_accessible options[:next] if self.accessible_attributes.include?(attr_name.to_s)
			end

		end

		def self.current_date
			@@current_date ||= Date.today
		end

		def self.current_year
			@@current_year ||= Date.today.year
		end

		def self._prev_date options={}
			new_date = current_date
			options.keys.each do |key|
				new_date -= options[key].send(key) unless options[key].nil?
			end
			new_date
		end

		def self._next_date(increment)
			new_date = current_date
			options.keys.each do |key|
				new_date += options[key].send(key) unless options[key].nil?
			end
			new_date
		end

	end
end