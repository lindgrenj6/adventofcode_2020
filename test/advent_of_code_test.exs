defmodule AdventOfCodeTest do
  use ExUnit.Case

  # I got sick of re-writing the same block over and over again.
  # why not let a macro write tests for me.
  defmacro aocautotest(file, tests) do
    quote do
      Enum.each(unquote(tests), fn {f, a} ->
        assert f.(AdventOfCode.read_file(unquote(file))) == a
      end)
    end
  end

  test "dec01" do
    aocautotest(
      "dec1.txt",
      [{&AdventOfCode.Dec01.first/1, 888_331}, {&AdventOfCode.Dec01.second/1, 130_933_530}]
    )
  end

  test "dec02" do
    aocautotest(
      "dec2.txt",
      [{&AdventOfCode.Dec02.first/1, 378}, {&AdventOfCode.Dec02.second/1, 280}]
    )
  end

  test "dec03" do
    aocautotest(
      "dec3.txt",
      [{&AdventOfCode.Dec03.first/1, 187}, {&AdventOfCode.Dec03.second/1, 4_723_283_400}]
    )
  end

  test "dec04" do
    test_string = AdventOfCode.raw_read_file("dec4.txt")
    p1 = AdventOfCode.Dec04.first(test_string)
    p2 = AdventOfCode.Dec04.second(test_string)

    assert p1 == 239
    assert p2 == 188
  end

  test "dec05" do
    aocautotest(
      "dec5.txt",
      [{&AdventOfCode.Dec05.first/1, 850}, {&AdventOfCode.Dec05.second/1, 599}]
    )
  end

  test "dec06" do
    test_string = AdventOfCode.raw_read_file("dec6.txt")
    p1 = AdventOfCode.Dec06.first(test_string)
    p2 = AdventOfCode.Dec06.second(test_string)

    assert p1 == 6680
    assert p2 == 3117
  end
end
