defmodule CypherSrdWeb.DescriptorLive.Show do
  use CypherSrdWeb, :live_view

  alias CypherSrd.SrdServer, as: SRD
  import CypherSrd.Util, only: [title_case: 1]

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_params(%{"descriptor" => descriptor}, _uri, socket) do
    socket =
      socket
      |> assign(:descriptor, SRD.get_srd(:descriptors, descriptor))

    {:noreply, socket}
  end
end
