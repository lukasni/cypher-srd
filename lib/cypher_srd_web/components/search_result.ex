defmodule CypherSrdWeb.SearchResult do
  use CypherSrdWeb, :html

  def resultlist(assigns) do
    ~H"""
    <div class="mt-4">
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
    <.name_and_description
      name={@name}
      description={@effect}
      type="Cypher"
      type_class="text-sky-500"
    />
    """
  end

  # Equipment
  def item(assigns) when is_map_key(assigns, :variants) do
    ~H"""
    <.two_col>
      <:title>
        <div class="text-zinc-500"><%= title_case(@name) %></div>
        <div class="text-blue-500">Equipment</div>
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

  # Type, identified by the background key
  def item(assigns) when is_map_key(assigns, :background) do
    ~H"""
    <.two_col>
      <:title>
        <div class="text-zinc-500"><%= title_case(@name) %></div>
        <div class="text-emerald-500">Type</div>
      </:title>
      <:body>
        <.list>
          <:item :for={ability <- @abilities} title={ability.name}>
            <%= ability.description %>
          </:item>
        </.list>
      </:body>
    </.two_col>
    """
  end

  # Other, for now
  def item(assigns) do
    ~H"""
    <.two_col>
      <:title>
        <div class="text-zinc-500"><%= title_case(@name) %></div>
        <div class="text-orange-500">Other</div>
      </:title>
      <:body>
        <pre class="text-xs"><%= inspect(assigns, pretty: true) %></pre>
      </:body>
    </.two_col>
    """
  end

  def two_col(assigns) do
    ~H"""
    <div class="flex gap-4 py-4 text-sm leading-6 border-t sm:gap-8">
      <div class="flex-none w-1/4">
        <%= render_slot(@title) %>
      </div>
      <div class="text-zinc-700">
        <%= render_slot(@body) %>
      </div>
    </div>
    """
  end

  def name_and_description(assigns) do
    ~H"""
    <.two_col>
      <:title>
        <div class="text-zinc-500"><%= title_case(@name) %></div>
        <div class={@type_class}><%= @type %></div>
      </:title>
      <:body>
        <%= @description %>
      </:body>
    </.two_col>
    """
  end

  def title_case(string) do
    string
    |> String.split
    |> Enum.map(&String.capitalize/1)
    |> Enum.join(" ")
  end
end
