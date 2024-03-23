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

      <h2 class="mt-6 font-bold">Starting Abilities</h2>
      <.list>
        <:item :for={a <- @type.abilities} title={a.name}>
          <%= a.description %>
        </:item>
      </.list>

      <div class="mt-4 md:flex flex-row flex-wrap">
        <div :for={tier <- @type.special_abilities_per_tier} class="md:basis-1/2 lg:basis-1/3">
          <h2 class="mt-4 font-bold">
            <%= "Tier #{tier.tier} #{title_case(@type.name)}" %>
          </h2>
          <p :if={tier.tier == 1}>
            Choose <%= tier.special_abilities %> of the abilities listed below
            In addition, you gain all of the <%= title_case(@type.name) %> starting abilities
          </p>
          <p :if={tier.tier > 1}>
            Choose <%= tier.special_abilities %> of the abilities listed below
            (or from a lower tier). Optionally, you can replace one of your
            lower-tier abilities with a different one from a lower tier.
          </p>
          <ul class="mt-2">
            <li
              :for={ability <- aft(@type, tier.tier)}
              phx-click={
                JS.remove_class("-translate-x-full", to: "#pinned-tray")
                |> JS.push("pin")
              }
              phx-target="#pinned-tray"
              phx-value-name={ability.name}
              phx-value-type="ability"
            >
              <%= ability.name %>
            </li>
          </ul>
        </div>
      </div>

      <h2 class="mt-6 font-bold">Sample Intrusions</h2>
      <.list>
        <:item :for={i <- @type.intrusions} title={i.name}>
          <%= i.description %>
        </:item>
      </.list>

      <h2 class="mt-6 font-bold"><%= @type.name |> String.capitalize() %> Background Connection</h2>
      <.roll_table id="background-table" table={@type.background.table} />
    </div>
    """
  end

  def aft(type, tier) do
    type.special_abilities
    |> Enum.filter(&(&1.tier == tier))
  end
end
