class Fixnum
  # Fixnum#hash already implemented for you
end

class Array
  def hash
    res = 0
    self.each_with_index do |el, i|
      res += el.hash ^ i.hash
    end
    res
  end
end

class String
  def hash
    res = 0
    self.bytes.each_with_index do |byte, i|
      res += byte.hash ^ i.hash
    end
    res
  end
end

class Hash
  # This returns 0 because rspec will break if it returns nil
  # Make sure to implement an actual Hash#hash method
  def hash
    res = 0
    sorted_keys = self.keys.sort
    sorted_keys.each do |key|
      res += key.hash ^ self[key].hash
    end
    res
  end
end
