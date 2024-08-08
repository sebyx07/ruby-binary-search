# BinarySearch 🌳🔍

Welcome to BinarySearch, a gem that brings the power of Red-Black Trees to your Ruby projects! 🚀

## What is BinarySearch? 🤔

BinarySearch is a Ruby gem that implements a self-balancing binary search tree using the Red-Black Tree algorithm. It provides a list-like interface with blazing-fast search, insertion, and deletion operations. 💨

## Why BinarySearch? 🌟

- **Efficiency**: Operations like search, insert, and delete are O(log n), making it much faster than standard arrays for large datasets. 📈
- **Self-balancing**: The Red-Black Tree ensures that the tree remains balanced, maintaining consistent performance even with frequent modifications. ⚖️
- **Sorted storage**: Elements are always stored in sorted order, making it perfect for applications that require sorted data. 📊
- **Flexible**: Supports common list operations like push, pop, shift, and unshift, as well as set operations like union and intersection. 🛠️

## Benchmark results:
```bash
ruby 3.3.3 (2024-06-12 revision f1c7b6f435) +YJIT [x86_64-linux]
Benchmarking with 10,000 elements:
                                     user     system      total        real
Array#<< (append):               0.000318   0.000083   0.000401 (  0.000398)
BinarySearch GEM#insert:         0.012594   0.000000   0.012594 (  0.012609)
Numo::NArray.new + .seq:         0.000042   0.000000   0.000042 (  0.000042)
SortedSet#add:                   0.008358   0.001024   0.009382 (  0.009516)
Array#include?:                  0.150862   0.000000   0.150862 (  0.150930)
BinarySearch GEM#include?:       0.001820   0.000000   0.001820 (  0.001821)
Numo::NArray#eq + .any?:         0.215213   0.000000   0.215213 (  0.215412)
Array#bsearch (std lib):         0.004166   0.000000   0.004166 (  0.004166)
Array#delete:                    0.471802   0.000000   0.471802 (  0.471888)
BinarySearch GEM#delete:         0.007105   0.000991   0.008096 (  0.008099)
Numo::NArray delete (mask):      0.363630   0.039971   0.403601 (  0.403405)
SortedSet#delete:                0.008109   0.000005   0.008114 (  0.008119)
Insertion:
  Array#<< (append): is 9.55x slower than the fastest
  BinarySearch GEM#insert: is 302.16x slower than the fastest
  Numo::NArray.new + .seq: is the fastest
  SortedSet#add: is 228.03x slower than the fastest

Search:
  Array#include?: is 82.9x slower than the fastest
  BinarySearch GEM#include?: is the fastest
  Numo::NArray#eq + .any?: is 118.32x slower than the fastest
  Array#bsearch (std lib): is 2.29x slower than the fastest

Deletion:
  Array#delete: is 58.26x slower than the fastest
  BinarySearch GEM#delete: is the fastest
  Numo::NArray delete (mask): is 49.81x slower than the fastest
  SortedSet#delete: is 1.0x slower than the fastest


Benchmarking with 100,000 elements:
                                     user     system      total        real
Array#<< (append):               0.003539   0.000022   0.003561 (  0.003571)
BinarySearch GEM#insert:         0.085730   0.004032   0.089762 (  0.089782)
Numo::NArray.new + .seq:         0.000109   0.000004   0.000113 (  0.000095)
SortedSet#add:                   0.060403   0.000000   0.060403 (  0.060411)
Array#include?:                 16.131343   0.002956  16.134299 ( 16.133787)
BinarySearch GEM#include?:       0.013607   0.000002   0.013609 (  0.013611)
Numo::NArray#eq + .any?:        18.948453   0.007996  18.956449 ( 18.957555)
Array#bsearch (std lib):         0.048986   0.000000   0.048986 (  0.048997)
Array#delete:                   47.501618   0.001000  47.502618 ( 47.508824)
BinarySearch GEM#delete:         0.043180   0.000001   0.043181 (  0.043194)
Numo::NArray delete (mask):     29.937312   2.154682  32.091994 ( 32.080060)
SortedSet#delete:                0.100403   0.000000   0.100403 (  0.100697)
Insertion:
  Array#<< (append): is 37.69x slower than the fastest
  BinarySearch GEM#insert: is 947.56x slower than the fastest
  Numo::NArray.new + .seq: is the fastest
  SortedSet#add: is 637.58x slower than the fastest

Search:
  Array#include?: is 1185.37x slower than the fastest
  BinarySearch GEM#include?: is the fastest
  Numo::NArray#eq + .any?: is 1392.84x slower than the fastest
  Array#bsearch (std lib): is 3.6x slower than the fastest

Deletion:
  Array#delete: is 1099.89x slower than the fastest
  BinarySearch GEM#delete: is the fastest
  Numo::NArray delete (mask): is 742.7x slower than the fastest
  SortedSet#delete: is 2.33x slower than the fastest
```

## Installation 💻

Add this line to your application's Gemfile:

```ruby
gem 'ruby_binary_search'
```

And then execute:
```bash
bundle install
```

## Usage 🚀
Here's a quick example of how to use BinarySearch:

```ruby
require 'ruby_binary_search'

# Create a new list
list = BinarySearch::List.new([3, 1, 4, 1, 5, 9, 2, 6, 5, 3, 5])

# Get the sorted array
puts list.to_a  # Output: [1, 1, 2, 3, 3, 4, 5, 5, 5, 6, 9]

# Check if a value exists
puts list.include?(4)  # Output: true

# Remove all instances of a value
list.delete(1)
puts list.to_a  # Output: [2, 3, 3, 4, 5, 5, 5, 6, 9]

# Add a new value
list.insert(7)
puts list.to_a  # Output: [2, 3, 3, 4, 5, 5, 5, 6, 7, 9]

# Get the minimum and maximum values
puts list.min  # Output: 2
puts list.max  # Output: 9
```
Custom objects
```ruby
require 'ruby_binary_search'

class Person
  attr_accessor :name, :age

  def initialize(name, age)
    @name = name
    @age = age
  end

  def <=>(other)
    @age <=> other.age
  end
end


list = BinarySearch::List.new([
  Person.new('Alice', 25),
  Person.new('Bob', 30),
  Person.new('Charlie', 20),
  Person.new('David', 35)
])

puts list.to_a.map(&:name)  # Output: ["Charlie", "Alice", "Bob", "David"]
```

## Why is BinarySearch better than normal search? 🏆

- Speed: For large datasets, binary search is significantly faster than linear search. While a normal array search takes O(n) time, BinarySearch takes only O(log n) time. 🐇
- Always sorted: The list is always maintained in sorted order, which is useful for many applications and algorithms. 📑
- Efficient insertions and deletions: Unlike normal arrays where insertions and deletions can be O(n) operations, BinarySearch performs these in O(log n) time. 🔄
- Memory efficiency: Red-Black Trees are more memory-efficient than hash tables for certain types of data and operations. 💾
- Range queries: BinarySearch makes it easy to perform range queries efficiently, which can be cumbersome with normal arrays. 🎯

## Development 🛠️

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.
To install this gem onto your local machine, run `bundle exec rake install`.

## Contributing 🤝

Bug reports and pull requests are welcome on GitHub at https://github.com/sebyx07/binary_search. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the code of conduct.

## License 📄
The gem is available as open source under the terms of the MIT License.

## Code of Conduct 🤓
Everyone interacting in the BinarySearch project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the code of conduct.