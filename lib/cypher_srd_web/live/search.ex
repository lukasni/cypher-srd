defmodule CypherSrdWeb.SearchLive do
  use CypherSrdWeb, :live_view
  alias CypherSrd.Search
  alias CypherSrdWeb.SearchResult

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:search, nil)
      |> assign(:results, [])

    {:ok, socket}
  end

  def handle_event("search", %{"search" => search}, socket) do
    results =
      search
      |> Search.search()
      |> Enum.take(10)

    {:noreply, assign(socket, :results, results)}
  end

  def render(assigns) do
    ~H"""
    <.header>
      Omni Search
      <:subtitle>Search various objects by title</:subtitle>
    </.header>
    <form phx-change="search" class="mt-4">
      <.input type="text" name="search" value={@search} placeholder="Start typing..." />
    </form>
    <SearchResult.resultlist>
      <SearchResult.item :for={result <- @results} {result} />
    </SearchResult.resultlist>
    """
  end
end
