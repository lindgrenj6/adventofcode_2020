defmodule AdventOfCode do
  def testfile(), do: read_file("tinput.txt")

  def read_file(file) do
    File.read!("./input/#{file}") |> String.split("\n") |> Enum.reject(&(&1 == ""))
  end

  # Need this function for fields that have records delimited by blank lines.
  def raw_read_file(file) do
    File.read!("./input/#{file}") |> String.split("\n")
  end

  def list_of_string_to_ints(list) do
    Enum.map(list, &String.to_integer/1)
  end

  def map_to_codepoints(line), do: Enum.map(line, &String.codepoints/1)

  # Shamelessly stolen: https://stackoverflow.com/a/29674651
  def benchmark(function) do
    function
    |> :timer.tc
    |> elem(0)
    |> Kernel./(1_000_000)
  end

  def pmap(collection, func) do
    collection
    |> Enum.map(&(Task.async(fn -> func.(&1) end)))
    |> Enum.map(&Task.await/1)
  end
end
