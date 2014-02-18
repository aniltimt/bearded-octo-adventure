module TobaccoInfoStereotype
  extend ActiveSupport::Concern

  def last_cigar=(date)
    super get_date_value(date)
  end

  def last_cigarette=(date)
    super get_date_value(date)
  end

  def last_nicotine_patch_or_gum=(date)
    super get_date_value(date)
  end

  def last_pipe=(date)
    super get_date_value(date)
  end

  def last_tobacco_chewed=(date)
    super get_date_value(date)
  end

  def get_date_value(date)
    date.class == Fixnum ? date.years.ago : date
  end

end
