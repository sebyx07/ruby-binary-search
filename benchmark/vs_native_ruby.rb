# frozen_string_literal: true

require 'benchmark'
require 'ruby_binary_search'
require 'numo/narray'
require 'set'

def run_benchmark(n)
  array = []
  binary_search_gem = BinarySearch::List.new
  narray = Numo::Int32.new(n)
  sorted_array = (0...n).to_a

  results = {}

  Benchmark.bm(30) do |x|
    # Insertion
    results[:array_insert] = x.report('Array#<< (append):') do
      n.times { |i| array << i }
    end

    results[:binary_search_gem_insert] = x.report('BinarySearch GEM#insert:') do
      n.times { |i| binary_search_gem.insert(i) }
    end

    results[:narray_insert] = x.report('Numo::NArray.new + .seq:') do
      narray = Numo::Int32.new(n).seq
    end

    results[:sorted_set_insert] = x.report('SortedSet#add:') do
      sorted_set = SortedSet.new
      n.times { |i| sorted_set.add(i) }
    end

    # Search
    results[:array_search] = x.report('Array#include?:') do
      n.times { |i| array.include?(i) }
    end

    results[:binary_search_gem_search] = x.report('BinarySearch GEM#include?:') do
      n.times { |i| binary_search_gem.include?(i) }
    end

    results[:narray_search] = x.report('Numo::NArray#eq + .any?:') do
      n.times { |i| narray.eq(i).any? }
    end

    results[:array_bsearch] = x.report('Array#bsearch (std lib):') do
      n.times { |i| sorted_array.bsearch { |x| x >= i } }
    end

    # Deletion
    results[:array_delete] = x.report('Array#delete:') do
      n.times { |i| array.delete(i) }
    end

    results[:binary_search_gem_delete] = x.report('BinarySearch GEM#delete:') do
      n.times { |i| binary_search_gem.delete(i) }
    end

    results[:narray_delete] = x.report('Numo::NArray delete (mask):') do
      temp_narray = narray.copy
      n.times do |i|
        mask = temp_narray.ne(i)
        temp_narray = temp_narray[mask]
      end
    end

    results[:sorted_set_delete] = x.report('SortedSet#delete:') do
      sorted_set = SortedSet.new(0...n)
      n.times { |i| sorted_set.delete(i) }
    end
  end

  print_comparison(results)
end

def print_comparison(results)
  operations = [
    ['Insertion', :array_insert, :binary_search_gem_insert, :narray_insert, :sorted_set_insert],
    ['Search', :array_search, :binary_search_gem_search, :narray_search, :array_bsearch],
    ['Deletion', :array_delete, :binary_search_gem_delete, :narray_delete, :sorted_set_delete]
  ]

  operations.each do |op, *keys|
    puts "#{op}:"
    times = keys.map { |k| results[k].real }
    fastest = times.min
    keys.zip(times).each do |key, time|
      name = results[key].label.strip
      if time == fastest
        puts "  #{name} is the fastest"
      else
        times_slower = (time / fastest).round(2)
        puts "  #{name} is #{times_slower}x slower than the fastest"
      end
    end
    puts
  end
end

puts 'Benchmarking with 10,000 elements:'
run_benchmark(10_000)

puts "\nBenchmarking with 100,000 elements:"
run_benchmark(100_000)
