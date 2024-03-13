defmodule CypherSrdWeb.AbilitiesLive do
  use CypherSrdWeb, :live_view
  alias CypherSrd.Search

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:search, nil)
      |> assign(:results, [])

    {:ok, socket}
  end

  def handle_event("search", %{"search" => search}, socket) do
    results =
      :abilities
      |> Search.search(search)
      |> Enum.take(10)

    {:noreply, assign(socket, :results, results)}
  end

  def render(assigns) do
    ~H"""
    <.header>
      Ability Search
      <:subtitle>Search abilities by title</:subtitle>
    </.header>
    <form phx-change="search" class="mt-4">
      <.input type="text" name="search" value={@search} placeholder="Start typing..." />
    </form>
    <.list>
      <:item :for={result <- @results} title={result[:name]}>
        <%= result[:description] || result[:effect] %>
      </:item>
    </.list>
    """
  end
end
