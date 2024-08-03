# frozen_string_literal: true

module BinarySearch
  class RedBlackTree
    # Represents a node in the Red-Black Tree
    #
    # A node contains a key, color, references to its left and right children,
    # and a reference to its parent. The color is used to maintain the balance
    # properties of the Red-Black Tree.
    Node = Struct.new('Node', :key, :color, :left, :right, :parent) do
      # Creates a new Node
      #
      # @param key [Comparable] The key stored in the node
      # @param color [Symbol] The color of the node (:red or :black)
      # @param left [Node, nil] The left child of the node
      # @param right [Node, nil] The right child of the node
      # @param parent [Node, nil] The parent of the node
      def initialize(key, color = :red, left = nil, right = nil, parent = nil)
        super(key, color, left, right, parent)
      end

      # Checks if the node is black
      #
      # @return [Boolean] true if the node is black, false otherwise
      def black?
        color == :black
      end

      # Checks if the node is red
      #
      # @return [Boolean] true if the node is red, false otherwise
      def red?
        color == :red
      end
    end
  end
end
