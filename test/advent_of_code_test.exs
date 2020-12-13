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

  test "dec07" do
    aocautotest(
      AdventOfCode.read_file("dec7.txt"),
      [{&AdventOfCode.Dec07.first/1, 224}, {&AdventOfCode.Dec07.second/1, 1488}]
    )
  end

  test "dec08" do
    aocautotest(
      AdventOfCode.read_file("dec8.txt"),
      [{&AdventOfCode.Dec08.first/1, 1594}, {&AdventOfCode.Dec08.second/1, 758}]
    )
  end

  test "dec09" do
    aocautotest(
      AdventOfCode.read_file("dec9.txt"),
      [{&AdventOfCode.Dec09.first/1, 258585477}, {&AdventOfCode.Dec09.second/1, 36981213}]
    )
  end

  test "dec10" do
    aocautotest(
      AdventOfCode.read_file("dec10.txt"),
      [{&AdventOfCode.Dec10.first/1, 2376}, {&AdventOfCode.Dec10.second/1, 129586085429248}]
    )
  end

  test "dec11" do
    aocautotest(
      AdventOfCode.read_file("dec11.txt"),
      [{&AdventOfCode.Dec11.first/1, 2453}, {&AdventOfCode.Dec11.second/1, 2159}]
    )
  end

  test "dec12" do
    aocautotest(
      AdventOfCode.read_file("dec12.txt"),
      [{&AdventOfCode.Dec12.first/1, 1482}, {&AdventOfCode.Dec12.second/1, 48739}]
    )
  end

  test "dec13" do
    aocautotest(
      AdventOfCode.read_file("dec13.txt"),
      [{&AdventOfCode.Dec13.first/1, 259}]#, {&AdventOfCode.Dec12.second/1, 48739}]
    )
  end
end
