# frozen_string_literal: true

RSpec.describe 'custom classes' do
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

  let(:list) { BinarySearch::List.new }

  it 'works with custom classes' do
    list.push(Person.new('Alice', 20))
    list.push(Person.new('Bob', 30))
    list.push(Person.new('Charlie', 25))

    expect(list.to_a.map(&:name)).to eq(%w[Alice Charlie Bob])
    expect(list.to_a.map(&:age)).to eq([20, 25, 30])
  end
end
