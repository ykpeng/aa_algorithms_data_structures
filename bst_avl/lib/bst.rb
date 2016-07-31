class BSTNode
  attr_accessor :left, :right
  attr_reader :value

  def initialize(value)
    @value, @left, @right = value, nil, nil
  end
end

class BinarySearchTree
  def initialize
    @root = nil
  end

  def insert(value)
    @root = self.class.insert!(@root, value)
  end

  def find(value)
    self.class.find!(@root, value)
  end

  def inorder
    self.class.inorder!(@root)
  end

  def postorder
    self.class.postorder!(@root)
  end

  def preorder
    self.class.preorder!(@root)
  end

  def height
    self.class.height!(@root)
  end

  def min
    self.class.min(@root)
  end

  def max
    self.class.max(@root)
  end

  def delete(value)
    self.class.delete!(@root, value)
  end

  def self.insert!(node, value)
    if !node
      BSTNode.new(value)
    else
      if value <= node.value
        if !node.left
          node.left = BSTNode.new(value)
        else
          self.insert!(node.left, value)
        end
      else
        if !node.right
          node.right = BSTNode.new(value)
        else
          self.insert!(node.right, value)
        end
      end
      node
    end
  end

  def self.find!(node, value)
    return nil if !node
    if node.value == value
      return node
    elsif value < node.value
      if !node.left
        return nil
      else
        self.find!(node.left, value)
      end
    else
      if !node.right
        return nil
      else
        self.find!(node.right, value)
      end
    end
  end

  def self.preorder!(node)
    arr = []
    return arr if !node

    arr << node.value

    if node.left
      left_res = self.preorder!(node.left)
      arr.concat(left_res)
    end

    if node.right
      right_res = self.preorder!(node.right)
      arr.concat(right_res)
    end

    arr
  end

  def self.inorder!(node)
    arr = []
    return arr if !node

    if node.left
      left_res = self.inorder!(node.left)
      arr.concat(left_res)
    end

    arr << node.value

    if node.right
      right_res = self.inorder!(node.right)
      arr.concat(right_res)
    end

    arr
  end

  def self.postorder!(node)
    arr = []
    return arr if !node

    if node.left
      left_res = self.postorder!(node.left)
      arr.concat(left_res)
    end

    if node.right
      right_res = self.postorder!(node.right)
      arr.concat(right_res)
    end

    arr << node.value

    arr
  end

  def self.height!(node)
    return -1 if !node

    if !node.left
      left_height = 0
    else
      left_height = 1 + self.height!(node.left)
    end

    if !node.right
      right_height = 0
    else
      right_height = 1 + self.height!(node.right)
    end

    [left_height, right_height].max
  end

  def self.max(node)
    return node if !node.right
    self.max(node.right)
  end

  def self.min(node)
    return node if !node.left
    self.min(node.left)
  end

  def self.delete_min!(node)
    if !node
      return nil
    elsif !node.left
      return node.right
    else
      node.left = self.delete_min!(node.left)
      node
    end
  end

  def self.delete!(node, value)
    return nil if !node

    if value < node.value
      node.left = self.delete!(node.left, value)
    elsif
      node.right = self.delete!(node.right, value)
    else
      return node.left if !node.right
      return node.right if !node.left

      t = node
      node = t.right.min
      node.right = self.delete_min!(t.right)
      node.left = t.left
    end

    node
  end
end
