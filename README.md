# BinarySearch 🌳🔍

Welcome to BinarySearch, a gem that brings the power of Red-Black Trees to your Ruby projects! 🚀

## What is BinarySearch? 🤔

BinarySearch is a Ruby gem that implements a self-balancing binary search tree using the Red-Black Tree algorithm. It provides a list-like interface with blazing-fast search, insertion, and deletion operations. 💨

## Why BinarySearch? 🌟

- **Efficiency**: Operations like search, insert, and delete are O(log n), making it much faster than standard arrays for large datasets. 📈
- **Self-balancing**: The Red-Black Tree ensures that the tree remains balanced, maintaining consistent performance even with frequent modifications. ⚖️
- **Sorted storage**: Elements are always stored in sorted order, making it perfect for applications that require sorted data. 📊
- **Flexible**: Supports common list operations like push, pop, shift, and unshift, as well as set operations like union and intersection. 🛠️

## Installation 💻

Add this line to your application's Gemfile:

```ruby
gem 'binary_search'
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