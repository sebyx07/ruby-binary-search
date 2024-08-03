# frozen_string_literal: true

module BinarySearch
  # A self-balancing binary search tree implementation of a list
  #
  # This class provides a list-like interface backed by a Red-Black Tree,
  # which ensures O(log n) time complexity for most operations.
  #
  # @example Creating and using a BinarySearch::List
  #   list = BinarySearch::List.new([3, 1, 4, 1, 5, 9, 2, 6, 5, 3, 5])
  #   list.to_a  # => [1, 1, 2, 3, 3, 4, 5, 5, 5, 6, 9]
  #   list.include?(4)  # => true
  #   list.delete(1)  # Removes all instances of 1
  #   list.to_a  # => [2, 3, 3, 4, 5, 5, 5, 6, 9]
  class List
    include Enumerable

    # Initialize a new BinarySearch::List
    #
    # @param from [Array] An array to initialize the list with
    #
    # @example Create an empty list
    #   list = BinarySearch::List.new
    #
    # @example Create a list from an array
    #   list = BinarySearch::List.new([1, 2, 3, 4, 5])
    def initialize(from = [])
      @tree = BinarySearch::RedBlackTree.new
      build_tree(from)
    end

    # Insert a value into the list
    #
    # This method inserts a value into the list, maintaining the sorted order.
    # It has a time complexity of O(log n).
    #
    # @param value [Object] The value to insert
    # @return [BinarySearch::List] The list object (for method chaining)
    #
    # @example Insert a value
    #   list.insert(4)  # => #<BinarySearch::List: ...>
    #   list << 5  # => #<BinarySearch::List: ...>
    def insert(value)
      @tree.insert(value)
      @size = nil
      self
    end
    alias_method :append, :insert
    alias_method :push, :insert
    alias_method :<<, :insert

    # Delete all occurrences of a value from the list
    #
    # This method removes all instances of the specified value from the list.
    # It has a time complexity of O(log n) for each deletion.
    #
    # @param value [Object] The value to delete
    # @return [Boolean] True if any elements were deleted, false otherwise
    #
    # @example Delete a value
    #   list = BinarySearch::List.new([1, 2, 2, 3, 4])
    #   list.delete(2)  # => true
    #   list.to_a  # => [1, 3, 4]
    def delete(value)
      deleted = false
      while @tree.find(value)
        @tree.remove(value)
        @size -= 1 if @size
        deleted = true
      end
      deleted
    end

    # Check if a value is in the list
    #
    # This method checks if the list contains the specified value.
    # It has a time complexity of O(log n).
    #
    # @param value [Object] The value to check for
    # @return [Boolean] True if the value is in the list, false otherwise
    #
    # @example Check for a value
    #   list = BinarySearch::List.new([1, 2, 3, 4, 5])
    #   list.include?(3)  # => true
    #   list.include?(6)  # => false
    def include?(value)
      !@tree.find(value).nil?
    end

    # Convert the list to an array
    #
    # This method returns an array representation of the list in sorted order.
    # It has a time complexity of O(n).
    #
    # @return [Array] An array representation of the list
    #
    # @example Convert to array
    #   list = BinarySearch::List.new([3, 1, 4, 1, 5, 9, 2, 6, 5, 3, 5])
    #   list.to_a  # => [1, 1, 2, 3, 3, 4, 5, 5, 5, 6, 9]
    def to_a
      inorder_traversal(@tree.root)
    end

    # Get the size of the list
    #
    # This method returns the number of elements in the list.
    # It has a time complexity of O(1) if the size is cached, or O(n) otherwise.
    #
    # @return [Integer] The number of elements in the list
    #
    # @example Get the size
    #   list = BinarySearch::List.new([1, 2, 3, 4, 5])
    #   list.size  # => 5
    def size
      @size ||= inorder_traversal(@tree.root).size
    end

    # Check if the list is empty
    #
    # This method checks if the list contains no elements.
    # It has a time complexity of O(1).
    #
    # @return [Boolean] True if the list is empty, false otherwise
    #
    # @example Check if empty
    #   list = BinarySearch::List.new
    #   list.empty?  # => true
    #   list.insert(1)
    #   list.empty?  # => false
    def empty?
      @tree.root.nil?
    end

    # Access elements by index or range
    #
    # This method allows accessing elements by index or range, similar to Array.
    # It has a time complexity of O(n) in the worst case.
    #
    # @param arg [Integer, Range] The index or range to access
    # @return [Object, BinarySearch::List, nil] The element(s) at the given index or range, or nil if out of bounds
    # @raise [ArgumentError] If the argument is not an Integer or Range
    #
    # @example Access by index
    #   list = BinarySearch::List.new([1, 2, 3, 4, 5])
    #   list[2]  # => 3
    #
    # @example Access by range
    #   list[1..3]  # => #<BinarySearch::List: [2, 3, 4]>
    def [](arg)
      case arg
      when Integer
        return nil if arg < 0 || arg >= size
        to_a[arg]
      when Range
        start = arg.begin
        finish = arg.end
        start = size + start if start < 0
        finish = size + finish if finish < 0
        finish -= 1 if arg.exclude_end?

        return nil if start < 0 || start >= size

        result = []
        (start..finish).each do |i|
          break if i >= size
          result << to_a[i]
        end
        self.class.new(result)
      else
        raise ArgumentError, "Invalid argument type: #{arg.class}"
      end
    end

    # Iterate over each element in the list
    #
    # This method yields each element in the list to the given block.
    # It has a time complexity of O(n).
    #
    # @yield [Object] Gives each element in the list to the block
    # @return [Enumerator] If no block is given
    #
    # @example Iterate over elements
    #   list = BinarySearch::List.new([1, 2, 3, 4, 5])
    #   list.each { |x| puts x }  # Prints each number on a new line
    def each(&block)
      to_a.each(&block)
    end

    # Clear all elements from the list
    #
    # This method removes all elements from the list, leaving it empty.
    # It has a time complexity of O(1).
    #
    # @return [BinarySearch::List] The empty list object
    #
    # @example Clear the list
    #   list = BinarySearch::List.new([1, 2, 3, 4, 5])
    #   list.clear  # => #<BinarySearch::List: []>
    #   list.empty?  # => true
    def clear
      @tree = BinarySearch::RedBlackTree.new
      @size = 0
      self
    end

    # Get the first element in the list
    #
    # This method returns the smallest element in the list.
    # It has a time complexity of O(log n).
    #
    # @return [Object, nil] The first element, or nil if the list is empty
    #
    # @example Get the first element
    #   list = BinarySearch::List.new([3, 1, 4, 1, 5, 9, 2, 6, 5, 3, 5])
    #   list.first  # => 1
    def first
      return nil if empty?
      leftmost_node(@tree.root).key
    end

    # Get the last element in the list
    #
    # This method returns the largest element in the list.
    # It has a time complexity of O(log n).
    #
    # @return [Object, nil] The last element, or nil if the list is empty
    #
    # @example Get the last element
    #   list = BinarySearch::List.new([3, 1, 4, 1, 5, 9, 2, 6, 5, 3, 5])
    #   list.last  # => 9
    def last
      return nil if empty?
      rightmost_node(@tree.root).key
    end

    # Remove and return the last element in the list
    #
    # This method removes and returns the largest element in the list.
    # It has a time complexity of O(log n).
    #
    # @return [Object, nil] The last element, or nil if the list is empty
    #
    # @example Remove the last element
    #   list = BinarySearch::List.new([1, 2, 3, 4, 5])
    #   list.pop  # => 5
    #   list.to_a  # => [1, 2, 3, 4]
    def pop
      return nil if empty?
      last_value = last
      @tree.remove(last_value)
      @size -= 1 if @size
      last_value
    end

    # Remove and return the first element in the list
    #
    # This method removes and returns the smallest element in the list.
    # It has a time complexity of O(log n).
    #
    # @return [Object, nil] The first element, or nil if the list is empty
    #
    # @example Remove the first element
    #   list = BinarySearch::List.new([1, 2, 3, 4, 5])
    #   list.shift  # => 1
    #   list.to_a  # => [2, 3, 4, 5]
    def shift
      return nil if empty?
      first_value = first
      @tree.remove(first_value)
      @size -= 1 if @size
      first_value
    end

    # Insert a value at the beginning of the list
    #
    # This method inserts a value at the beginning of the list.
    # It has a time complexity of O(log n).
    #
    # @param value [Object] The value to insert
    # @return [BinarySearch::List] The list object (for method chaining)
    #
    # @example Insert at the beginning
    #   list = BinarySearch::List.new([2, 3, 4, 5])
    #   list.unshift(1)  # => #<BinarySearch::List: [1, 2, 3, 4, 5]>
    def unshift(value)
      insert(value)
      self
    end

    # Get the maximum value in the list
    #
    # This method returns the largest element in the list.
    # It has a time complexity of O(log n).
    #
    # @return [Object, nil] The maximum value, or nil if the list is empty
    #
    # @example Get the maximum value
    #   list = BinarySearch::List.new([3, 1, 4, 1, 5, 9, 2, 6, 5, 3, 5])
    #   list.max  # => 9
    def max
      last
    end

    # Get the minimum value in the list
    #
    # This method returns the smallest element in the list.
    # It has a time complexity of O(log n).
    #
    # @return [Object, nil] The minimum value, or nil if the list is empty
    #
    # @example Get the minimum value
    #   list = BinarySearch::List.new([3, 1, 4, 1, 5, 9, 2, 6, 5, 3, 5])
    #   list.min  # => 1
    def min
      first
    end

    # Calculate the sum of all elements in the list
    #
    # This method returns the sum of all elements in the list.
    # It has a time complexity of O(n).
    #
    # @return [Numeric] The sum of all elements
    #
    # @example Calculate the sum
    #   list = BinarySearch::List.new([1, 2, 3, 4, 5])
    #   list.sum  # => 15
    def sum
      to_a.sum
    end

    # Find the first element that satisfies the given condition
    #
    # This method returns the first element for which the given block returns true.
    # It has a time complexity of O(n) in the worst case.
    #
    # @yield [Object] Gives each element to the block
    # @return [Object, nil] The first element for which the block returns true, or nil if none found
    #
    # @example Find an element
    #   list = BinarySearch::List.new([1, 2, 3, 4, 5])
    #   list.find { |x| x > 3 }  # => 4
    def find
      each { |element| return element if yield(element) }
      nil
    end

    # Create a new list with duplicate elements removed
    #
    # This method returns a new list with all duplicate elements removed.
    # It has a time complexity of O(n log n).
    #
    # @return [BinarySearch::List] A new list with unique elements
    #
    # @example Remove duplicates
    #   list = BinarySearch::List.new([1, 2, 2, 3, 3, 3, 4, 5])
    #   list.uniq.to_a  # => [1, 2, 3, 4, 5]
    def uniq
      self.class.new(to_a.uniq)
    end

    # Concatenate two lists
    #
    # This method returns a new list containing all elements from both lists.
    # It has a time complexity of O(n + m), where n and m are the sizes of the lists.
    #
    # @param other [BinarySearch::List] The list to concatenate
    # @return [BinarySearch::List] A new list containing elements from both lists
    #
    # @example Concatenate lists
    #   list1 = BinarySearch::List.new([1, 2, 3])
    #   list2 = BinarySearch::List.new([4, 5, 6])
    #   (list1 + list2).to_a  # => [1, 2, 3, 4, 5, 6]
    def +(other)
      self.class.new(to_a + other.to_a)
    end

    # Compute the difference between two lists
    #
    # This method returns a new list containing elements that are in the current list
    # but not in the other list, taking into account the number of occurrences of each element.
    # It has a time complexity of O(n log n + m log m), where n and m are the sizes of the lists.
    #
    # @param other [BinarySearch::List] The list to subtract
    # @return [BinarySearch::List] A new list containing elements in this list but not in the other
    #
    # @example Compute the difference
    #   list1 = BinarySearch::List.new([1, 2, 2, 3, 4, 5])
    #   list2 = BinarySearch::List.new([2, 4, 6])
    #   (list1 - list2).to_a  # => [1, 2, 3, 5]
    def -(other)
      result = self.class.new
      self_counts = Hash.new(0)
      other_counts = Hash.new(0)

      self.each { |item| self_counts[item] += 1 }
      other.each { |item| other_counts[item] += 1 }

      self_counts.each do |item, count|
        diff = count - other_counts[item]
        diff.times { result.insert(item) } if diff > 0
      end

      result
    end

    # Compute the intersection of two lists
    #
    # This method returns a new list containing elements common to both lists,
    # taking into account the number of occurrences of each element.
    # It has a time complexity of O(n log n + m log m), where n and m are the sizes of the lists.
    #
    # @param other [BinarySearch::List] The list to intersect with
    # @return [BinarySearch::List] A new list containing elements common to both lists
    #
    # @example Compute the intersection
    #   list1 = BinarySearch::List.new([1, 2, 2, 3, 4, 5])
    #   list2 = BinarySearch::List.new([2, 2, 4, 6])
    #   (list1 & list2).to_a  # => [2, 2, 4]
    def &(other)
      self.class.new(to_a & other.to_a)
    end

    # Compute the union of two lists
    #
    # This method returns a new list containing unique elements from both lists.
    # It has a time complexity of O(n log n + m log m), where n and m are the sizes of the lists.
    #
    # @param other [BinarySearch::List] The list to unite with
    # @return [BinarySearch::List] A new list containing unique elements from both lists
    #
    # @example Compute the union
    #   list1 = BinarySearch::List.new([1, 2, 3, 4])
    #   list2 = BinarySearch::List.new([3, 4, 5, 6])
    #   (list1 | list2).to_a  # => [1, 2, 3, 4, 5, 6]
    def |(other)
      self.class.new(to_a | other.to_a)
    end

    # Compare two lists for equality
    #
    # This method checks if two lists have the same elements in the same order.
    # It has a time complexity of O(n), where n is the size of the lists.
    #
    # @param other [Object] The object to compare with
    # @return [Boolean] True if the lists are equal, false otherwise
    #
    # @example Compare lists
    #   list1 = BinarySearch::List.new([1, 2, 3, 4, 5])
    #   list2 = BinarySearch::List.new([1, 2, 3, 4, 5])
    #   list3 = BinarySearch::List.new([5, 4, 3, 2, 1])
    #   list1 == list2  # => true
    #   list1 == list3  # => false
    def ==(other)
      return false unless other.is_a?(BinarySearch::List)
      return true if self.equal?(other)
      self.to_a == other.to_a
    end

    # Provide a string representation of the list
    #
    # This method returns a concise string representation of the list,
    # showing the class name and the size of the list.
    #
    # @return [String] A string representation of the list
    #
    # @example Inspect the list
    #   list = BinarySearch::List.new([1, 2, 3, 4, 5])
    #   list.inspect  # => "#<BinarySearch::List: (5 elements)>"
    def inspect
      "#<#{self.class}: (#{size} elements)>"
    end

    private
      # Build the tree from an initial list
      #
      # This method inserts each element from the initial list into the tree.
      # It has a time complexity of O(n log n), where n is the size of the initial list.
      #
      # @param list [Array] The initial list of elements
      # @return [void]
      def build_tree(list)
        list.each { |item| @tree.insert(item) }
        @size = list.size
      end

      # Perform an inorder traversal of the tree
      #
      # This method traverses the tree in-order and returns an array of the elements.
      # It has a time complexity of O(n), where n is the number of nodes in the tree.
      #
      # @param node [BinarySearch::RedBlackTree::Node] The current node
      # @param result [Array] The result array
      # @return [Array] An array of elements in sorted order
      def inorder_traversal(node, result = [])
        return result if node.nil?
        inorder_traversal(node.left, result)
        result << node.key
        inorder_traversal(node.right, result)
      end

      # Find the leftmost node in a subtree
      #
      # This method finds the node with the smallest key in the given subtree.
      # It has a time complexity of O(log n) in a balanced tree.
      #
      # @param node [BinarySearch::RedBlackTree::Node] The root of the subtree
      # @return [BinarySearch::RedBlackTree::Node] The leftmost node
      def leftmost_node(node)
        return node if node.left.nil?
        leftmost_node(node.left)
      end

      # Find the rightmost node in a subtree
      #
      # This method finds the node with the largest key in the given subtree.
      # It has a time complexity of O(log n) in a balanced tree.
      #
      # @param node [BinarySearch::RedBlackTree::Node] The root of the subtree
      # @return [BinarySearch::RedBlackTree::Node] The rightmost node
      def rightmost_node(node)
        return node if node.right.nil?
        rightmost_node(node.right)
      end
  end
end
