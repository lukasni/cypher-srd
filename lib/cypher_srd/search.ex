defmodule CypherSrd.Search do
  import Seqfuzz, only: [filter: 3]

  alias CypherSrd.SrdServer, as: SRD

  def search(type, search) do
    SRD.get_srd(type)
    |> filter(search, & &1[:name])
  end

  def search(search) do
    SRD.search_list()
    |> filter(search, & &1[:name])
  end
end
