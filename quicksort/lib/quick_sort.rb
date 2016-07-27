class QuickSort
  # Quick sort has average case time complexity O(nlogn), but worst
  # case O(n**2).

  # Not in-place. Uses O(n) memory.
  def self.sort1(array)
    return array if array.length < 2
    pivot = array[0]
    left = arr[1..-1].select { |el| el < pivot }
    right = arr[1..-1].select { |el| el > pivot }
    sort1(left) + [pivot] + sort1(right)
  end

  # In-place.
  def self.sort2!(array, start_idx = 0, length = array.length, &prc)
    prc ||= Proc.new { |a, b| a <=> b }

    return array if length < 2

    # rand_idx = rand(length) + start_idx
    # array[start_idx], array[rand_idx] = array[rand_idx], array[start_idx]
    pivot = array[start_idx]
    pivot_idx = partition(array, start_idx, length, &prc)

    left_len = pivot_idx - start_idx
    right_len = length - (left_len + 1)
    sort2!(array, start_idx, left_len, &prc)
    sort2!(array, pivot_idx + 1, right_len, &prc)

    array
  end

  def self.partition(array, start_idx, length, &prc)
    prc ||= Proc.new { |a, b| a <=> b }

    pivot_idx = start_idx
    (start_idx + 1..start_idx + length - 1).each do |idx|
      if prc.call(array[idx], array[pivot_idx]) < 0
        array[pivot_idx + 1], array[idx] = array[idx], array[pivot_idx + 1]
        array[pivot_idx], array[pivot_idx + 1] = array[pivot_idx + 1], array[pivot_idx]

        pivot_idx += 1
      end
    end

    pivot_idx
  end
end
