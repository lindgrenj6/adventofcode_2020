# https://adventofcode.com/2020/day/5

defmodule AdventOfCode.Dec05 do
  ####################################################################
  ## p1 23min
  ####################################################################
  def first(input) do
    input
    |> Enum.map(&parse/1)
    |> Enum.map(&to_coordinates/1)
    |> Enum.map(&to_id/1)
    |> Enum.max()
  end

  def parse(line) do
    Regex.run(~r/([[:alpha:]]{7})([[:alpha:]]{3})/, line, capture: :all_but_first)
    |> Enum.map(&String.codepoints/1)
    # true = F, L; false = B,R
    |> Enum.map(fn arr -> Enum.map(arr, &(&1 in ~w(F L))) end)
  end

  def to_coordinates([fb, lr]) do
    row = find(Enum.into(0..127, []), fb)
    col = find(Enum.into(0..7, []), lr)
    {row, col}
  end

  def to_id({row, col}), do: row * 8 + col

  # recursive binary search go!
  def find([s1, _s2], [true]), do: s1
  def find([_s1, s2], [false]), do: s2

  def find(list, [true | tail]) do
    next_search = Enum.chunk_every(list, div(length(list), 2)) |> List.first()
    find(next_search, tail)
  end

  def find(list, [false | tail]) do
    next_search = Enum.chunk_every(list, div(length(list), 2)) |> List.last()
    find(next_search, tail)
  end

  ####################################################################
  ## p2 45min -- spent time parsing into map, but then realized
  ##             the ids are sequential
  ####################################################################
  def second(input) do
    input
    |> Enum.map(&parse/1)
    |> Enum.map(&to_coordinates/1)
    |> Enum.map(&to_id/1)
    |> find_missing_id()
  end

  def find_missing_id(ids) do
    # Make a list of all the possible values and subtract the ids to get the missing one!
    (Enum.to_list(List.first(ids)..List.last(ids)) -- ids)
    |> List.first()
  end
end
