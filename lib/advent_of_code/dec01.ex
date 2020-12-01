# https://adventofcode.com/2020/day/1

defmodule AdventOfCode.Dec01 do
  ####################################################################
  ## p1
  ####################################################################
  def first([head | tail]) when is_binary(head) do
    first(AdventOfCode.list_of_string_to_ints([head | tail]))
  end

  def first([head | tail]) do
    case find_2020_pair(head, tail) do
      :eof ->
        first(tail)

      {x, y} ->
        x * y
    end
  end

  # Found the 2020!
  def find_2020_pair(num, [head | _tail]) when num + head == 2020 do
    {num, head}
  end

  # continue down the array....
  def find_2020_pair(num, [_head | tail]) do
    find_2020_pair(num, tail)
  end

  # no find, eof.
  def find_2020_pair(_, []), do: :eof

  ####################################################################
  ## p2
  ####################################################################
  def second([head | tail]) when is_binary(head) do
    second([], AdventOfCode.list_of_string_to_ints([head | tail]))
  end

  def second([head | tail]) do
    second([], [head | tail])
  end

  # seeding the all_pairs list
  def second([], list) do
    all_pairs([], list) |> second(list)
  end

  def second([{a, b} | tail], list) do
    case find_triple_2020({a, b}, list) do
      :eof ->
        second(tail, list)

      {x, y, z} ->
        x * y * z
    end
  end

  # Oh baby a triple
  def find_triple_2020({a, b}, [head | _]) when a + b + head == 2020 do
    {a, b, head}
  end

  def find_triple_2020({a, b}, [_head | tail]) do
    find_triple_2020({a, b}, tail)
  end
  def find_triple_2020(_, []), do: :eof

  # Collection of methods to get all the possible pairs from a list.
  def all_pairs(ps, [head | tail]) do
    all_pairs(ps ++ pairs(head, tail), tail)
  end
  def all_pairs(ps, []), do: ps

  def pairs(num, [head | tail]) do
    [{num, head} | pairs(num, tail)]
  end
  def pairs(_, []), do: []
end
