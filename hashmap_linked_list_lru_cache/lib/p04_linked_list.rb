class Link
  attr_accessor :key, :val, :next, :prev

  def initialize(key = nil, val = nil)
    @key = key
    @val = val
    @next = nil
    @prev = nil
  end

  def to_s
    "#{@key}: #{@val}"
  end
end

class LinkedList
  include Enumerable

  def initialize
    @head = Link.new
    @tail = Link.new
    @head.next = @tail
    @tail.prev = @head
  end

  def [](i)
    each_with_index { |link, j| return link if i == j }
    nil
  end

  def first
    return nil if empty?
    @head.next
  end

  def last
    return nil if empty?
    @tail.prev
  end

  def empty?
    @head.next == @tail
  end

  def get(key)
    curr = @head.next
    while curr != @tail
      return curr.val if curr.key == key
      curr = curr.next
    end
    nil
  end

  def include?(key)
    curr = @head.next
    while curr != @tail
      return true if curr.key == key
      curr = curr.next
    end
    false
  end

  def insert(key, val)
    each { |link| return link.val = val if link.key == key }

    new_link = Link.new(key, val)

    @tail.prev.next = new_link
    new_link.prev = @tail.prev
    new_link.next = @tail
    @tail.prev = new_link

    new_link
  end

  def remove(key)
    curr = @head.next
    while curr != @tail
      if curr.key == key
        curr.prev.next = curr.next
        curr.next.prev = curr.prev
        curr.next, curr.prev = nil, nil
        return curr.val
      end
      curr = curr.next
    end
    nil
  end

  def each
    curr = @head.next
    while curr != @tail
      yield curr
      curr = curr.next
    end
    self
  end

  # uncomment when you have `each` working and `Enumerable` included
  def to_s
    inject([]) { |acc, link| acc << "[#{link.key}, #{link.val}]" }.join(", ")
  end
end
