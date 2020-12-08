# https://adventofcode.com/2020/day/8

defmodule AdventOfCode.Dec08 do
  ####################################################################
  ## p1
  ####################################################################
  def first(input) do
    run(input, 0, 0, [])
  end

  # completion!
  def run(instructions, acc, pc, _) when pc >= length(instructions) do
    {:fin, acc}
  end

  def run(instructions, acc, pc, history) do
    # return the acc if this instruction has already been executed
    # wish I could use a guard clause for this,
    # but the array has to be available at compile-time
    if pc in history do
      acc
    else
      {opcode, arg} = parse(Enum.at(instructions, pc))

      case opcode do
        "nop" -> run(instructions, acc, pc + 1, [pc | history])
        "acc" -> run(instructions, acc + arg, pc + 1, [pc | history])
        "jmp" -> run(instructions, acc, pc + arg, [pc | history])
      end
    end
  end

  def parse(instruction) do
    [op, arg] = String.split(instruction)
    {op, String.to_integer(arg)}
  end

  ####################################################################
  ## p2
  ####################################################################
  def second(input) do
    find_corruption(input, input, 0)
  end

  def find_corruption(instructions, [head|tail], index) do
    if Regex.match?(~r/^jmp/, head) do
      # Basically going through and trying replacing every jmp with nop
      # until it runs to completion. Brute force baby!
      case run(List.replace_at(instructions, index, "nop +0"), 0, 0, []) do
        {:fin, acc} -> acc
        _ -> find_corruption(instructions, tail, index + 1)
      end
    else
      find_corruption(instructions, tail, index + 1)
    end
  end
end
