# frozen_string_literal: true

require 'benchmark'
require 'ruby_binary_search'
require 'numo/narray'

def run_benchmark(n)
  array = []
  binary_search = BinarySearch::List.new
  narray = Numo::Int32.new(n).seq

  results = {}

  Benchmark.bm(20) do |x|
    # Insertion
    results[:array_insert] = x.report('Array insert:') do
      n.times { |i| array << i }
    end

    results[:binary_insert] = x.report('BinarySearch insert:') do
      n.times { |i| binary_search.insert(i) }
    end

    results[:narray_insert] = x.report('NArray insert:') do
      Numo::Int32.new(n).seq
    end

    # Search
    results[:array_search] = x.report('Array search:') do
      n.times { |i| array.include?(i) }
    end

    results[:binary_search] = x.report('BinarySearch search:') do
      n.times { |i| binary_search.include?(i) }
    end

    results[:narray_search] = x.report('NArray search:') do
      n.times { |i| narray.eq(i).any? }
    end

    # Deletion
    results[:array_delete] = x.report('Array delete:') do
      n.times { |i| array.delete(i) }
    end

    results[:binary_delete] = x.report('BinarySearch delete:') do
      n.times { |i| binary_search.delete(i) }
    end

    results[:narray_delete] = x.report('NArray delete:') do
      temp_narray = narray.copy
      n.times do |i|
        mask = temp_narray.ne(i)
        temp_narray = temp_narray[mask]
      end
    end
  end

  print_comparison(results)
end

def print_comparison(results)
  operations = [
    ['Insertion', :array_insert, :binary_insert, :narray_insert],
    ['Search', :array_search, :binary_search, :narray_search],
    ['Deletion', :array_delete, :binary_delete, :narray_delete]
  ]

  operations.each do |op, *keys|
    puts "#{op}:"
    times = keys.map { |k| results[k].real }
    fastest = times.min
    keys.zip(times).each do |key, time|
      name = key.to_s.split('_').first.capitalize
      if time == fastest
        puts "  #{name} is the fastest"
      else
        times_slower = (time / fastest).round(2)
        puts "  #{name} is #{times_slower}x slower than the fastest"
      end
    end
  end
end

puts 'Benchmarking with 10,000 elements:'
run_benchmark(10_000)

puts "\nBenchmarking with 100,000 elements:"
run_benchmark(100_000)
