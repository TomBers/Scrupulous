defmodule FileStream do
  @moduledoc false

  def read_book(file_name, start_line, end_line) do
#    Server path
    deploy_path = "/app/lib/scrupulous-0.1.0/priv/static/static_book_txt"
    local_path = "priv/static/static_book_txt"
    static_path = if File.exists?(deploy_path) do
      deploy_path
    else
      local_path
    end
    file_path = "#{file_name}.txt"
    read_lines("#{static_path}/#{file_path}", start_line, end_line)
  end

  def read_lines(path, start_line, end_line) do
    File.stream!(path)
#    |> Stream.filter(fn(line) -> line != "\n" end)
    |> Stream.with_index()
    |> Stream.map(fn({line, indx}) -> %{line: indx, txt: line} end)
    |> Stream.take(end_line)
    |> Stream.filter(fn(%{line: indx}) -> indx >= start_line end)
    |> Enum.to_list
  end

end
