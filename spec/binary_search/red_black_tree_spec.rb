# frozen_string_literal: true

RSpec.describe BinarySearch::RedBlackTree do
  let(:tree) { described_class.new }

  describe '#initialize' do
    it 'creates an empty tree' do
      expect(tree.root).to be_nil
    end
  end

  describe '#insert' do
    it 'inserts a single node' do
      tree.insert(5)
      expect(tree.root.key).to eq(5)
      expect(tree.root.color).to eq(:black)
    end

    it 'maintains balance after multiple insertions' do
      [3, 1, 4, 5, 2].each { |key| tree.insert(key) }
      expect(tree.root.key).to eq(3)
      expect(tree.root.color).to eq(:black)
      expect(tree.root.left.key).to eq(1)
      expect(tree.root.right.key).to eq(4)
    end
  end

  describe '#remove' do
    before do
      [3, 1, 4, 5, 2].each { |key| tree.insert(key) }
    end

    it 'removes a leaf node' do
      tree.remove(5)
      expect(tree.send(:find, 5)).to be_nil
    end

    it 'removes a node with one child' do
      tree.remove(4)
      expect(tree.send(:find, 4)).to be_nil
      expect(tree.root.right.key).to eq(5)
    end

    it 'removes a node with two children' do
      tree.remove(3)
      expect(tree.send(:find, 3)).to be_nil
      expect([2, 4]).to include(tree.root.key)
    end

    it 'returns nil when removing a non-existent key' do
      expect(tree.remove(10)).to be_nil
    end
  end

  describe '#update' do
    before do
      [3, 1, 4, 5, 2].each { |key| tree.insert(key) }
    end

    it 'updates an existing key' do
      tree.update(3, 6)
      expect(tree.send(:find, 3)).to be_nil
      expect(tree.send(:find, 6)).not_to be_nil
    end

    it 'returns nil when updating a non-existent key' do
      expect(tree.update(10, 20)).to be_nil
    end
  end

  describe 'tree properties' do
    before do
      [5, 2, 7, 1, 3, 6, 8, 4].each { |key| tree.insert(key) }
    end

    it 'maintains the root as black' do
      expect(tree.root.color).to eq(:black)
    end

    it 'ensures red nodes have black children' do
      check_red_node_children(tree.root)
    end

    it 'maintains equal black height for all paths' do
      expect(black_height(tree.root.left)).to eq(black_height(tree.root.right))
    end

    it 'handles nil children of red nodes correctly' do
      tree = described_class.new
      tree.insert(1)
      tree.insert(2)
      expect(tree.root.color).to eq(:black)
      expect(tree.root.right.color).to eq(:red)
      expect(tree.root.left).to be_nil
      expect { check_red_node_children(tree.root) }.not_to raise_error
    end
  end

  def check_red_node_children(node)
    return if node.nil?

    if node.color == :red
      expect(node.left).to satisfy { |n| n.nil? || n.color == :black }
      expect(node.right).to satisfy { |n| n.nil? || n.color == :black }
    end

    check_red_node_children(node.left)
    check_red_node_children(node.right)
  end

  def black_height(node)
    return 0 if node.nil?

    left_height = black_height(node.left)
    right_height = black_height(node.right)

    expect(left_height).to eq(right_height)

    node.color == :black ? left_height + 1 : left_height
  end
end
