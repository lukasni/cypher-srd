defmodule CypherSrdWeb.CreatureLive.Index do
  use CypherSrdWeb, :live_view
  
  alias CypherSrd.SrdServer, as: SRD
  import CypherSrd.Util, only: [title_case: 1]

  def mount(_params, _session, socket) do
    creatures = SRD.get_srd(:creatures)
    
    {:ok, assign(socket, :creatures, creatures)}
  end

  def render(assigns) do
    ~H"""
    <.header>
      Creatures
    </.header>

    <.list>
      <:item 
        :for={creature <- @creatures} 
        title={title_case(creature.name)} 
        click={fn -> JS.navigate(~p"/creatures/#{creature.name}") end}
      >
        <p>Level <%= creature.level %> <%= creature.kind %></p>
        <p class="line-clamp-4">
          <%= creature.description %>
        </p>
      </:item>
    </.list>
    """
  end
end
