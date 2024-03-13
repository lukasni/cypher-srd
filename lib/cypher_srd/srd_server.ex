defmodule CypherSrd.SrdServer do
  use GenServer

  require Logger

  defstruct srd: %{}

  @keys [
    :abilities,
    :artifacts,
    :creatures,
    :cypher_tables,
    :cyphers,
    :descriptors,
    :equipment,
    :flavors,
    :foci,
    :intrusion_tables,
    :other_tables,
    :types,
    :version
  ]

  # Client Interface

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def version() do
    GenServer.call(__MODULE__, :get_version)
  end

  def get_srd() do
    GenServer.call(__MODULE__, :get_srd)
  end

  def get_srd(key) when key in @keys do
    get_srd()
    |> Map.get(key)
  end

  def search_list() do
    srd = get_srd()

    srd.abilities ++
      srd.artifacts ++
      srd.creatures ++
      srd.cyphers ++
      srd.descriptors ++
      srd.equipment ++
      srd.flavors ++
      srd.foci ++
      srd.types
  end

  def reload() do
    GenServer.cast(__MODULE__, :reload)
  end

  # Server Callbacks
  def init(_) do
    {:ok, %__MODULE__{}, {:continue, :load_srd}}
  end

  def handle_continue(:load_srd, state) do
    load_active(state)
  end

  def handle_cast(:reload, state) do
    load_active(state)
  end

  def handle_call(:get_srd, _from, state) do
    {:reply, state.srd, state}
  end

  def handle_call(:get_version, _from, state) do
    {:reply, state.srd.version, state}
  end

  # Helpers

  defp load_active(state) do
    CypherSrd.Downloader.maybe_download(%{tag: "v0.2.1"})

    srd =
      CypherSrd.Downloader.active_path()
      |> File.read!()
      |> Jason.decode!(keys: :atoms)

    Logger.info("Loading Cypher SRD version #{srd.version}")

    {:noreply, Map.put(state, :srd, srd)}
  end
end
