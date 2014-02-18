class Marketing::Quoter
  attr_accessor :agent, :color_1, :color_2, :color_3, :include_email, :include_name,
                :include_phone, :template

  def initialize(options={})
    return if options.blank?
    options.each do |k,v|
      self.send("#{k}=", v)
    end
  end
end
