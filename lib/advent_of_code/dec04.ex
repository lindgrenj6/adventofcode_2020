# https://adventofcode.com/2020/day/4

defmodule AdventOfCode.Dec04 do
  ####################################################################
  ## p1
  ####################################################################
  def first(input) do
    parse(input)
    |> Enum.map(&to_fields/1)
    |> Enum.map(&has_all_fields?/1)
    |> Enum.count(&(&1 == true))
  end

  # parses the passports into an array of arrays
  def parse(input) do
    input
    |> Enum.map(&String.split/1)
    |> Enum.chunk_by(&(&1 == []))
    |> Enum.map(&List.flatten/1)
    |> Enum.reject(&(&1 == []))
    |> Enum.map(&split_field/1)
  end

  def split_field(passport) do
    passport |> Enum.map(&String.split(&1, ":"))
  end

  def to_fields(passport) do
    passport |> Enum.map(&List.first/1)
  end

  def has_all_fields?(fields) do
    # Array of required fields, treating `cid` as optional.
    (~w(byr iyr eyr hgt hcl ecl pid) -- fields) |> Enum.empty?()
  end

  ####################################################################
  ## p2
  ####################################################################
  def second(input) do
    parse(input)
    |> Enum.filter(fn pp -> pp |> to_fields |> has_all_fields? end)
    |> Enum.map(&validate/1)
    |> Enum.count(&(&1 == true))
  end

  def validate(passport) do
    passport
    |> Enum.map(&validate_field/1)
    |> Enum.all?()
  end

  def validate_field([field, val]) do
    case field do
      "byr" -> num_within(val, 1920, 2002)
      "iyr" -> num_within(val, 2010, 2020)
      "eyr" -> num_within(val, 2020, 2030)
      "hgt" -> validate_height(val)
      "hcl" -> Regex.match?(~r/^#[a-f,0-9]{6}/, val)
      "ecl" -> ([val] -- ~w(amb blu brn gry grn hzl oth)) |> Enum.empty?()
      "pid" -> Regex.match?(~r/^[0-9]{9}$/, val)
      "cid" -> true
    end
  end

  def num_within(value, low, high) do
    num = String.to_integer(value)
    num in low..high
  end

  def validate_height(hgt) do
    [height, unit] = Regex.run(~r/(\d+)(in|cm|)/, hgt, capture: :all_but_first)

    case unit do
      "in" -> num_within(height, 59, 76)
      "cm" -> num_within(height, 150, 193)
      _ -> false
    end
  end
end
