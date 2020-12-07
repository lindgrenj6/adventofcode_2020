# https://adventofcode.com/2020/day/7

defmodule AdventOfCode.Dec07 do
  ####################################################################
  ## p1
  ####################################################################
  def first(input) do
    parsed = parse(input)

    Enum.map(parsed, &can_contain_bag(&1, "shiny gold", parsed))
    |> Enum.count(&(&1 == true))
  end

  def parse(input) do
    input
    |> Enum.map(&String.split(&1, " contain "))
    |> Enum.map(fn [type, rules] -> {String.replace(type, " bags", ""), parse_rules(rules)} end)
    |> Map.new()
  end

  # This has a ugly regex. but it works I guess.
  def parse_rules(rules) do
    rules
    |> String.split(", ")
    |> Enum.map(&Regex.run(~r/^(\d+) (.*) (bag|bags)/, &1, capture: :all_but_first))
    |> Enum.reject(&is_nil(&1))
    |> Enum.map(fn [count, name, _] -> {name, String.to_integer(count)} end)
    |> Map.new()
  end

  def can_contain_bag({_name, value}, bag, mappings) when is_map(value) do
    value
    |> Enum.map(&can_contain_bag(&1, bag, mappings))
    |> Enum.any?()
  end

  # This bag can contain the bag we're searching for, coolio
  def can_contain_bag({bag, _}, bag, _), do: true

  def can_contain_bag({name, value}, bag, mappings) when is_integer(value) do
    mappings[name]
    |> Enum.map(&can_contain_bag(&1, bag, mappings))
    |> Enum.any?()
  end

  def can_contain_bag(_, _, _), do: false

  ####################################################################
  ## p2
  ####################################################################
  def second(input) do
    parsed = parse(input)
    how_many_bags(parsed["shiny gold"], parsed)
  end

  # recurse down the tree...
  def how_many_bags(bags, mappings) when is_map(bags) do
    bags
    |> Enum.map(fn {name, count} -> how_many_bags(mappings[name], mappings) * count + count end)
    |> Enum.sum()
  end

  # ...until we get to the end, where we just start at the top (if there are records for it)
  def how_many_bags({name, value}, mappings) do
    how_many_bags(mappings[name], mappings) * value + value
  end
end
