module HealthInfoStereotype
  extend ActiveSupport::Concern

  include TobaccoInfoStereotype

  def height
    height = ''
    height += "#{@feet}'" if @feet.to_i > 0
    height += "#{@inches}\"" if @inches.to_i > 0
    return height
  end

  def height=(val)
    feet_regx = /^[0-9]+\'/
    if feet_regx.match(val)
      @feet = feet_regx.match(val).to_s.gsub(/\'/, '')
    end
    inches_regx = /[0-9]+\"$/
    if inches_regx.match(val)
      @inches = inches_regx.match(val).to_s.gsub(/\"/, '')
    end
  end

end

