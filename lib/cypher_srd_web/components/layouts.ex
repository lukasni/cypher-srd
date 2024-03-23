defmodule CypherSrdWeb.Layouts do
  use CypherSrdWeb, :html

  embed_templates "layouts/*"

  def toggle_tray() do
    %JS{}
    |> JS.toggle_class("-translate-x-full", to: "#pinned-tray")
  end
end
