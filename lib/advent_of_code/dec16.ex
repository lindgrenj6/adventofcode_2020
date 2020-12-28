# https://adventofcode.com/2020/day/16

defmodule AdventOfCode.Dec16 do
  ####################################################################
  ## p1
  ####################################################################
  def first(input) do
    [rules, _ticket, surrounding] =
      input
      |> Enum.chunk_by(&(&1 == ""))
      |> Enum.reject(&(&1 == [""]))

    ranges(rules, [])
    |> find_outliers(Enum.slice(surrounding, 1..-1), [])
    |> Enum.sum()
  end

  def ranges([], ranges), do: MapSet.new(ranges)

  def ranges([rule | tail], ranges) do
    [b1, e1, b2, e2] =
      Regex.run(~r/: (\d+)-(\d+) or (\d+)-(\d+)/, rule, capture: :all_but_first)
      |> Enum.map(&String.to_integer/1)

    ranges(tail, ranges ++ Enum.into(b1..e1, []) ++ Enum.into(b2..e2, []))
  end

  def find_outliers(_, [], outliers), do: outliers

  def find_outliers(ranges, [line | tail], outliers) do
    out =
      String.split(line, ",")
      |> Enum.map(&String.to_integer/1)
      |> Enum.filter(&out_of_range(ranges, &1))

    find_outliers(ranges, tail, outliers ++ out)
  end

  def out_of_range(ranges, n) do
    !MapSet.member?(ranges, n)
  end

  ####################################################################
  ## p2 brute force, took hours and hours on my 3700x
  ####################################################################
  def second(input) do
    [rules, ticket, surrounding] =
      input
      |> Enum.chunk_by(&(&1 == ""))
      |> Enum.reject(&(&1 == [""]))

    parsed = rules |> Enum.reduce(%{}, &parse(&2, &1))

    good_tickets(surrounding, parsed)
    |> find_valid(parsed)
  end

  def parse(map, rule) do
    [name, b1, e1, b2, e2] =
      Regex.run(~r/^([[:ascii:]]+): (\d+)-(\d+) or (\d+)-(\d+)/, rule, capture: :all_but_first)
      |> Enum.map(&AdventOfCode.safe_convert_to_int/1)

    # setting the keys to the name, the val to all of the nums possible rather than the ranges.
    Map.put(map, String.to_atom(name), MapSet.new(Enum.into(b1..e1, []) ++ Enum.into(b2..e2, [])))
  end

  def good_ticket?(ticket, values), do: Enum.all?(ticket, &(&1 in values))

  def good_tickets(tickets, rules) do
    Enum.slice(tickets, 1..-1)
    |> Enum.map(&String.split(&1, ","))
    |> Enum.map(&AdventOfCode.list_of_string_to_ints/1)
    |> Enum.filter(&good_ticket?(&1, all_possible_values(rules)))
  end

  def all_possible_values(parsed) do
    Map.values(parsed)
    |> Enum.map(&MapSet.to_list/1)
    |> Enum.reduce(&Kernel.++/2)
    |> MapSet.new()
  end

  def find_valid(tickets, parsed) do
    LazyPermutations.permutations(Map.keys(parsed))
    |> Stream.chunk_every(100000)
    |> AdventOfCode.pmap(fn combos ->
      Enum.find(combos, fn combo ->
        if Enum.all?(tickets, fn ticket -> ticket_valid?(ticket, combo, parsed) end) do
          combo
        else
          nil
        end
      end)
    end)
    |> Enum.reject(&Kernel.is_nil/1)
    |> List.flatten()
  end

  def ticket_valid?(ticket, combo, rules) do
    Enum.zip(ticket, combo)
    |> Enum.all?(fn {n, field} ->
      n in rules[field]
    end)
  end
end
