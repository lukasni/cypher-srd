defmodule CypherSrdWeb.DescriptorLive do
  use CypherSrdWeb, :live_view

  alias CypherSrd.SrdServer, as: SRD
  import CypherSrd.Util, only: [title_case: 1]

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_params(%{"descriptor" => descriptor}, _uri, socket) do
    socket =
      socket
      |> assign(:descriptor, SRD.get_srd(:descriptors, descriptor))

    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
    <.header>
      <%= title_case(@descriptor.name) %>
    </.header>

    <div class="text-sm text-zinc-700">
      <p><%= @descriptor.description %></p>

      <h2 class="mt-4">Characteristics</h2>
      <.list>
        <:item :for={item <- @descriptor.characteristics} title={item.name}>
          <%= item.description %>
        </:item>
      </.list>
    </div>
    """
  end
end
