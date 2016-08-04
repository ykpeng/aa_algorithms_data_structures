require_relative 'heap2'

class PriorityMap
  def initialize(&prc)
    @map = {}
    @queue = BinaryMinHeap.new do |key1, key2|
      prc.call(@map[key1], @map[key2])
    end
  end

  def [](key)
    @map[key]
  end

  def []=(key, value)
    if !@map.include?(key)
      insert(key, value)
    else
      update(key, value)
    end
  end

  def count
    @queue.count
  end

  def empty?
    @queue.empty?
  end

  def extract
    vertex = @queue.extract
    data = @map[vertex]
    @map.delete(vertex)
    [vertex, data]
  end

  def has_key?(key)
    !!@map[key]
  end

  protected
  attr_accessor :map, :queue

  def insert(key, value)
    @map[key] = value
    @queue.push(key)
  end

  def update(key, value)
    @map[key] = value
    @queue.reduce!(key)
  end
end
