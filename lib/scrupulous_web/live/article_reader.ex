defmodule ScrupulousWeb.ArticleReader do
  use Phoenix.LiveView

  alias Scrupulous.StaticContent
  alias Scrupulous.UserContent

  @prefix "line_"

  @book_id 20

  def handle_params(_params, _uri, socket) do
    book = StaticContent.get_book!(@book_id)
    notes = UserContent.get_notes_for_book(@book_id)
    {:noreply, assign(socket, content: calc_html(notes), prefix: @prefix)}
  end

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_event("hitme", params, socket) do
    IO.inspect(params)
    {:noreply, socket}
  end

  def handle_event("add_note", %{"startLine" => start_line, "endLine" => end_line, "noteText" => note_text }, socket) do
    new_note = %{start_line: start_line, end_line: end_line, note: note_text, user_id: 4, book_id: 20}
    UserContent.create_note(new_note)
    new_notes = UserContent.get_notes_for_book(@book_id)

    {:noreply, assign(socket, notes: new_notes, content: calc_html(new_notes))}
  end

  def calc_html(notes) do
    markdown = return_markdown()

    {:ok, ast, []} = EarmarkParser.as_ast(markdown)

    new_ast =
      ast
      |> Enum.with_index(1)
      |> Enum.map(fn({{ele, props, content, misc}, indx} ) -> calc_node(ele, props, content, misc, indx, notes) end)

    Earmark.Transform.transform(new_ast)
  end

  def calc_node(ele, props, content, misc, indx, notes) do
    if Enum.any?(notes, fn(note) -> note.end_line == indx end) do
      create_notes_elements(ele, props, content, misc, indx, notes)
    else
      {ele, props ++ [{"id", "#{@prefix}#{indx}"}], content, misc}
    end
  end

  def create_notes_elements(ele, props, content, misc, indx, notes) do
    note_icon = [{ele, props ++ [{"id", "#{@prefix}#{indx}"}], content ++ note_link(indx) , misc}]
    notes_text =
      notes
      |> Enum.filter(fn(note) -> note.end_line == indx end)
      |> Enum.map(fn(note) ->  {"div", [], [note.note], %{}} end)
    note_icon ++ notes_text
  end

  def note_link(indx) do
#    [{"a", [{"href", "#"}, {"class", "noteLink"}, {"phx-click", "hitme"}, {"phx-value-line-number", "#{indx}"}], ["note"], %{}}]
    [{"a", [{"href", "#"}, {"class", "noteLink"}, {"phx-click", "hitme"}, {"phx-value-line-number", "#{indx}"}], [{"i", [{"class", "fas fa-sticky-note"}], [], %{}}], %{}}]
  end

  def return_markdown do
    case File.read("./sample.md") do
      {:ok, body} -> body
      {:error, reason} -> IO.inspect(reason); ""
    end
  end

end
