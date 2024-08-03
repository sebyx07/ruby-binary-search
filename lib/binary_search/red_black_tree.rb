# frozen_string_literal: true

module BinarySearch
  # Implements a Red-Black Tree, a self-balancing binary search tree
  #
  # A Red-Black Tree is a type of self-balancing binary search tree that maintains
  # balance through the use of node colors (red and black) and a set of properties:
  #
  # 1. Every node is either red or black.
  # 2. The root is black.
  # 3. Every leaf (NIL) is black.
  # 4. If a node is red, then both its children are black.
  # 5. For each node, all simple paths from the node to descendant leaves contain the
  #    same number of black nodes.
  #
  # These properties ensure that the tree remains approximately balanced during
  # insertions and deletions, guaranteeing O(log n) time complexity for basic
  # operations like search, insert, and delete.
  class RedBlackTree
    # @return [Node, nil] The root node of the tree
    attr_reader :root

    # Initializes an empty Red-Black Tree
    def initialize
      @root = nil
    end

    # Inserts a new key into the tree
    #
    # The insertion process involves:
    # 1. Performing a standard BST insertion
    # 2. Coloring the new node red
    # 3. Rebalancing the tree to maintain Red-Black properties
    #
    # @param key [Comparable] The key to insert
    # @return [void]
    def insert(key)
      new_node = Node.new(key)
      if @root.nil?
        @root = new_node
        @root.color = :black
      else
        current = @root
        parent = nil
        while current
          parent = current
          if key < current.key
            current = current.left
          elsif key > current.key
            current = current.right
          else
            # For duplicates, we'll add to the right
            current = current.right
          end
        end
        new_node.parent = parent
        if key <= parent.key
          parent.left = new_node
        else
          parent.right = new_node
        end
        fix_insert(new_node)
      end
    end

    # Removes a key from the tree
    #
    # The removal process involves:
    # 1. Finding the node to be removed
    # 2. If the node has two children, replacing it with its successor
    # 3. Removing the node (or its successor)
    # 4. Rebalancing the tree if the removed node was black
    #
    # @param key [Comparable] The key to remove
    # @return [Node, nil] The removed node, or nil if the key was not found
    def remove(key)
      node = find(key)
      return nil unless node

      remove_node(node)
    end

    # Updates a key in the tree
    #
    # This operation ensures that the tree structure remains valid after updating a key.
    # It's implemented as a removal of the old key followed by an insertion of the new key.
    #
    # @param old_key [Comparable] The key to update
    # @param new_key [Comparable] The new key value
    # @return [Boolean, nil] true if updated, false if new_key already exists, nil if old_key not found
    def update(old_key, new_key)
      node = find(old_key)
      return nil unless node
      return false if find(new_key)

      node.key = new_key
      true
    end

    # Finds a node with the given key
    #
    # This method performs a standard binary search tree lookup.
    #
    # @param key [Comparable] The key to find
    # @return [Node, nil] The node with the given key, or nil if not found
    def find(key)
      current = @root
      while current
        return current if current.key == key
        current = key < current.key ? current.left : current.right
      end
      nil
    end

    private
      # Fixes the tree after insertion to maintain Red-Black properties
      #
      # This method is called after every insertion to ensure that the Red-Black
      # properties are maintained. It performs color changes and rotations as necessary.
      #
      # @param node [Node] The newly inserted node
      # @return [void]
      def fix_insert(node)
        while node.parent&.red?
          if node.parent == node.parent.parent&.left
            uncle = node.parent.parent&.right
            if uncle&.red?
              node.parent.color = :black
              uncle.color = :black
              node.parent.parent.color = :red
              node = node.parent.parent
            else
              if node == node.parent.right
                node = node.parent
                left_rotate(node)
              end
              node.parent.color = :black
              node.parent.parent.color = :red
              right_rotate(node.parent.parent)
            end
          else
            uncle = node.parent.parent&.left
            if uncle&.red?
              node.parent.color = :black
              uncle.color = :black
              node.parent.parent.color = :red
              node = node.parent.parent
            else
              if node == node.parent.left
                node = node.parent
                right_rotate(node)
              end
              node.parent.color = :black
              node.parent.parent.color = :red
              left_rotate(node.parent.parent)
            end
          end
        end
        @root.color = :black
      end

      # Performs a left rotation on the given node
      #
      # A left rotation is a local operation in a search tree that changes the structure
      # of the tree while preserving the search tree properties of the nodes involved.
      #
      # @param x [Node] The node to rotate
      # @return [void]
      def left_rotate(x)
        y = x.right
        x.right = y.left
        y.left.parent = x if y.left
        y.parent = x.parent
        if x.parent.nil?
          @root = y
        elsif x == x.parent.left
          x.parent.left = y
        else
          x.parent.right = y
        end
        y.left = x
        x.parent = y
      end

      # Performs a right rotation on the given node
      #
      # A right rotation is the mirror operation of a left rotation.
      #
      # @param y [Node] The node to rotate
      # @return [void]
      def right_rotate(y)
        x = y.left
        y.left = x.right
        x.right.parent = y if x.right
        x.parent = y.parent
        if y.parent.nil?
          @root = x
        elsif y == y.parent.right
          y.parent.right = x
        else
          y.parent.left = x
        end
        x.right = y
        y.parent = x
      end

      # Removes a node from the tree
      #
      # This method handles the actual removal of a node and calls the necessary
      # fix-up routines to maintain the Red-Black properties.
      #
      # @param node [Node] The node to remove
      # @return [void]
      def remove_node(node)
        if node.left && node.right
          successor = minimum(node.right)
          node.key = successor.key
          remove_node(successor)
        else
          child = node.left || node.right
          if node.black?
            if child&.red?
              child.color = :black
            else
              delete_case1(node)
            end
          end
          replace_node(node, child)
        end
        @root.color = :black if @root
      end

      # Finds the minimum node in a subtree
      #
      # This method is used in the deletion process to find the successor of a node.
      #
      # @param node [Node] The root of the subtree
      # @return [Node] The minimum node
      def minimum(node)
        node = node.left while node.left
        node
      end

      # Replaces one node with another in the tree
      #
      # This method is a helper for the removal process, updating the necessary
      # parent-child relationships.
      #
      # @param old [Node] The node to be replaced
      # @param new [Node, nil] The replacement node
      # @return [void]
      def replace_node(old, new)
        if old.parent.nil?
          @root = new
        elsif old == old.parent.left
          old.parent.left = new
        else
          old.parent.right = new
        end
        new.parent = old.parent if new
      end

      # Handles case 1 of the delete fixup
      #
      # The delete fixup cases are part of the algorithm to maintain Red-Black
      # properties after a black node is removed from the tree.
      #
      # @param node [Node] The node being processed
      # @return [void]
      def delete_case1(node)
        delete_case2(node) if node.parent
      end

      # Handles case 2 of the delete fixup
      #
      # @param node [Node] The node being processed
      # @return [void]
      def delete_case2(node)
        sibling = get_sibling(node)
        if sibling&.red?
          node.parent.color = :red
          sibling.color = :black
          if node == node.parent.left
            left_rotate(node.parent)
          else
            right_rotate(node.parent)
          end
        end
        delete_case3(node)
      end

      # Handles case 3 of the delete fixup
      #
      # @param node [Node] The node being processed
      # @return [void]
      def delete_case3(node)
        sibling = get_sibling(node)
        if node.parent.black? && sibling&.black? &&
          (!sibling.left || sibling.left.black?) &&
          (!sibling.right || sibling.right.black?)
          sibling.color = :red
          delete_case1(node.parent)
        else
          delete_case4(node)
        end
      end

      # Handles case 4 of the delete fixup
      #
      # @param node [Node] The node being processed
      # @return [void]
      def delete_case4(node)
        sibling = get_sibling(node)
        if node.parent.red? && sibling&.black? &&
          (!sibling.left || sibling.left.black?) &&
          (!sibling.right || sibling.right.black?)
          sibling.color = :red
          node.parent.color = :black
        else
          delete_case5(node)
        end
      end

      # Handles case 5 of the delete fixup
      #
      # @param node [Node] The node being processed
      # @return [void]
      def delete_case5(node)
        sibling = get_sibling(node)
        if sibling&.black?
          if node == node.parent.left &&
            (!sibling.right || sibling.right.black?) &&
            sibling.left&.red?
            sibling.color = :red
            sibling.left.color = :black
            right_rotate(sibling)
          elsif node == node.parent.right &&
            (!sibling.left || sibling.left.black?) &&
            sibling.right&.red?
            sibling.color = :red
            sibling.right.color = :black
            left_rotate(sibling)
          end
        end
        delete_case6(node)
      end

      # Handles case 6 of the delete fixup
      #
      # @param node [Node] The node being processed
      # @return [void]
      def delete_case6(node)
        sibling = get_sibling(node)
        sibling.color = node.parent.color
        node.parent.color = :black
        if node == node.parent.left
          sibling.right.color = :black if sibling.right
          left_rotate(node.parent)
        else
          sibling.left.color = :black if sibling.left
          right_rotate(node.parent)
        end
      end

      # Gets the sibling of a node
      #
      # This helper method is used in the delete fixup process.
      #
      # @param node [Node] The node whose sibling to find
      # @return [Node, nil] The sibling node, or nil if there is no sibling
      def get_sibling(node)
        return nil if node.parent.nil?
        node == node.parent.left ? node.parent.right : node.parent.left
      end
  end
end
