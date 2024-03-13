defmodule CypherSrd.Downloader do
  require Logger

  def maybe_download(opts) do
    case File.stat(active_path()) do
      {:ok, _info} ->
        :ok

      {:error, _info} ->
        download_and_save(opts)
        activate(opts.tag)
    end
  end

  def download_and_save(opts) do
    opts
    |> download()
    |> save(opts)
  end

  def download(opts) do
    Logger.info("Downloading Cypher SRD version #{opts.tag}")

    opts
    |> download_url()
    |> get(CypherSrd.Finch)
    |> then(fn {:ok, %Finch.Response{status: 200, body: body}} -> body end)
  end

  defp download_url(%{tag: tag}) do
    "https://github.com/Jon-Davis/Cypher-System-JSON-DB/raw/#{tag}/CSRD.json"
  end

  def decode!({:ok, %Finch.Response{status: 200, body: body}}, _opts) do
    body
    |> Jason.decode!(keys: :atoms)
  end

  def decode!(response, _opts), do: {:error, response}

  def save(json, opts) do
    path =
      Path.join([
        srd_dir(),
        "CSRD_" <> opts.tag <> ".json"
      ])

    Logger.info("Saving Cypher SRD to #{path}")

    path
    |> ensure_path_exists()
    |> File.write(json)
  end

  def activate(version) do
    src = path(version)
    dst = active_path()
    Logger.info("Creating symlink #{dst} -> #{src}")
    File.ln_s!(path(version), active_path())
  end

  def srd_dir do
    :code.priv_dir(:cypher_srd)
    |> Path.join("srd")
  end

  def active_path do
    Path.join(srd_dir(), "active.json")
  end

  def path(version) do
    Path.join(srd_dir(), filename(version))
  end

  defp filename(version) do
    "CSRD_" <> version <> ".json"
  end

  defp ensure_path_exists(path) do
    # Ensure directory exists
    path
    |> Path.dirname()
    |> File.mkdir_p!()

    path
  end

  defp get(url, name, depth \\ 30)
  defp get(:undefined, _, _), do: {:error, :bad_redirect}
  defp get(_url, _name, 0), do: {:error, :too_many_redirects}

  defp get(url, name, depth) do
    :get
    |> Finch.build(url)
    |> Finch.request(name)
    |> case do
      {:ok, %Finch.Response{status: 302, headers: headers}} ->
        "location"
        |> :proplists.get_value(headers)
        |> get(name, depth - 1)

      other ->
        other
    end
  end
end
