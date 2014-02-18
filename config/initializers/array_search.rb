class Array
  def search(&block)
    self.each do |item|
      break item if block.call(item)
    end
  end
end