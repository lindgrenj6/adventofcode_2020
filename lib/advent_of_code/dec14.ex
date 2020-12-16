# https://adventofcode.com/2020/day/14

defmodule AdventOfCode.Dec14 do
  ####################################################################
  ## p1
  ####################################################################
  def first(input) do
    input
    |> Enum.map(&parse/1)
    |> Enum.reduce(%{}, &process(&2, &1))
    |> count_memory()
  end

  def parse(line) do
    [var, arg] = String.split(line, " = ")

    if var == "mask" do
      {:mask, String.codepoints(arg)}
    else
      [loc] = Regex.run(~r/mem\[(\d+)\]/, var, capture: :all_but_first)
      {String.to_integer(loc), convert_to_binary(arg)}
    end
  end

  def convert_to_binary(arg) do
    String.to_integer(arg)
    |> Integer.to_string(2)
    |> String.pad_leading(36, "0")
    |> String.codepoints()
  end

  def process(memory, {loc, val}) do
    if loc == :mask do
      Map.put(memory, :mask, val)
    else
      Map.put(memory, loc, mask(memory[:mask], val, []))
    end
  end

  def mask([], [], val), do: Enum.reverse(val)

  def mask(["X" | mt], [vh | vt], masked) do
    mask(mt, vt, [vh | masked])
  end

  def mask([mh | mt], [_vh | vt], masked) do
    mask(mt, vt, [mh | masked])
  end

  def count_memory(map) do
    Map.keys(map)
    |> Enum.filter(&is_integer(&1))
    |> Enum.map(&to_string(map[&1]))
    |> Enum.map(&String.to_integer(&1, 2))
    |> Enum.sum()
  end

  ####################################################################
  ## p2
  ####################################################################
  def second(input) do
  end
end
