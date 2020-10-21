defmodule StoreHelpers do

  def fetch_book_if_not_present(pid, key, store_func) do
    if !GenServer.call(pid, {:has_key, key}) do
      IO.inspect("READING FILE FROM S3")
      case get_book_contents(key) do
        {:ok, book } -> lines = String.split(book, "\n")
                                |> Stream.with_index()
                                |> Stream.map(fn({line, indx}) -> {indx, line} end)
                                |> Enum.to_list()
                        store_func.(pid, key, lines)
        {:error, _} -> IO.inspect("Error getting #{key}")
      end
    end
  end

  def get_book_contents(id) do
    base_url = System.get_env("S3_BUCKET", "https://skrupulus.s3.eu-west-2.amazonaws.com")
    url = "#{base_url}/#{id}.txt"
    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, body}
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        {:error, "Error"}
      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, "Error"}
    end

  end

end
