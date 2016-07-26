require_relative "static_array"

class DynamicArray
  attr_reader :length

  def initialize(capacity = 8)
    @capacity = capacity
    @store = StaticArray.new(capacity)
    @length = 0
  end

  # O(1)
  def [](index)
    validate!(index)
    @store[index]
  end

  # O(1)
  def []=(index, value)
    validate!(index)
    @store[index] = value
  end

  # O(1)
  def pop
    validate!(@length - 1)
    val = @store[@length - 1]
    @length -= 1
    val
  end

  # O(1) ammortized; O(n) worst case. Variable because of the possible
  # resize.
  def push(val)
    resize! if @length == @capacity
    @store[@length] = val
    @length += 1
  end

  # O(n): has to shift over all the elements.
  def shift
    validate!(0)
    (0..@length - 1).each do |index|
      @store[index] = @store[index + 1]
    end
    @length -= 1
  end

  # O(n): has to shift over all the elements.
  def unshift(val)
    resize! if @length == @capacity
    (@length - 1).downto(0) do |index|
      @store[index + 1] = @store[index]
    end
    @store[0] = val
    @length += 1
  end

  protected
  attr_accessor :capacity, :store
  attr_writer :length

  def check_index(index)
  end

  # O(n): has to copy over all the elements to the new store.
  def resize!
    new_capacity = @capacity * 2
    new_store = StaticArray.new(new_capacity)

    @length.times { |index| new_store[index] = @store[index] }
    @store = new_store
    @capacity = new_capacity
  end

  def validate!(index)
    raise "index out of bounds" unless index.between?(0, @length - 1)
  end
end
