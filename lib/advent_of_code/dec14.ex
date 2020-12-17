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
  ## p2 works on the test data, but not the real data. Bummer.
  ####################################################################
  def second(input) do
    parsed =
      input
      |> Enum.map(&parse/1)
      |> Enum.with_index()
      |> Enum.reduce(%{}, &process_v2(&2, &1))
      |> Enum.with_index()
      |> Enum.map(&parse_quantum_memlocs(&1))
      |> Enum.sort_by(fn {x, _, _} -> x end)
      |> Enum.reduce(%{}, &set_memory(&2, &1))

    require IEx
    IEx.pry()

    parsed
    |> Map.values()
    |> Enum.sum()
  end

  def process_v2(memory, {{loc, val}, idx}) do
    if loc == :mask do
      Map.put(memory, :mask, val)
    else
      Map.put(
        memory,
        idx,
        {val, mask_v2(memory[:mask], convert_to_binary(Integer.to_string(loc)), [])}
      )
    end
  end

  def mask_v2([], [], val), do: Enum.reverse(val)
  def mask_v2(["0" | mt], [vh | vt], masked), do: mask_v2(mt, vt, [vh | masked])
  def mask_v2(["1" | mt], [_vh | vt], masked), do: mask_v2(mt, vt, ["1" | masked])
  def mask_v2(["X" | mt], [_vh | vt], masked), do: mask_v2(mt, vt, ["X" | masked])

  def parse_quantum_memlocs({{:mask, _}, idx}), do: {idx, nil, nil}

  def parse_quantum_memlocs({{_, {val, memmask}}, idx}) do
    count = Enum.count(memmask, &(&1 == "X"))

    {
      idx,
      to_string(val)
      |> String.to_integer(2),
      bit_mapping(count)
      |> Enum.map(&quantum_locs(&1, memmask))
    }
  end

  def quantum_locs(quantum_bits, bits) do
    Enum.reduce(quantum_bits, bits, fn bit, bits ->
      index = Enum.find_index(bits, &(&1 == "X"))

      List.replace_at(bits, index, bit)
    end)
    |> to_string()
    |> String.to_integer(2)
  end

  def bit_mapping(count) do
    0..((:math.pow(2, count) - 1) |> floor())
    |> Enum.map(&Integer.to_string(&1, 2))
    |> Enum.map(&String.pad_leading(&1, count, "0"))
    |> Enum.map(&String.codepoints/1)
  end

  # for the :mask memory location
  def set_memory(m, {_, nil, nil}), do: m

  def set_memory(mem, {_, value, locs}) do
    Enum.reduce(locs, mem, fn loc, mem ->
      Map.put(mem, loc, value)
    end)
  end
end
