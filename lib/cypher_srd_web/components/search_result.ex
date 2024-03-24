defmodule CypherSrdWeb.SearchResult do
  use CypherSrdWeb, :html

  import CypherSrd.Util, only: [title_case: 1]

  def resultlist(assigns) do
    ~H"""
    <div class="mt-4" id="search-results" phx-hook="Mark">
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  # Ability, identified by the cost key
  def item(assigns) when is_map_key(assigns, :cost) do
    ~H"""
    <.name_and_description
      name={@name}
      description={@description}
      lead={@cost_rendered}
      type="Ability"
      type_class="text-rose-500"
      phx-click={JS.navigate(~p"/abilities/#{@name}/")}
    />
    """
  end

  # Descriptor, identified by :characteristics
  def item(assigns) when is_map_key(assigns, :characteristics) do
    ~H"""
    <.name_and_description
      name={@name}
      description={@description}
      type="Descriptor"
      type_class="text-emerald-500"
      phx-click={JS.navigate(~p"/descriptors/#{@name}/")}
    />
    """
  end

  # Type, identified by :background
  def item(assigns) when is_map_key(assigns, :background) do
    ~H"""
    <.name_and_description
      name={@name}
      description={@description}
      type="Type"
      type_class="text-emerald-500"
      phx-click={JS.navigate(~p"/types/#{@name}/")}
    />
    """
  end

  # Focus, identified by :connections
  def item(assigns) when is_map_key(assigns, :connections) do
    ~H"""
    <.name_and_description
      name={@name}
      description={@description}
      type="Focus"
      type_class="text-emerald-500"
      phx-click={JS.navigate(~p"/foci/#{@name}/")}
    />
    """
  end

  # Flavor, identified by :abilities
  def item(assigns) when is_map_key(assigns, :abilities) do
    ~H"""
    <.name_and_description
      name={@name}
      description={@description}
      type="Flavor"
      type_class="text-emerald-500"
    />
    """
  end

  # Artifact, identified by :depletion
  def item(assigns) when is_map_key(assigns, :depletion) do
    ~H"""
    <.name_and_description
      name={@name}
      description={@effect}
      type="Artifact"
      type_class="text-sky-500"
    />
    """
  end

  # Cypher, identified by :level_dice (but no :depletion)
  def item(assigns) when is_map_key(assigns, :level_dice) do
    ~H"""
    <.name_and_description name={@name} description={@effect} type="Cypher" type_class="text-sky-500" />
    """
  end

  # Creature, identified by :health
  def item(assigns) when is_map_key(assigns, :health) do
    ~H"""
    <.name_and_description
      name={@name}
      description={@description}
      type="Creature"
      type_class="text-lime-500"
      phx-click={JS.navigate(~p"/creatures/#{@name}/")}
    />
    """
  end

  # Equipment, identified by :variants
  def item(assigns) when is_map_key(assigns, :variants) do
    ~H"""
    <.two_col name={@name} type="Equipment">
      <:title>
        <div class="text-zinc-500"><%= title_case(@name) %></div>
        <div class="text-blue-500 mark-ignore">Equipment</div>
      </:title>
      <:body>
        <strong>Variants</strong>
        <p :for={variant <- @variants}>
          <%= variant.description %>
        </p>
      </:body>
    </.two_col>
    """
  end

  # Other, for now
  def item(assigns) do
    ~H"""
    <.two_col name={@name} type="Other">
      <:title>
        <div class="text-zinc-500"><%= title_case(@name) %></div>
        <div class="text-orange-500 mark-ignore">Other</div>
      </:title>
      <:body>
        <pre class="text-xs"><%= inspect(assigns, pretty: true) %></pre>
      </:body>
    </.two_col>
    """
  end

  attr :rest, :global
  slot :title, required: true
  slot :body, required: true
  attr :name, :string
  attr :type, :string

  def two_col(assigns) do
    ~H"""
    <div
      class="relative flex gap-4 p-4 text-sm leading-6 border-t sm:gap-8 hover:bg-zinc-100 bg-opacity-50"
      {@rest}
    >
      <div class="flex-none w-1/4">
        <%= render_slot(@title) %>
      </div>
      <div class="text-zinc-700">
        <%= render_slot(@body) %>
      </div>
      <button
        class="float-right h-6 w-6 flex items-center justify-center"
        phx-click={
          JS.remove_class("-translate-x-full", to: "#pinned-tray")
          |> JS.push("pin")
        }
        phx-value-name={@name}
        phx-value-type={String.downcase(@type)}
        phx-target="#pinned-tray"
      >
        <.icon name="hero-bookmark-solid" class="h-4 w-4" />
      </button>
    </div>
    """
  end

  attr :name, :string, required: true
  attr :type, :string, required: true
  attr :type_class, :string, required: true
  attr :description, :string, required: true
  attr :lead, :string, default: nil
  attr :rest, :global

  def name_and_description(assigns) do
    ~H"""
    <.two_col {@rest} type={@type} name={@name}>
      <:title>
        <div class="text-zinc-500">
          <%= title_case(@name) %>
        </div>
        <div class={["mark-ignore", @type_class]}><%= @type %></div>
      </:title>
      <:body>
        <strong :if={@lead && @lead != ""}><%= @lead %>:</strong>
        <%= @description %>
      </:body>
    </.two_col>
    """
  end
end
