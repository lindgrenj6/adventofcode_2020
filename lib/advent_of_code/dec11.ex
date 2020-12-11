# https://adventofcode.com/2020/day/11

defmodule AdventOfCode.Dec11 do
  ####################################################################
  ## p1
  ####################################################################
  def first(input) do
    input
    |> Enum.map(&String.codepoints/1)
    |> run(true)
  end

  def run(grid, true) do
    {newgrid, changed} =
      grid
      |> Enum.with_index()
      |> AdventOfCode.pmap(&run_row(&1, grid))
      |> Enum.reduce({[], false}, fn {rchanged, row}, {rows, changed} ->
        {[row | rows], rchanged || changed}
      end)

    run(Enum.reverse(newgrid), changed)
  end

  def run(grid, false) do
    List.flatten(grid) |> Enum.count(&(&1 == "#"))
  end

  def run_row({row, index}, grid) do
    new_row =
      row
      |> Enum.with_index()
      |> Enum.map(&move(&1, index, grid))

    {length(row -- new_row) > 0, new_row}
  end

  def move({".", _}, _, _), do: "."

  def move({"L", index}, rindex, grid) do
    adj = checks(index, rindex)

    case check(adj, 0, grid) == 0 do
      true -> "#"
      false -> "L"
    end
  end

  def move({"#", index}, rindex, grid) do
    adj = checks(index, rindex)

    case check(adj, 0, grid) >= 4 do
      true -> "L"
      false -> "#"
    end
  end

  # base case, at the end.
  def check([], count, _), do: count

  def check([{row, col} | tail], count, grid) do
    case occupado(grid, row, col) do
      true -> check(tail, count + 1, grid)
      false -> check(tail, count, grid)
    end
  end

  def checks(index, rindex) do
    [
      {rindex - 1, index - 1},
      {rindex - 1, index},
      {rindex - 1, index + 1},
      {rindex + 1, index - 1},
      {rindex + 1, index},
      {rindex + 1, index + 1},
      {rindex, index + 1},
      {rindex, index - 1}
    ]
  end

  def occupado(grid, row, col) do
    at(grid, row, col) == "#"
  end

  def at(grid, row, col) do
    # could memoize these eventually. meh
    maxrow = length(grid)
    maxcol = List.first(grid) |> length()

    if row >= maxrow || col >= maxcol || (row < 0 || col < 0) do
      false
    else
      Enum.at(grid, row) |> Enum.at(col)
    end
  end

  ####################################################################
  ## p2
  ####################################################################
  @dirs %{
    l: {0, -1},
    r: {0, 1},
    u: {1, 0},
    d: {-1, 0},
    ul: {1, -1},
    ur: {1, 1},
    dl: {-1, -1},
    dr: {-1, 1}
  }

  def second(input) do
    input
    |> Enum.map(&String.codepoints/1)
    |> search(true)
  end

  def search(grid, true) do
    {newgrid, changed} =
      grid
      |> Enum.with_index()
      |> AdventOfCode.pmap(&search_row(&1, grid))
      |> Enum.reduce({[], false}, fn {rchanged, row}, {rows, changed} ->
        {[row | rows], rchanged || changed}
      end)

    search(Enum.reverse(newgrid), changed)
  end

  def search(grid, false), do: List.flatten(grid) |> Enum.count(&(&1 == "#"))

  def search_row({row, index}, grid) do
    new_row =
      row
      |> Enum.with_index()
      |> Enum.map(&look(&1, index, grid))

    {length(row -- new_row) > 0, new_row}
  end

  def look({".", _}, _, _), do: "."

  def look({sym, index}, rindex, grid) do
    view = first_spots(rindex, index, grid)
    flip?(sym, view)
  end

  def flip?("#", view) do
    case Enum.count(view, &(&1 == "#")) >= 5 do
      true -> "L"
      _ -> "#"
    end
  end

  def flip?("L", view) do
    case Enum.count(view, &(&1 == "#")) do
      0 -> "#"
      _ -> "L"
    end
  end

  def first_spots(row, col, grid) do
    Map.values(@dirs)
    |> Enum.map(fn deltas ->
      look_in_direction(row, col, grid, deltas)
    end)
  end

  def look_in_direction(row, col, grid, {rowd, cold}) do
    case at(grid, row + rowd, col + cold) do
      "." -> look_in_direction(row + rowd, col + cold, grid, {rowd, cold})
      "L" -> "L"
      "#" -> "#"
      _ -> nil
    end
  end
end
