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

  describe 'large dataset operations' do
    let(:large_dataset) { (1..100_000).to_a.shuffle }
    let(:large_list) { described_class.new(large_dataset) }

    it 'handles insertion of a large dataset' do
      expect(large_list.size).to eq(100_000)
      expect(large_list.to_a).to eq(large_dataset.sort)
    end

    it 'performs fast lookups' do
      expect {
        100.times { large_list.include?(rand(1..100_000)) }
      }.to perform_under(0.1).sec
    end

    it 'handles deletions efficiently' do
      expect {
        100.times { large_list.delete(rand(1..100_000)) }
      }.to perform_under(0.1).sec
      expect(large_list.size).to be_within(200).of(99_900)
    end

    it 'performs set operations on large datasets' do
      other_large_dataset = (50_000..150_000).to_a.shuffle
      other_large_list = described_class.new(other_large_dataset)

      expect {
        large_list | other_large_list
        large_list & other_large_list
        large_list - other_large_list
      }.to perform_under(2).sec

      expect((large_list | other_large_list).size).to be_within(10).of(150_000)
      expect((large_list & other_large_list).size).to be_within(10).of(50_000)
      expect((large_list - other_large_list).size).to be_within(10).of(50_000)
    end

    it 'handles large-scale insertions and deletions' do
      expect {
        10_000.times do
          large_list.delete(rand(1..100_000))
          large_list.insert(rand(1..100_000))
        end
      }.to perform_under(1).sec

      expect(large_list.size).to be_within(2000).of(100_000)

      sorted_list = large_list.to_a
      expect(sorted_list.first).to be >= 1
      expect(sorted_list.last).to be <= 100_000
      expect(sorted_list).to eq(sorted_list.sort)
    end
  end
end
