defmodule AdventOfCode do
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
end
