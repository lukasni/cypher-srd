defmodule CypherSrd.Repo do
  use Ecto.Repo,
    otp_app: :cypher_srd,
    adapter: Ecto.Adapters.Postgres
end
