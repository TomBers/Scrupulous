defmodule ScrupulousWeb.ArticleReader do
  use Phoenix.LiveView

  @prefix "line_"

  def handle_params(_params, _uri, socket) do
    {:noreply, socket}
  end

  def mount(_params, _session, socket) do
    {:ok, assign(socket, content: calc_html(), prefix: @prefix)}
  end

  def handle_event("hitme", params, socket) do
    IO.inspect(params)
    {:noreply, socket}
  end

  def calc_html do
    markdown = return_markdown()
    notes = return_notes()

    {:ok, ast, []} = EarmarkParser.as_ast(markdown)

    new_ast =
      ast
      |> Enum.with_index(1)
      |> Enum.map(fn({{ele, props, content, misc}, indx} ) -> calc_node(ele, props, content, misc, indx, notes) end)

    Earmark.Transform.transform(new_ast)
  end

  def calc_node(ele, props, content, misc, indx, notes) do
    if Enum.any?(notes, fn(note) -> note.end_line == indx end) do
#      We can add the notes contents here by appending elements
      [
        {ele, props ++ [{"id", "#{@prefix}#{indx}"}], content ++ note_link(indx) , misc},
        {"div", [], ["I WILL be a note"], %{}}
      ]
    else
      {ele, props ++ [{"id", "#{@prefix}#{indx}"}], content, misc}
    end
  end

  def note_link(indx) do
    [{"a", [{"href", "#"}, {"class", "noteLink"}, {"phx-click", "hitme"}, {"phx-value-line-number", "#{indx}"}], ["note"], %{}}]
  end

  def return_markdown do
    case File.read("./sample.md") do
      {:ok, body} -> body
      {:error, reason} -> IO.inspect(reason); ""
    end
  end

  def return_notes do
    [
      %{start_line: 1, end_line: 2, note: "I am a note"}
    ]
  end

end
