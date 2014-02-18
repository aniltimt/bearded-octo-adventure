module CapybaraHelpers
  class Filler
    # This class holds data to make Capybara function calls more convenient
    # for the programmer.
    #
    # It holds methods which call Capybara methods of the same name but of
    # different arguments. For instance, :fill_in, :select, :choose.
    #
    # For arguments, this class' convenience methods take either the name of
    # a field or a Hash of options. If given a field name, the method shall
    # use the value of the given field as the value to fill_in, select, etc.
    # If given a Hash, the Hash may contain :field, :value, :name. If :value is
    # a Proc, then :field must also be supplied, and the given Proc shall be
    # called on the value of the field.

    attr_reader :page, :prefix, :object # object is the (terminal) object representing the end of the prefix

    # Constructor
    def initialize page_or_parent, *prefixers
      if page_or_parent.is_a? self.class
        parent = page_or_parent
        @page = parent.page
        @prefix, @object = self.class._prefix_and_object(prefixers, parent.prefix, parent.object)
      else
        @page = page_or_parent
        @prefix, @object = self.class._prefix_and_object(prefixers)
      end
    end

    # Build another Filler which descends from this one
    def child *prefixers
      self.class.new self, *prefixers
    end

    # Choose radio button
    def choose arg
      name, value = self.class._name_and_value @object, @prefix, arg
      id = name.gsub(/[\[\]]+/, '_') + value.to_s
      @page.choose id
    end

    # Fill text input
    def fill_in arg
      name, value = self.class._name_and_value @object, @prefix, arg
      @page.fill_in name, with:value
    end

    # Choose option by value from select
    def select arg
      name, value = self.class._name_and_value @object, @prefix, arg
      return if value.nil?
      @page.within "[name='#{name}']" do
        @page.find("option[value='#{value}']").click
      end
    end

    # Fill text input
    def self.fill_in page, *args
      field_arg = args.pop
      prefix, object = _prefix_and_object args
      name, value = _name_and_value object, prefix, field_arg
      page.fill_in name, with:value
    end

    # Choose option by value from select
    def self.select page, *args
      field_arg = args.pop
      prefix, object = _prefix_and_object args
      name, value = _name_and_value object, prefix, field_arg
      page.within "[name='#{name}']" do
        page.find("option[value='#{value}']").click
      end
    end

    private

    # Called when an instance or the class is ready to interact with the page.
    # Returns the name and value which should be supplied to a Capybara method.
    def self._name_and_value object, prefix, field_or_options
      if field_or_options.is_a? Hash
        field  = field_or_options[:field]
        object = field_or_options[:object] if field_or_options.has_key?(:object)
        name   = field_or_options.fetch(:name, "#{prefix}[#{field}]")
        value  = field_or_options.fetch(:value, object.send(field))
      else
        name   = "#{prefix}[#{field_or_options}]"
        value  = object.send(field_or_options)
      end
      value = value.call(object.send(field)) if value.is_a? Proc
      [name, value]
    end

    # Called when a new instance is initialized or when
    # a public class method is started.
    # Prepares the prefix for the name and the (terminal) object
    # which holds the fields to be queried later.
    #
    # Any prefixer may be an Array or Hash or String or Symbol.
    #
    # The arg prefix can be supplied if this method
    # should create a prefix from an existing prefix (i.e. extend an
    # existing prefix).
    def self._prefix_and_object prefixers, prefix=nil, object=nil
      child_index = nil
      prefixers.each do |prefixer|
        if prefixer.is_a? Array # ..., [obj,:name], ...
          object = prefixer.first
          prefixer = prefixer.last
        elsif prefixer.is_a? Hash # ..., {prefix:'name', object:obj, child_index:'2'}, ...
          child_index = prefixer[:child_index] if prefixer.has_key?(:child_index)
          object = prefixer[:object] if prefixer.has_key?(:object)
          prefixer = prefixer[:prefix] if prefixer.has_key?(:prefix)
        elsif object.present?
          object = object.send(prefixer)
        end
        prefix.nil? ? (prefix = prefixer.to_s) : (prefix += "[#{prefixer}_attributes]")
        if child_index.present?
          prefix += "[#{child_index}]"
          child_index = nil
        end
      end
      return [prefix, object]
    end
  end
end