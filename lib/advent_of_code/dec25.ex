# https://adventofcode.com/2020/day/25

defmodule AdventOfCode.Dec25 do
  ####################################################################
  ## p1
  ####################################################################
  def first(input) do
    [cardkey, doorkey] = Enum.map(input, &String.to_integer/1)
    [_cardloop, doorloop] = Enum.map([cardkey, doorkey], &find_loop_size/1)

    get_encryption_key(cardkey, cardkey, doorloop)
  end

  def find_loop_size(key) do
    find_loop_size(key, 1, 0)
  end

  # found it!
  def find_loop_size(key, key, count), do: count

  def find_loop_size(key, val, count) do
    find_loop_size(key, transform(val), count + 1)
  end

  def transform(k, s \\ 7) do
    rem(s * k, 20_201_227)
  end

  def get_encryption_key(_subject, val, 1), do: val

  def get_encryption_key(subject, val, count) do
    get_encryption_key(subject, transform(val, subject), count - 1)
  end
end
