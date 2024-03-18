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
    GenServer.call(__MODULE__, {:get_srd, :version})
  end

  def get_srd() do
    GenServer.call(__MODULE__, :get_srd)
  end

  def get_srd(key) when key in @keys do
    GenServer.call(__MODULE__, {:get_srd, key})
  end

  def get_srd(key, name) do
    get_srd(key)
    |> Enum.find(fn item ->
      String.downcase(item.name) == String.downcase(name)
    end)
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

  def handle_call({:get_srd, key}, _from, state) do
    {:reply, state.srd[key], state}
  end

  defp load_active(state) do
    CypherSrd.Downloader.maybe_download(%{tag: "v0.2.1"})

    srd =
      CypherSrd.Downloader.active_path()
      |> File.read!()
      |> Jason.decode!(keys: :atoms)
      |> add_extra_data()

    Logger.info("Loading Cypher SRD version #{srd.version}")

    {:noreply, Map.put(state, :srd, srd)}
  end

  defp add_extra_data(srd) do
    extra_data =
      :code.priv_dir(:cypher_srd)
      |> Path.join("srd/extra_data.json")
      |> File.read!()
      |> Jason.decode!(keys: :atoms)

    srd_version = srd.version

    case extra_data.version do
      ^srd_version ->
        Logger.info("Extra Data version matches SRD version")

      _other ->
        Logger.warning(
          "Extra Data / SRD version mismatch! SRD: #{srd.version}, ED: #{extra_data.version}"
        )
    end

    merge_types(srd, extra_data)
  end

  defp merge_types(srd, extra_data) do
    types =
      srd.types
      |> Enum.map(fn type ->
        extra_data
        |> Map.get(:types)
        |> Enum.find(&(&1.name == type.name))
        |> Map.merge(type)
      end)

    %{srd | types: types}
  end
end
