class Fixnum
  def to_time
    [self.to_i / 3600, self.to_i / 60 % 60, self.to_i % 60].map {|x| x.to_s.rjust(2, '0')}.join(':')
  end
end