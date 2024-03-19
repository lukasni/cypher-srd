defmodule CypherSrdWeb.RollTable do
  use CypherSrdWeb, :html

  attr :id, :string, required: true
  attr :table, :map, required: true

  attr :description, :string, default: nil

  def roll_table(assigns) do
    assigns =
      assign(assigns, :dice_range, dice_range(assigns.table))

    ~H"""
    <div>
      <.table id={@id} rows={@table}>
        <:col :let={entry} label={@dice_range}>
          <%= entry_dice(entry) %>
        </:col>
        <:col :let={entry} label="">
          <%= entry.entry %>
        </:col>
      </.table>
      <p :if={@description}>
        <%= @description %>
      </p>
    </div>
    """
  end

  def dice_range(table) do
    # min = Enum.min_by(table, &(&1.start))
    max = Enum.max_by(table, & &1.end)

    "d#{max.end}"
  end

  def entry_dice(%{start: r_start, end: r_end}) when r_start == r_end, do: "#{r_start}"

  def entry_dice(%{start: r_start, end: r_end}) do
    "#{r_start}–#{r_end}"
  end
end
