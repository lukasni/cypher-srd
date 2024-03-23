defmodule CypherSrdWeb.TrayComponent do
  use CypherSrdWeb, :live_component

  alias CypherSrd.SrdServer, as: SRD

  def render(assigns) do
    ~H"""
    <div
      id="pinned-tray"
      class={[
        "fixed top-20 z-40 h-[calc(100vh-5rem)] p-4 overflow-y-auto bg-zinc-100 ",
        "w-full md:w-96",
        "transition-transform transform -translate-x-full ease-in-out duration-300"
      ]}
      phx-hook="StorePins"
      phx-target={@myself}
    >
      <div :for={item <- @pinned_items} class="text-sm" phx-click={link_for(item)}>
        <h5 class="font-semibold flex justify-between">
          <%= CypherSrd.Util.title_case(item.name) %>
          <button
            phx-click="unpin"
            phx-target={@myself}
            phx-value-name={item.name}
            phx-value-type={item.type}
          >
            <.icon name="hero-bookmark-slash-solid" class="h-4" />
          </button>
        </h5>
        <.variants :if={item[:variants]} variants={item[:variants]} />
        <p if={item[:description] || item[:effect]} class=" inline-block overflow-y-auto mt-2">
          <strong :if={item[:cost_rendered] && item[:cost_rendered] != ""}>
            <%= item.cost_rendered %>:
          </strong>
          <%= item[:description] || item[:effect] %>
        </p>
        <hr class="my-2" />
      </div>
    </div>
    """
  end

  def handle_event("pin", params, socket) do
    item = get_item(params)

    socket =
      socket.assigns.pinned_items
      |> Enum.reject(&(&1.name == item.name && &1.type == item.type))
      |> then(&[item | &1])
      |> then(&assign(socket, :pinned_items, &1))

    {:noreply, push_event(socket, "store-pins", storable_pins(socket))}
  end

  def handle_event("unpin", %{"name" => name, "type" => type}, socket) do
    socket =
      socket.assigns.pinned_items
      |> Enum.reject(&(&1.name == name && &1.type == type))
      |> then(&assign(socket, :pinned_items, &1))

    {:noreply, push_event(socket, "store-pins", storable_pins(socket))}
  end

  def handle_event("restore-pins", %{"pins" => pins}, socket) do
    socket =
      pins
      |> Enum.map(&get_item/1)
      |> then(&assign(socket, :pinned_items, &1))

    {:noreply, socket}
  end

  defp variants(assigns) do
    ~H"""
    <p :for={v when v != nil <- @variants}>
      <%= v.description %>
    </p>
    """
  end

  defp get_item(%{"name" => name, "type" => type}) do
    type
    |> String.downcase()
    |> String.to_existing_atom()
    |> SRD.get_srd(name)
    |> Map.put(:type, type)
  end

  defp storable_pins(socket) do
    socket.assigns.pinned_items
    |> Enum.map(&%{name: &1.name, type: &1.type})
    |> then(&%{pins: &1})
  end

  defp link_for(%{type: type, name: name}) do
    case type do
      "descriptor" ->
        JS.navigate(~p"/descriptors/#{name}")

      "type" ->
        JS.navigate(~p"/types/#{name}")

      "ability" ->
        JS.navigate(~p"/abilities/#{name}")

      "focus" ->
        JS.navigate(~p"/foci/#{name}")

      "creature" ->
        JS.navigate(~p"/creatures/#{name}")

      _ ->
        nil
    end
  end
end
