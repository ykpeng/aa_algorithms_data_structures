class AVLTreeNode
  attr_accessor :link, :balance, :value

  def initialize(value)
    @value = value
    @link = [nil, nil]
    @balance = 0
  end
end

class AVLTree
  def initialize
    @root = nil
  end

  def insert(value)
    done = false
    @root, done = AVLTree.insert!(@root, value, done)

    true
  end

  def insert_unbounded(value)
    done = false
    @root, done = AVLTree.insert!(@root, value, done)

    true
  end

  def remove(value)
    done = false
    @root, done = AVLTree.remove!(@root, value, done)

    true
  end

  def remove_unbounded(value)
    done = false
    @root, done = AVLTree.remove_unbounded!(@root, value, done)

    true
  end

  def height
    AVLTree.height!(@root)
  end

  def self.insert!(node, value, done)
    return [AVLTreeNode.new(value), false] unless node

    dir = value < node.value ? 0 : 1

    node.link[dir], done = AVLTree.insert!(node.link[dir], value, done)

    unless done
      node.balance += (dir == 0 ? -1 : 1)

      if node.balance == 0
        done = true
      elsif node.balance.abs > 1
        node = AVLTree.insert_balance!(node, dir)
        done = true
      end
    end

    [node, done]
  end

  def self.single_rotation!(root, dir)
    other_dir = dir == 0 ? 1 : 0
    save = root.link[other_dir]

    root.link[other_dir] = save.link[dir]
    save.link[dir] = root

    save
  end

  def self.double_rotation!(root, dir)
    other_dir = dir == 0 ? 1 : 0
    save = root.link[other_dir].link[dir]

    root.link[other_dir].link[dir] = save.link[other_dir]
    save.link[other_dir] = root.link[other_dir]
    root.link[other_dir] = save

    save = root.link[other_dir]
    root.link[other_dir] = save.link[dir]
    save.link[dir] = root

    save
  end

  def self.adjust_balance!(root, dir, bal)
    other_dir = dir == 0 ? 1 : 0

    n = root.link[dir]
    nn = n.link[other_dir]

    if nn.balance == 0
      root.balance = 0
      n.balance = 0
    elsif nn.balance == bal
      root.balance = -bal
      n.balance = 0
    else
      root.balance = 0
      n.balance = bal
    end

    nn.balance = 0
  end

  def self.insert_balance!(root, dir)
    other_dir = dir == 0 ? 1 : 0

    n = root.link[dir]
    bal = dir == 0 ? -1 : +1

    if n.balance == bal
      root.balance = 0
      n.balance = 0
      root = AVLTree.single_rotation!(root, other_dir)
    else
      AVLTree.adjust_balance!(root, dir, bal)
      root = AVLTree.double_rotation!(root, other_dir)
    end

    root
  end

  def self.remove_balance!(root, dir, done)
    other_dir = dir == 0 ? 1 : 0

    n = root.link[other_dir]
    bal = dir == 0 ? -1 : 1

    if n.balance == -bal
      root.balance = 0
      n.balance = 0
      root = AVLTree.single_rotation!(root, dir)
    elsif n.balance == bal
      AVLTree.adjust_balance!(root, other_dir, -bal)
      root = AVLTree.double_rotation!(root, dir)
    else
      root.balance = -bal
      n.balance = bal
      root = AVLTree.single_rotation!(root, dir)
      done = true
    end

    [root, done]
  end

  def self.remove!(root, value, done)
    if root
      if root.value == value
        if root.link[0].nil? || root.link[1].nil?
          dir = root.link[0].nil? ? 1 : 0
          save = root.link[dir]

          return [save, done]
        else
          heir = root.link[0]
          until heir.link[1].nil?
            heir = heir.link[1]
          end

          root.value = heir.value
          value = heir.value
        end
      end

      dir = value < root.value ? 0 : 1
      root.link[dir], done = AVLTree.remove!(root.link[dir], value, done)

      unless done
        root.balance += (dir != 0 ? -1 : 1)

        if root.balance.abs == 1
          done = true
        elsif root.balance.abs > 1
          root, done = AVLTree.remove_balance!(root, dir, done)
        end
      end
    end

    [root, done]
  end

  def self.height!(root)
    return -1 unless root

    root.balance
  end

  def self.single_rotation_unbounded!(root, dir)
    other_dir = dir == 0 ? 1 : 0

    save = root.link[other_dir]

    root.link[other_dir] = save.link[dir]
    save.link[dir] = root

    rlh = AVLTree.height!(root.link[0])
    rrh = AVLTree.height!(root.link[1])
    slh = AVLTree.height!(save.link[other_dir])

    root.balance = [rlh, rrh].max + 1
    save.balance = [slh, root.balance].max + 1

    save
   end

   def self.double_rotation_unbounded!(root, dir)
     other_dir = dir == 0 ? 1 : 0

     root.link[other_dir] = AVLTree.single_rotation_unbounded!(root.link[other_dir], other_dir)

     AVLTree.single_rotation_unbounded!(root, dir)
   end

   def self.insert_unbounded!(root, value, done)
     return [AVLTreeNode.new(value), false] unless root

     dir = value < root.value ? 0 : 1
     other_dir = dir == 0 ? 1 : 0

     root.link[dir], done = AVLTree.insert_unbounded!(root.link[dir], value, done)

     unless done
       lh = AVLTree.height!(root.link[dir])
       rh = AVLTree.height!(root.link(other_dir))

       if (lh - rh) >= 2
         a = root.link[dir].link[dir]
         b = root.link[dir].link[other_dir]

         if AVLTree.height!(a) >= AVLTree.height!(b)
           root = AVLTree.single_rotation_unbounded!(root, other_dir)
         else
           root = AVLTree.double_rotation_unbounded!(root, other_dir)
         end

         done = true
       end

       lh = AVLTree.height!(root.link[dir])
       rh = AVLTree.height!(root.link[other_dir])
       max = [lh,rh].max

       root.balance = max + 1
     end

     [root, done]
   end

   def self.remove_unbounded!(root, value, done)
     if root
       if root.value == value
         if root.link[0].nil? || root.link[1].nil?
           dir = root.link[0].nil? ? 1 : 0
           save = root.link[dir]

           return [save, done]
         else
           heir = root.link[0]

           until heir.link[1].nil?
             heir = heir.link[1]
           end

           root.value = heir.value
           value = heir.value
         end
       end

       dir = value < root.value ? 0 : 1
       other_dir = dir == 0 ? 1 : 0

       root.link[dir], done = AVLTree.remove_unbounded!(root.link[dir], value, done)

       unless done
         lh = AVLTree.height!(root.link[dir])
         rh = AVLTree.height!(root.link[other_dir])
         max = [lh, rh].max

         root.balance = max + 1

         if (lh - rh) == -1
           done = true
         end

         if (lh - rh) <= -2
           a = root.link[other_dir].link[dir]
           b = root.link[other_dir].link[other_dir]

           if AVLTree.height!(a) <= AVLTree.height!(b)
             root = AVLTree.single_rotation_unbounded!(root, dir)
           else
             root = AVLTree.double_rotation_unbounded!(root, dir)
           end
         end
       end
     end

     [root, done]
   end
end
