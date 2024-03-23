defmodule CypherSrd.Util do
  def title_case(string) do
    string
    |> String.split()
    |> Enum.map(&String.capitalize/1)
    |> Enum.join(" ")
  end

  def printable(thing) do
    case thing do
      "" ->
        false

      nil ->
        false

      [] ->
        false

      %{} ->
        false

      _other ->
        true
    end
  end
end
