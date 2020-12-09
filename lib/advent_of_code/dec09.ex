# https://adventofcode.com/2020/day/9

defmodule AdventOfCode.Dec09 do
  ####################################################################
  ## p1
  ####################################################################
  def first(input) do
    input
    |> AdventOfCode.list_of_string_to_ints()
    |> find_encoding_error(25)
  end

  def find_encoding_error(list = [_head | tail], chunksize) do
    last = Enum.slice(list, 0..chunksize)
    num = Enum.at(list, chunksize + 1)

    if has_a_sum?(last, num) do
      find_encoding_error(tail, chunksize)
    else
      num
    end
  end

  def has_a_sum?(arr, sum) do
    # re-use some code :)
    AdventOfCode.Dec01.all_pairs([], arr)
    |> Enum.any?(fn {i, j} -> i + j == sum end)
  end

  ####################################################################
  ## p2
  ####################################################################
  def second(input) do
    input
    |> AdventOfCode.list_of_string_to_ints()
    |> find_weakness(first(input))
  end

  def find_weakness(nums = [_head | tail], sum) do
    case walk_list(nums, 0, [], sum) do
      {:ok, product} -> product
      {:notfound} -> find_weakness(tail, sum)
    end
  end

  # running-total is above our target, so it can't be right.
  def walk_list(_, total, _, target) when total > target, do: {:notfound}

  # found it!
  def walk_list(_, total, nums, target) when total == target do
    {:ok, Enum.min(nums) + Enum.max(nums)}
  end

  # keep on walkin'
  def walk_list([head | tail], total, nums, target) do
    walk_list(tail, total + head, [head | nums], target)
  end
end
