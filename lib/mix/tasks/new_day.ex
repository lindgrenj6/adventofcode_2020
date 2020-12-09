defmodule Mix.Tasks.NewDay do
  use Mix.Task

  @shortdoc "Creates a new template from boilerplate for AoC" # (also just an exercise in creating a custom mixi task)
  def run([day|_tail]) do
    path = "lib/advent_of_code/#{day}.ex"

    templ = """
    # https://adventofcode.com/2020/day/CHANGEME

    defmodule AdventOfCode.#{String.capitalize(day)} do
      ####################################################################
      ## p1
      ####################################################################
      def first(input) do
      end

      ####################################################################
      ## p2
      ####################################################################
      def second(input) do
      end
    end
    """

    IO.puts(File.write(Path.relative(path), templ))
  end
end
