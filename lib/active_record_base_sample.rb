module ActiveRecord
  class Base
    def self.sample
      self.offset(rand(self.count)).first
    end
  end
end