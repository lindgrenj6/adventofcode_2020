defmodule AdventOfCodeTest do
  use ExUnit.Case

  # I got sick of re-writing the same block over and over again.
  # why not let a macro write tests for me.
  defmacro aocautotest(input, tests) do
    quote do
      Enum.each(unquote(tests), fn {f, a} ->
        assert f.(unquote(input)) == a
      end)
    end
  end

  test "dec01" do
    aocautotest(
      AdventOfCode.read_file("dec1.txt"),
      [{&AdventOfCode.Dec01.first/1, 888_331}, {&AdventOfCode.Dec01.second/1, 130_933_530}]
    )
  end

  test "dec02" do
    aocautotest(
      AdventOfCode.read_file("dec2.txt"),
      [{&AdventOfCode.Dec02.first/1, 378}, {&AdventOfCode.Dec02.second/1, 280}]
    )
  end

  test "dec03" do
    aocautotest(
      AdventOfCode.read_file("dec3.txt"),
      [{&AdventOfCode.Dec03.first/1, 187}, {&AdventOfCode.Dec03.second/1, 4_723_283_400}]
    )
  end

  test "dec04" do
    aocautotest(
      AdventOfCode.raw_read_file("dec4.txt"),
      [{&AdventOfCode.Dec04.first/1, 239}, {&AdventOfCode.Dec04.second/1, 188}]
    )
  end

  test "dec05" do
    aocautotest(
      AdventOfCode.read_file("dec5.txt"),
      [{&AdventOfCode.Dec05.first/1, 850}, {&AdventOfCode.Dec05.second/1, 599}]
    )
  end

  test "dec06" do
    aocautotest(
      AdventOfCode.raw_read_file("dec6.txt"),
      [{&AdventOfCode.Dec06.first/1, 6680}, {&AdventOfCode.Dec06.second/1, 3117}]
    )
  end
end
