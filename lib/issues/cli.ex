defmodule Issues.CLI do
  @default_count 4

  @moduledoc """
  Handle the command line parsing and the dispatch to the
  various functions that end up generating a table of the
  last _n_ issues in a github project
  """

  def run(args) do
    args
    |> parse_args
    |> process
  end

  def process(:help)  do
    IO.puts "usage: issues <user> <project> [ count | #{@default_count} ]"

    System.halt(0)
  end

  def process({user, project, _count}) do
    Issues.GithubIssues.fetch(user, project)
  end

  @doc """
  `args` can be -h or --help, which returns :help.
  Otherwise it is a github user name, project name, and (optionally)
  the number of entries to format.
  Return a tuple of `{ user, project, count }`, or `:help` if help was given.
  """
  def parse_args(args) do
    parse = OptionParser.parse(args,
      switches: [help: :boolean],
      aliases: [h: :help])

    case parse do
      {[help: true], _, _} -> :help
      {_, [user, project, count], _} -> {user, project, String.to_integer(count)}
      {_, [user, project], _} -> {user, project, @default_count}
    end
  end
end
