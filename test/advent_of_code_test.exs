defmodule AdventOfCodeTest do
  use ExUnit.Case

  test "dec01" do
    test_string = AdventOfCode.read_file("dec1.txt")
    p1 = AdventOfCode.Dec01.first(test_string)
    p2 = AdventOfCode.Dec01.second(test_string)

    assert p1 == 888331
    assert p2 == 130933530
  end
end
