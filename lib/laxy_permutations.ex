# https://gist.github.com/tallakt/61ef5873721a28c4f7e1
defmodule LazyPermutations do
  def permutations(list) do
    list
    |> Enum.sort()
    |> Stream.unfold(fn
      [] -> nil
      p -> {p, next_permutation(p)}
    end)
  end

  defp next_permutation(permutation) do
    if permutation == permutation |> Enum.sort() |> Enum.reverse() do
      []
    else
      permutation
      |> split
      |> heal
    end
  end

  defp split(permutation) do
    permutation
    |> Enum.reverse()
    |> Enum.reduce({0, false, [], []}, fn x, {prev, split, first, last} ->
      case split do
        false -> {x, x < prev, first, [x | last]}
        true -> {x, true, [x | first], last}
      end
    end)
    |> (fn {_, _, first, last} -> {first, last} end).()
  end

  defp heal({first, [h | _] = last}) do
    next = last |> Enum.filter(&(&1 > h)) |> Enum.min()
    rest = (last -- [next]) |> Enum.sort()
    first ++ [next] ++ rest
  end
end
