require_relative 'p02_hashing'

class HashSet
  attr_reader :count

  def initialize(num_buckets = 8)
    @store = Array.new(num_buckets) { Array.new }
    @count = 0
  end

  def insert(key)
    return false if include?(key)
    resize! if @count == num_buckets
    self[key] << key
    @count += 1

    key
  end

  def include?(key)
    self[key].include?(key)
  end

  def remove(key)
    return nil unless include?(key)
    self[key].delete(key)
    @count -= 1
    
    key
  end

  private

  def [](num)
    # optional but useful; return the bucket corresponding to `num`
    @store[num.hash % num_buckets]
  end

  def num_buckets
    @store.length
  end

  def resize!
    new_length = num_buckets * 2
    new_store = Array.new(new_length) { Array.new }

    @store.each do |bucket|
      bucket.each do |el|
        new_store[el % new_length] << el
      end
    end

    @store = new_store
  end
end
