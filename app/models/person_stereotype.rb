module PersonStereotype
  extend ActiveSupport::Concern
  include HasContactInfoStereotype

  # Specify methods for liquid
  liquid_methods :age, :anniversary, :birth, :first_name, :last_name, :title

  included do
    # Scope Users for full names
    scope :search_full_name, lambda { |q|
      where( "first_name like ? OR last_name like ? OR concat(first_name, ' ', last_name) like ?
          OR concat(first_name, ' ', middle_name, ' ', last_name) like ? ",
          '%'+ q + '%', '%'+ q + '%','%'+ q + '%','%'+ q + '%')
    }

    scope :search_by_first_or_last_name, lambda {|q|
      where("first_name in (?) OR last_name in (?)", q, q)
    }
  end

  def age
    today = Date.today
    today.year - birth.year - (birth.change(year: today.year) > today ? 1 : 0)
  end

  def birth_year
    return nil if self.birth.blank?
    self.birth.year
  end

  def birth_year=(year)
    return nil if self.birth.blank?
    self.birth = Date.new(year.to_i, self.birth.month, self.birth.day)
  end

  def birth_month
    return nil if self.birth.blank?
    self.birth.month
  end

  def birth_month=(month)
    return nil if self.birth.blank?
    self.birth = Date.new(self.birth.year, month, self.birth.day)
  end

  def birth_day
    return nil if self.birth.blank?
    self.birth.day
  end

  def birth_day=(day)
    return nil if self.birth.blank?
    self.birth = Date.new(self.birth.year, self.birth.month, day)
  end

  def full_name
    [first_name, middle_name, last_name].compact.join(" ")
  end

  def full_name= value
    names = value.split(/\s+/)
    first_name = names.shift
    last_name = names.pop
    middle_name = names.first
    self.first_name = first_name if first_name.present?
    self.last_name = last_name if last_name.present?
    self.middle_name = middle_name if middle_name.present?
  end
end
