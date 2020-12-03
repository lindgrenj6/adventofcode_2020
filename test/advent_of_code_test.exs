defmodule AdventOfCodeTest do
  use ExUnit.Case

  test "dec01" do
    test_string = AdventOfCode.read_file("dec1.txt")
    p1 = AdventOfCode.Dec01.first(test_string)
    p2 = AdventOfCode.Dec01.second(test_string)

    assert p1 == 888_331
    assert p2 == 130_933_530
  end

  test "dec02" do
    test_string = AdventOfCode.read_file("dec2.txt")
    p1 = AdventOfCode.Dec02.first(test_string)
    p2 = AdventOfCode.Dec02.second(test_string)

    assert p1 == 378
    assert p2 == 280
  end

  test "dec03" do
    test_string = AdventOfCode.read_file("dec3.txt")
    p1 = AdventOfCode.Dec03.first(test_string)
    p2 = AdventOfCode.Dec03.second(test_string)

    assert p1 == 187
    assert p2 == 4723283400
  end
end
