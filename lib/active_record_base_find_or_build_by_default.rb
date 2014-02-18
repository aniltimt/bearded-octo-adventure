=begin

The purpose of this patch is to allow certain ActiveRecord associations
to be built automatically if they are not found.

e.g.

class Foo < ActiveRecord::Base
  belongs_to :bar
  belongs_to :sol
  has_one :qux
  has_one :fiz
  find_or_build_by_default :bar, :qux
end

foo = Foo.new
foo.bar.present? # => true
foo.sol.present? # => false
foo.qux.present? # => true
foo.fiz.present? # => false

=end

module ActiveRecord
  class Base
    def self.find_or_build_by_default *associations
      associations.each do |name|
        alias_name = "find_#{name}"
        alias_method alias_name, name
        define_method name do
          send(alias_name) or send("build_#{name}")
        end
      end
    end

    def self.find_or_create_by_default *associations
      associations.each do |name|
        alias_name = "find_#{name}"
        alias_method alias_name, name
        define_method name do
          send(alias_name) or send("create_#{name}")
        end
      end
    end
  end
end