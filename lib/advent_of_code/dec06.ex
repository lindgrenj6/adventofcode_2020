# https://adventofcode.com/2020/day/6

defmodule AdventOfCode.Dec06 do
  ####################################################################
  ## p1
  ####################################################################
  def first(input) do
    input
    |> parse()
    |> Enum.map(&List.flatten/1)
    |> Enum.map(&(Enum.uniq(&1) |> Enum.count()))
    |> Enum.sum()
  end

  def parse(input) do
    input
    |> Enum.chunk_by(&(&1 == ""))
    |> Enum.map(&List.flatten/1)
    |> Enum.reject(&(&1 == [""]))
    |> Enum.map(&AdventOfCode.map_to_codepoints(&1))
  end

  ####################################################################
  ## p2
  ####################################################################
  def second(input) do
    input
    |> parse()
    |> Enum.map(&count_all(&1))
    |> Enum.sum()
  end

  # only one person in that row! Lucky guy!
  def count_all([head]), do: Enum.count(head)
  def count_all([head | tail]) do
    head
    |> Enum.filter(&all_answered_yes?(&1, tail))
    |> Enum.count()
  end

  def all_answered_yes?(answer, others) do
    Enum.all?(others, &(answer in &1))
  end
end
