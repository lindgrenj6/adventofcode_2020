# https://adventofcode.com/2020/day/16

defmodule AdventOfCode.Dec16 do
  ####################################################################
  ## p1
  ####################################################################
  def first(input) do
    [rules, _ticket, surrounding] =
      input
      |> Enum.chunk_by(&(&1 == ""))
      |> Enum.reject(&(&1 == [""]))

    ranges(rules, [])
    |> find_outliers(Enum.slice(surrounding, 1..-1), [])
    |> Enum.sum()
  end

  def ranges([], ranges), do: ranges

  def ranges([rule | tail], ranges) do
    [b1, e1, b2, e2] =
      Regex.run(~r/: (\d+)-(\d+) or (\d+)-(\d+)/, rule, capture: :all_but_first)
      |> Enum.map(&String.to_integer/1)

    ranges(tail, ranges ++ [b1..e1, b2..e2])
  end

  def find_outliers(_, [], outliers), do: outliers

  def find_outliers(ranges, [line | tail], outliers) do
    out =
      String.split(line, ",")
      |> Enum.map(&String.to_integer/1)
      |> Enum.filter(&out_of_range(ranges, &1))

    find_outliers(ranges, tail, outliers ++ out)
  end

  def out_of_range(ranges, n) do
    Enum.all?(ranges, &(n not in &1))
  end

  ####################################################################
  ## p2
  ####################################################################
  def second(input) do
    [rules, ticket, surrounding] =
      input
      |> Enum.chunk_by(&(&1 == ""))
      |> Enum.reject(&(&1 == [""]))

    rules
    |> Enum.reduce(%{}, &parse(&2, &1))
  end

  def parse(map, rule) do
    [name, b1, e1, b2, e2] =
      Regex.run(~r/^([[:alpha:]]+): (\d+)-(\d+) or (\d+)-(\d+)/, rule, capture: :all_but_first)
      |> Enum.map(&AdventOfCode.safe_convert_to_int/1)

    # setting the keys to the name, the val to all of the nums possible rather than the ranges.
    Map.put(map, String.to_atom(name), Enum.into(b1..e1, []) ++ Enum.into(b2..e2, []))
  end
end
