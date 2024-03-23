defmodule CypherSrdWeb.AbilityLive do
  use CypherSrdWeb, :live_view

  alias CypherSrd.SrdServer, as: SRD
  import CypherSrd.Util, only: [title_case: 1]
  # import CypherSrdWeb.RollTable

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_params(%{"ability" => ability}, _uri, socket) do
    socket =
      socket
      |> assign(:ability, SRD.get_srd(:abilities, ability))

    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
    <.header>
      <%= title_case(@ability.name) %>
    </.header>

    <div class="text-sm text-zinc-700">
      <p class="mt-4">
        <strong :if={@ability.cost_rendered != ""}>
          <%= @ability.cost_rendered %>:
        </strong>
        <%= @ability.description %>
      </p>
    </div>
    """
  end
end
