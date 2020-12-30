module Enumerable
  # my_each

  def my_each
    input_arr = *self
    input_length = input_arr.length

    return to_enum(:my_each) unless block_given?

    (0...input_length).each do |j|
      yield(input_arr[j])
    end
    self
  end

  #  my_each_with_index

  def my_each_with_index
    input_arr = *self
    input_length = input_arr.length

    return to_enum(:my_each_with_index) unless block_given?

    (0...input_length).each do |j|
      yield(input_arr[j], j)
    end
    self
  end

  # my_select

  def my_select
    selected_arr = []
    return to_enum(:my_each_with_index) unless block_given?

    my_each do |item|
      next unless yield(item)

      selected_arr.push(item)
    end
    selected_arr
  end

  # my_all? 

  def my_all?(condition = nil)
    my_each do |item|
      if block_given?
        return false unless yield(item)
      elsif condition.class == Class
        return false unless item.is_a?(condition)
      elsif condition.class == Regexp
        return false unless item.match(condition)
      elsif !block_given? && condition.nil?
        return false unless item
      elsif !condition.nil?
        return false unless item == condition
      end
    end
    true
  end

  #  my_any? 

  def my_any?(condition = nil,&block)
    my_each do |item|
      if block_given?
        return true if block.call(item)
      elsif condition.class == Class
        return true if item.is_a?(condition)
      elsif condition.class == Regexp
        return true if item.match(condition)
      elsie !block_given? && condition.nil?
        return true if item
      elsif !condition.nil?
        return true if item == condition
      end
    end
    false
  end

  # my_none? 

  def my_none?(condition = nil,&block)
      !my_any?(condition,&block)
  end

  # my_count

  def my_count(counter = nil)
    arr = *self
    if counter
      temp_arr = my_select { |item| item == counter }
      return temp_arr.length
    elsif block_given?
      temp_arr = my_select { |item| yield(item) }
      return temp_arr.length
    end
    arr.length
  end

  # my_map 

  def my_map(myproc = nil)
    new_arr = []
    my_each do |item|
      if block_given? && myproc.nil?
        new_arr.push(yield(item))
      elsif (block_given? && myproc) || (!block_given? && myproc)
        new_arr.push(myproc.call(item))
      else return to_enum(:my_map)
      end
    end
    new_arr
  end

  # my_inject 

  def my_inject(*args,&block)
    arg1, arg2 = args
    return yield if !block_given? && !arg1

    if block_given?
      accumulator = arg1
      my_each do |item|
        accumulator = !accumulator ? item : yield(accumulator, item)
      end
    elsif arg1.is_a?(Symbol) || arg1.is_a?(String)
      accumulator = false
      my_each do |item|
        accumulator = !accumulator ? item : accumulator.send(arg1, item)
      end
    elsif arg2.is_a?(Symbol) || arg2.is_a?(String)
      accumulator = arg1
      my_each do |item|
        accumulator = !accumulator ? item : accumulator.send(arg2, item)
      end

    end

    accumulator
  end
end

#  multiply_els 

def multiply_els(arr)
  arr.my_inject(1, :*)
end
