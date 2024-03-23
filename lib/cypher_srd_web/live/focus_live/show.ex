defmodule CypherSrdWeb.FocusLive.Show do
  use CypherSrdWeb, :live_view

  alias CypherSrd.SrdServer, as: SRD
  import CypherSrd.Util, only: [title_case: 1]

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_params(%{"focus" => focus}, _uri, socket) do
    socket =
      socket
      |> assign(:focus, SRD.get_srd(:foci, focus))

    {:noreply, socket}
  end

  def group_abilities(%{abilities: abilities} = _focus) do
    abilities
    |> Enum.group_by(& &1.tier)
    |> Map.values()
  end

  def title([%{tier: tier} | _]) do
    "Tier #{tier}"
  end
end
