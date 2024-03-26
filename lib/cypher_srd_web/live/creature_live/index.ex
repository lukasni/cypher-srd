defmodule CypherSrdWeb.CreatureLive.Index do
  use CypherSrdWeb, :live_view

  alias CypherSrd.SrdServer, as: SRD
  import CypherSrd.Util, only: [title_case: 1]

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:kinds, ["NPC", "Creature", "Super Villain"])
      |> assign(:levels, 1..10)
      |> assign(:filter, %{})

    {:ok, socket}
  end

  def handle_params(params, _uri, socket) do
    filters = normalize_params(params)

    result =
      :creatures
      |> SRD.get_srd()
      |> maybe_filter_levels(filters)
      |> maybe_filter_kind(filters)
      |> Enum.group_by(& &1.kind)

    socket =
      socket
      |> assign(:filter, filters)
      |> assign(:by_kind, result)

    {:noreply, socket}
  end

  def handle_event("filter", params, socket) do
    filter = normalize_params(params)

    {:noreply, push_patch(socket, to: ~p"/creatures/?#{filter}")}
  end

  def handle_event("clear-filter", _params, socket) do
    {:noreply, push_patch(socket, to: ~p"/creatures/")}
  end

  defp normalize_params(params) do
    %{
      level:
        case Integer.parse(params["level"] || "") do
          {val, _rest} ->
            val

          _ ->
            nil
        end,
      kind: params["kind"]
    }
  end

  defp maybe_filter_levels(creatures, %{level: level}) when level not in ["", nil] do
    creatures
    |> Enum.filter(&(&1.level == level))
    |> dbg()
  end

  defp maybe_filter_levels(creatures, _filters), do: creatures

  defp maybe_filter_kind(creatures, %{kind: kind}) when kind not in ["", nil] do
    creatures
    |> Enum.filter(&(&1.kind == kind))
    |> dbg()
  end

  defp maybe_filter_kind(creatures, _filters), do: creatures
end
