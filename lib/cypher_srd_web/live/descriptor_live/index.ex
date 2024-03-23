defmodule CypherSrdWeb.DescriptorLive.Index do
  use CypherSrdWeb, :live_view

  alias CypherSrd.SrdServer, as: SRD
  import CypherSrd.Util, only: [title_case: 1]

  def mount(_params, _session, socket) do
    descriptors = SRD.get_srd(:descriptors)

    {:ok, assign(socket, :descriptors, descriptors)}
  end

  def render(assigns) do
    ~H"""
    <.list>
      <:item
        :for={d <- @descriptors}
        title={title_case(d.name)}
        click={fn -> JS.navigate(~p"/descriptors/#{d.name}/") end}
      >
        <%= d.description %>
      </:item>
    </.list>
    """
  end
end
