defmodule StoreHelpers do

  def fetch_book_if_not_present(key, store_func) do
    if is_nil(:persistent_term.get(key, nil)) do
      IO.inspect("READING FILE #{key} FROM S3")
      case get_book_contents(key) do
        {:ok, book } -> lines = String.split(book, "\n")
                                |> Stream.with_index()
                                |> Stream.map(fn({line, indx}) -> {indx, line} end)
                                |> Enum.to_list()
                        store_func.(key, lines)
        {:error, msg} -> IO.inspect("Error getting #{key} #{msg}")
      end
    end
    :persistent_term.get(key, [])
  end

  def get_book_contents(id) do
    base_url = System.get_env("S3_BUCKET", "https://skrupulus.s3.eu-west-2.amazonaws.com")
    url = "#{base_url}/#{id}.txt"
    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, body}
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        {:error, "404 Error"}
      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, "#{reason}"}
    end

  end

end
