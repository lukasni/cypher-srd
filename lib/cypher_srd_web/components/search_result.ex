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
      type="Ability"
      type_class="text-rose-500"
      phx-click={JS.navigate(~p"/abilities/#{@name}/")}
    />
    """
  end

  # Descriptor
  def item(assigns) when is_map_key(assigns, :characteristics) do
    ~H"""
    <.name_and_description
      name={@name}
      description={@description}
      type="Descriptor"
      type_class="text-emerald-500"
    />
    """
  end

  # Type
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

  # Focus
  def item(assigns) when is_map_key(assigns, :connections) do
    ~H"""
    <.name_and_description
      name={@name}
      description={@description}
      type="Focus"
      type_class="text-emerald-500"
    />
    """
  end

  # Artifact
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

  # Cypher
  def item(assigns) when is_map_key(assigns, :level_dice) do
    ~H"""
    <.name_and_description name={@name} description={@effect} type="Cypher" type_class="text-sky-500" />
    """
  end

  # Equipment
  def item(assigns) when is_map_key(assigns, :variants) do
    ~H"""
    <.two_col>
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

  # Creature
  def item(assigns) when is_map_key(assigns, :health) do
    ~H"""
    <.name_and_description
      name={@name}
      description={@description}
      type="Creature"
      type_class="text-lime-500"
    />
    """
  end

  # Other, for now
  def item(assigns) do
    ~H"""
    <.two_col>
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

  def two_col(assigns) do
    ~H"""
    <div
      class="relative flex gap-4 p-4 text-sm leading-6 border-t sm:gap-8 hover:bg-zinc-300 bg-opacity-50"
      {@rest}
    >
      <div class="flex-none w-1/4">
        <%= render_slot(@title) %>
      </div>
      <div class="text-zinc-700">
        <%= render_slot(@body) %>
      </div>
      <.icon name="hero-bookmark-solid" class="h-4 w-4 absolute top-2 right-2" />
    </div>
    """
  end

  attr :name, :string, required: true
  attr :type, :string, required: true
  attr :type_class, :string, required: true
  attr :description, :string, required: true
  attr :rest, :global

  def name_and_description(assigns) do
    ~H"""
    <.two_col {@rest}>
      <:title>
        <div class="text-zinc-500">
          <%= title_case(@name) %>
        </div>
        <div class={["mark-ignore", @type_class]}><%= @type %></div>
      </:title>
      <:body>
        <%= @description %>
      </:body>
    </.two_col>
    """
  end
end
