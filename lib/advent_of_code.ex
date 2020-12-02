defmodule AdventOfCode do
  def read_file(file) do
    File.read!("./input/#{file}") |> String.split("\n") |> Enum.reject(&(&1 == ""))
  end

  def list_of_string_to_ints(list) do
    Enum.map(list, &String.to_integer/1)
  end
end
