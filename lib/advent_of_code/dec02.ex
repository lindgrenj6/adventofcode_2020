# https://adventofcode.com/2020/day/2

defmodule AdventOfCode.Dec02 do
  ####################################################################
  ## p1
  ####################################################################
  def first(input) do
    input
    |> Enum.map(&parse/1)
    |> Enum.count(&valid?/1)
  end

  def valid?([bottom, top, c, pass]) do
    charcount = pass |> String.codepoints() |> Enum.count(&(&1 == c))
    charcount >= String.to_integer(bottom) && charcount <= String.to_integer(top)
  end

  # I use this method in both since they need to be parsed the same way
  # just with different rules.
  def parse(line) do
    Regex.run(~r/(\d+)-(\d+) ([[:ascii:]]): ([[:alnum:]]+)/, line, capture: :all_but_first)
  end

  ####################################################################
  ## p2
  ####################################################################
  def second(input) do
    input
    |> Enum.map(&parse/1)
    |> Enum.count(&different_valid?/1)
  end

  def different_valid?([bottom, top, c, pass]) do
    1 ==
      pass
      |> String.codepoints()
      |> get_indices(String.to_integer(bottom), String.to_integer(top))
      |> Enum.count(&(&1 == c))
  end

  # Could probably do this more efficiently, but linked lists are not arrays
  # so I can't just get the values.
  def get_indices(arr, bottom, top) do
    [Enum.at(arr, bottom - 1), Enum.at(arr, top - 1)]
  end
end
