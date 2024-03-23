defmodule CypherSrdWeb.FocusLive.Index do
  use CypherSrdWeb, :live_view

  alias CypherSrd.SrdServer, as: SRD
  import CypherSrd.Util, only: [title_case: 1]

  def mount(_params, _session, socket) do
    foci = SRD.get_srd(:foci)

    {:ok, assign(socket, :foci, foci)}
  end

  def render(assigns) do
    ~H"""
    <.header>
      Foci
    </.header>

    <.list>
      <:item
        :for={focus <- @foci}
        title={title_case(focus.name)}
        click={fn -> JS.navigate(~p"/foci/#{focus.name}/") end}
      >
        <%= focus.description %>
      </:item>
    </.list>
    """
  end
end
