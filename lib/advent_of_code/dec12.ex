# https://adventofcode.com/2020/day/12

defmodule AdventOfCode.Dec12 do
  @parsemap %{
    "N" => :north,
    "S" => :south,
    "E" => :east,
    "W" => :west,
    "L" => :left,
    "R" => :right,
    "F" => :forward
  }
  @dirmap %{
    0 => :north,
    90 => :east,
    180 => :south,
    270 => :west
  }
  ####################################################################
  ## p1
  ####################################################################
  def first(input) do
    input
    |> AdventOfCode.pmap(&parse/1)
    |> sail(0, 0, 90)
    |> gib_ham()
  end

  def parse(line) do
    [cmd, val] = Regex.run(~r/^(\S)(\d+)$/, line, capture: :all_but_first)
    {@parsemap[cmd], String.to_integer(val)}
  end

  def sail([], x, y, _), do: [x, y]

  def sail([{cmd, val} | tail], x, y, dir) do
    case cmd do
      :north -> sail(tail, x, y + val, dir)
      :south -> sail(tail, x, y - val, dir)
      :east -> sail(tail, x + val, y, dir)
      :west -> sail(tail, x - val, y, dir)
      :forward -> sail([{@dirmap[dir], val} | tail], x, y, dir)
      _ -> sail(tail, x, y, turn(cmd, val, dir))
    end
  end

  def turn(cmd, val, dir) do
    case cmd do
      :left ->
        rem(abs(360 + dir - val), 360)

      :right ->
        rem(dir + val, 360)
    end
  end

  def gib_ham([x, y]) do
    abs(x) + abs(y)
  end

  ####################################################################
  ## p2
  ####################################################################
  def second(input) do
    input
    |> AdventOfCode.pmap(&parse/1)
    |> follow_waypoint(0, 0, {10, 1})
    |> gib_ham()
  end

  def follow_waypoint([], x, y, _), do: [x, y]

  def follow_waypoint([{:left, val} | tail], x, y, {wx, wy}) do
    {nwx, nwy} =
      case val do
        90 -> {wy * -1, wx}
        180 -> {wx * -1, wy * -1}
        270 -> {wy, wx * -1}
      end

    follow_waypoint(tail, x, y, {nwx, nwy})
  end

  def follow_waypoint([{:right, val} | tail], x, y, {wx, wy}) do
    {nwx, nwy} =
      case val do
        90 -> {wy, wx * -1}
        180 -> {wx * -1, wy * -1}
        270 -> {wy * -1, wx}
      end

    follow_waypoint(tail, x, y, {nwx, nwy})
  end

  def follow_waypoint([{cmd, val} | tail], x, y, {wx, wy}) do
    case cmd do
      :north -> follow_waypoint(tail, x, y, {wx, wy + val})
      :south -> follow_waypoint(tail, x, y, {wx, wy - val})
      :east -> follow_waypoint(tail, x, y, {wx + val, wy})
      :west -> follow_waypoint(tail, x, y, {wx - val, wy})
      :forward -> follow_waypoint(tail, x + val * wx, y + val * wy, {wx, wy})
    end
  end
end
