defmodule Scrupulous.BuildHtml do

  @prefix "line_"

  def get_prefix, do: @prefix

  def calc_html(book, notes) do
    markdown = return_markdown(book)

    {:ok, ast, []} = EarmarkParser.as_ast(markdown)

    new_ast =
      ast
      |> Enum.with_index(1)
      |> Enum.map(fn({{ele, props, content, misc}, indx} ) -> calc_node(ele, props, content, misc, indx, notes) end)

    Earmark.Transform.transform(new_ast)
  end

  def calc_node(ele, props, content, misc, indx, notes) do
    if Enum.any?(notes, fn(note) -> note.end_line == indx end) do
      create_notes_elements(ele, props, content, misc, indx)
    else
      {ele, props ++ [{"id", "#{@prefix}#{indx}"}, {"class", "selectableLine"}], content, misc}
    end
  end

  def create_notes_elements(ele, props, content, misc, indx) do
    [{ele, props ++ [{"id", "#{@prefix}#{indx}"}, {"class", "selectableLine"}], content ++ note_link(indx) , misc}]
  end

  def note_link(indx) do
    #    [{"a", [{"href", "#"}, {"class", "noteLink"}, {"phx-click", "hitme"}, {"phx-value-line-number", "#{indx}"}], ["note"], %{}}]
    [{"a", [{"href", "#"}, {"class", "noteLink"}, {"phx-click", "open_note"}, {"phx-value-line-number", "#{indx}"}], [{"i", [{"class", "fas fa-sticky-note"}], [], %{}}], %{}}]
  end

  def return_markdown(book) do
    case File.read(get_article_path(book)) do
      {:ok, body} -> body
      {:error, reason} -> IO.inspect(reason); ""
    end
  end

  def get_article_path(book) do
    #    Server path
    deploy_path = "/app/lib/scrupulous-0.1.0/priv/static/static_book_txt"
    local_path = "priv/static/static_book_txt"
    static_path = if File.exists?(deploy_path) do
      deploy_path
    else
      local_path
    end
    file_path = "#{book.file_name}.md"
    "#{static_path}/#{file_path}"
  end

end
