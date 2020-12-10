# https://adventofcode.com/2020/day/10

defmodule AdventOfCode.Dec10 do
  ####################################################################
  ## p1
  ####################################################################
  def first(input) do
    input
    |> AdventOfCode.list_of_string_to_ints()
    |> Enum.sort()
    |> partition(0, {0, 0})
    |> Enum.reduce(&(&1 * &2))
  end

  def partition([], _, {ones, threes}), do: [ones, threes + 1]

  def partition([head | tail], last, {ones, threes}) do
    case head - last do
      1 -> partition(tail, head, {ones + 1, threes})
      3 -> partition(tail, head, {ones, threes + 1})
    end
  end

  ####################################################################
  ## p2
  ####################################################################
  def second(input) do
    list =
      input
      |> AdventOfCode.list_of_string_to_ints()
      |> Enum.sort()
      |> List.insert_at(0, 0)
      |> Enum.reverse()

    count_possible_paths(list, parse(list, %{}), :ets.new(:set, [:public]))
  end

  def parse([], map), do: map
  def parse([head | tail], map) do
    parse(tail, Map.put_new(map, head, Enum.filter(tail, &(head - &1 <= 3))))
  end

  # 1 element left, made it to the end.
  def count_possible_paths([_], _, _), do: 1
  def count_possible_paths([head | tail], mappings, pid) do
    Map.get(mappings, head)
    |> Enum.filter(&(&1 in tail))
    |> Enum.map(fn x ->
      case :ets.lookup(pid, x) do
        [] ->
          rest = Enum.slice(tail, Enum.find_index(tail, &(&1 == x))..-1)
          count = count_possible_paths(rest, mappings, pid)

          :ets.insert(pid, {x, count})
          count

        [{_, val}] ->
          val
      end
    end)
    |> Enum.sum()
  end
end
