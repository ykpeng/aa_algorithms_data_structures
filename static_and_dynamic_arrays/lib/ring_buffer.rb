require_relative "static_array"

class RingBuffer
  attr_reader :length

  def initialize(capacity = 8)
    @capacity = capacity
    @store = StaticArray.new(capacity)
    @length = 0
    @start_idx = 0
  end

  # O(1)
  def [](index)
    validate!(index)
    @store[check_index(index)]
  end

  # O(1)
  def []=(index, val)
    validate!(index)
    @store[check_index(index)] = val
  end

  # O(1)
  def pop
    validate!(@length - 1)
    @length -= 1
    val = @store[check_index(@length)]
  end

  # O(1) ammortized
  def push(val)
    resize! if @length == @capacity
    @store[check_index(@length)] = val
    @length += 1
  end

  # O(1)
  def shift
    validate!(0)
    val = self[0]
    @start_idx = (@start_idx + 1) % @capacity
    @length -= 1
    val
  end

  # O(1) ammortized
  def unshift(val)
    resize! if @length == @capacity
    index = check_index(-1)
    @store[index] = val
    @start_idx = index
    @length += 1
  end

  protected
  attr_accessor :capacity, :start_idx, :store
  attr_writer :length

  def check_index(index)
    (@start_idx + index) % capacity
  end

  def resize!
    new_capacity = @capacity * 2
    new_store = StaticArray.new(new_capacity)
    @length.times { |index| new_store[index] = self[index] }
    @start_idx = 0
    @capacity = new_capacity
    @store = new_store
  end

  def validate!(index)
    raise "index out of bounds" unless index.between?(0, @length - 1)
  end
end
