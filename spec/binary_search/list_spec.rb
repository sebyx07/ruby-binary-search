# frozen_string_literal: true

# spec/binary_search/list_spec.rb

require 'spec_helper'
require 'binary_search/list'

RSpec.describe BinarySearch::List do
  let(:list) { described_class.new }
  let(:populated_list) { described_class.new([3, 1, 4, 1, 5, 9, 2, 6, 5, 3, 5]) }

  describe '#initialize' do
    it 'creates an empty list' do
      expect(list).to be_empty
    end

    it 'creates a list from an array' do
      expect(populated_list.to_a).to eq([1, 1, 2, 3, 3, 4, 5, 5, 5, 6, 9])
    end
  end

  describe '#push and #<<' do
    it 'adds an element to the list' do
      expect { list.push(1) }.to change { list.size }.by(1)
      expect { list << 2 }.to change { list.size }.by(1)
      expect(list.to_a).to eq([1, 2])
    end
  end

  describe '#insert' do
    it 'inserts an element and returns self' do
      expect(list.insert(1)).to eq(list)
      expect(list).to include(1)
    end
  end

  describe '#delete' do
    it 'removes an element from the list' do
      populated_list.delete(3)
      expect(populated_list).not_to include(3)
    end
  end

  describe '#include?' do
    it 'checks if an element is in the list' do
      expect(populated_list.include?(4)).to be true
      expect(populated_list.include?(7)).to be false
    end
  end

  describe '#to_a' do
    it 'returns an array representation of the list' do
      expect(populated_list.to_a).to eq([1, 1, 2, 3, 3, 4, 5, 5, 5, 6, 9])
    end
  end

  describe '#size and #empty?' do
    it 'returns the correct size' do
      expect(list.size).to eq(0)
      expect(populated_list.size).to eq(11)
    end

    it 'checks if the list is empty' do
      expect(list).to be_empty
      expect(populated_list).not_to be_empty
    end
  end

  describe '#[]' do
    let(:list) { described_class.new([1, 2, 3, 4, 5]) }

    it 'returns the element at the given index' do
      expect(list[0]).to eq(1)
      expect(list[4]).to eq(5)
    end

    it 'returns nil for out of bounds index' do
      expect(list[5]).to be_nil
      expect(list[-1]).to be_nil
    end

    it 'supports range indexing' do
      expect(list[1..-1].to_a).to eq([2, 3, 4, 5])
      expect(list[1...-1].to_a).to eq([2, 3, 4])
      expect(list[-3..-1].to_a).to eq([3, 4, 5])
    end

    it 'handles out-of-bounds ranges' do
      expect(list[0..10].to_a).to eq([1, 2, 3, 4, 5])
      expect(list[10..20].to_a).to eq([])
    end

    it 'raises an ArgumentError for invalid argument types' do
      expect { list['invalid'] }.to raise_error(ArgumentError)
    end
  end

  describe '#each' do
    it 'iterates over each element' do
      sum = 0
      populated_list.each { |e| sum += e }
      expect(sum).to eq(44)
    end
  end

  describe '#clear' do
    it 'removes all elements from the list' do
      expect { populated_list.clear }.to change { populated_list.empty? }.from(false).to(true)
    end
  end

  describe '#first and #last' do
    it 'returns the first and last elements' do
      expect(populated_list.first).to eq(1)
      expect(populated_list.last).to eq(9)
    end
  end

  describe '#pop and #shift' do
    it 'removes and returns the last element' do
      expect { populated_list.pop }.to change { populated_list.size }.by(-1)
      expect(populated_list.pop).to eq(6)
    end

    it 'removes and returns the first element' do
      expect { populated_list.shift }.to change { populated_list.size }.by(-1)
      expect(populated_list.shift).to eq(1)
    end
  end

  describe '#unshift' do
    it 'adds an element to the beginning of the list' do
      expect { list.unshift(1) }.to change { list.first }.from(nil).to(1)
    end
  end

  describe '#max and #min' do
    it 'returns the maximum and minimum elements' do
      expect(populated_list.max).to eq(9)
      expect(populated_list.min).to eq(1)
    end
  end

  describe '#sum' do
    it 'returns the sum of all elements' do
      expect(populated_list.sum).to eq(44)
    end
  end

  describe '#find' do
    it 'finds the first element matching the condition' do
      expect(populated_list.find { |e| e > 4 }).to eq(5)
    end
  end

  describe '#uniq' do
    it 'returns a new list with duplicate elements removed' do
      expect(populated_list.uniq.to_a).to eq([1, 2, 3, 4, 5, 6, 9])
    end
  end

  describe 'set operations' do
    let(:populated_list) { described_class.new([3, 1, 4, 1, 5, 9, 2, 6, 5, 3, 5]) }
    let(:other_list) { described_class.new([1, 2, 3, 7, 8]) }

    it 'performs union' do
      expect((populated_list | other_list).to_a).to eq([1, 2, 3, 4, 5, 6, 7, 8, 9])
    end

    it 'performs intersection' do
      expect((populated_list & other_list).to_a).to eq([1, 2, 3])
    end

    it 'performs difference' do
      expect((populated_list - other_list).to_a).to eq([1, 3, 4, 5, 5, 5, 6, 9])
    end

    it 'performs addition' do
      expect((list + other_list).to_a).to eq([1, 2, 3, 7, 8])
    end
  end

  describe '#==' do
    it 'compares two lists' do
      expect(populated_list).to eq(described_class.new([3, 1, 4, 1, 5, 9, 2, 6, 5, 3, 5]))
      expect(populated_list).not_to eq(described_class.new([1, 2, 3]))
    end
  end
end
