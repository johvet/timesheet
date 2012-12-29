class String
  def from_time
    result = 0
    factors = [1, 60, 3600, 24*3600]
    self.split(':').map(&:to_i).reverse[0..3].each_with_index do |val, index|
      result += val * factors[index]
    end
    result
  end
end