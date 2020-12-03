# https://adventofcode.com/2020/day/3

defmodule AdventOfCode.Dec03 do
  ####################################################################
  ## p1
  ####################################################################
  def first(input) do
    # changing the lines to an array of arrays rather than an array of strings.
    mountain = Enum.map(input, &String.codepoints/1)

    toboggan_run(
      0, # starting with 0 trees
      3, # right 3
      1, # down 1
      length(List.first(mountain)), # length of line
      mountain,# actual map
      1, # run
      3  # rise
    )
  end

  def toboggan_run(count, _, y, _, mountain, _, _) when y >= length(mountain) do
    # tail recursion go
    count
  end

  def toboggan_run(count, x, y, mwidth, mountain, rise, run) do
    level = Enum.at(mountain, y)

    case Enum.at(level, rem(x, mwidth)) do
      "#" -> toboggan_run(count + 1, x + run, y + rise, mwidth, mountain, rise, run)
      "." -> toboggan_run(count, x + run, y + rise, mwidth, mountain, rise, run)
    end
  end

  ####################################################################
  ## p2
  ####################################################################
  def second(input) do
    mountain = Enum.map(input, &String.codepoints/1)

    slopes = [[1, 1], [3, 1], [5, 1], [7, 1], [1, 2]]

    slopes
    |> Enum.map(fn [x, y] -> toboggan_run(0, x, y, length(List.first(mountain)), mountain, y, x) end)
    |> Enum.reduce(&(&1 * &2))
  end
end
