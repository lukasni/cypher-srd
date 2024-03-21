defmodule CypherSrdWeb.TypeLive do
  use CypherSrdWeb, :live_view

  alias CypherSrd.SrdServer, as: SRD
  import CypherSrd.Util, only: [title_case: 1]
  import CypherSrdWeb.RollTable

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_params(%{"type" => type}, _uri, socket) do
    socket =
      socket
      |> assign(:type, SRD.get_srd(:types, type))

    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
    <.header>
      <%= title_case(@type.name) %>
    </.header>

    <div class="text-sm text-zinc-700">
      <p><%= @type.description %></p>

      <div :for={{role, description} <- @type.roles}>
        <p class="mt-2">
          <strong class="font-semibold">
            <%= role |> Atom.to_string() |> String.capitalize() %> Role:
          </strong>
          <%= description %>
        </p>
      </div>

      <p class="mt-2">
        <strong class="font-semibold">
          Advanced <%= [String.capitalize(@type.name), "s: "] %>
        </strong>
        <%= @type.advanced %>
      </p>
    </div>

    <h2 class="mt-4">Starting Abilities</h2>
    <.list>
      <:item :for={a <- @type.abilities} title={a.name}>
        <%= a.description %>
      </:item>
    </.list>

    <h2 class="mt-4">Sample Intrusions</h2>
    <.list>
      <:item :for={i <- @type.intrusions} title={i.name}>
        <%= i.description %>
      </:item>
    </.list>

    <h2 class="mt-4"><%= @type.name |> String.capitalize() %> Background Connection</h2>
    <.roll_table id="background-table" table={@type.background.table} />

    <div :for={tier <- @type.special_abilities_per_tier}>
      <h2 class="mt-4">
        <%= "Tier #{tier.tier} #{title_case(@type.name)}" %>
      </h2>
      <p>Choose <%= tier.special_abilities %></p>
      <ul>
        <li :for={ability <- aft(@type, tier.tier)}>
          <%= ability.name %>
        </li>
      </ul>
    </div>
    """
  end

  def aft(type, tier) do
    type.special_abilities
    |> Enum.filter(&(&1.tier == tier))
  end
end
