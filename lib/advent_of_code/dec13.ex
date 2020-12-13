# https://adventofcode.com/2020/day/13

defmodule AdventOfCode.Dec13 do
  ####################################################################
  ## p1
  ####################################################################
  def first(input) do
    start = List.first(input) |> String.to_integer()

    schedule =
      String.split(List.last(input), ",")
      |> Enum.reject(&(&1 == "x"))
      |> AdventOfCode.list_of_string_to_ints()

    hurry_up_and_wait(start, 0, schedule)
  end

  def hurry_up_and_wait(minute, count, schedule) do
    if bus = Enum.find(schedule, &(rem(minute, &1) == 0)) do
      count * bus
    else
      hurry_up_and_wait(minute + 1, count + 1, schedule)
    end
  end

  ####################################################################
  ## p2 brute force impl, works for test data but not the real data.
  ##    will come back later when I have time to implment CRD.
  ####################################################################
  def second(input) do
    start = List.first(input) |> String.to_integer()

    schedule =
      String.split(List.last(input), ",")
      |> Enum.map(&AdventOfCode.safe_convert_to_int/1)

    bus1 = bus_search(start, [List.first(schedule)])
    bus_search(bus1, schedule)
  end

  def bus_search(start, schedule) do
    step = max(length(schedule) - 1, 1)

    Stream.iterate(start, &(&1 + step))
    |> Enum.find(&schedule_match?(&1, schedule))
  end

  # successful match!
  def schedule_match?(_, []), do: true

  # skip over the x's
  def schedule_match?(start, ["x" | tail]) do
    schedule_match?(start + 1, tail)
  end

  # not successful match :(
  def schedule_match?(start, [head | _tail]) when rem(start, head) != 0 do
    false
  end

  # continuing, since the match continued.
  def schedule_match?(start, [_head | tail]) do
    schedule_match?(start + 1, tail)
  end
end
