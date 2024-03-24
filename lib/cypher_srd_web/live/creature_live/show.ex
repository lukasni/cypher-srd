defmodule CypherSrdWeb.CreatureLive.Show do
  use CypherSrdWeb, :live_view

  alias CypherSrd.SrdServer, as: SRD
  import CypherSrd.Util, only: [title_case: 1, printable: 1]

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_params(%{"creature" => creature}, _uri, socket) do
    socket =
      socket
      |> assign(:creature, SRD.get_srd(:creatures, creature))

    {:noreply, socket}
  end

  def sections() do
    [
      :motive,
      :environment,
      :health,
      :damage,
      :armor,
      :movement,
      :modifications,
      :combat,
      :interaction,
      :use,
      :intrusions
    ]
  end

  def show_section(%{armor: 0}, :armor), do: false
  def show_section(creature, section), do: printable(creature[section])

  def section_title(:damage) do
    "Damage Dealth"
  end

  def section_title(section) do
    section
    |> Atom.to_string()
    |> title_case()
  end
end
