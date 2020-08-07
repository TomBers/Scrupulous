defmodule ScrupulousWeb.ArticleReader do
  use Phoenix.LiveView

  alias Scrupulous.StaticContent
  alias Scrupulous.UserContent

  @prefix "line_"

  @book_id 20

  def handle_params(_params, _uri, socket) do
    book = StaticContent.get_book!(@book_id)
    notes = UserContent.get_notes_for_book(@book_id)
    {:noreply, assign(socket, book: book, content: calc_html(notes), prefix: @prefix, notes: notes, open_note: nil)}
  end

  def mount(%{"article" => article}, %{"user_token" => user_token}, socket) do
      current_user = Scrupulous.Accounts.get_user_by_session_token(user_token)
      {:ok, assign(socket, current_user: current_user, open_note: nil)}
  end

  def mount(%{"article" => article}, _session, socket) do
    {:ok, assign(socket, current_user: nil, open_note: nil)}
  end

  def handle_event("open_note", %{"line-number" => line}, socket) do
    open_note =
      if is_nil(socket.assigns.open_note) do
        String.to_integer(line)
      else
        nil
      end
    {:noreply, assign(socket, open_note: open_note)}
  end

  def handle_event("close_note", _params, socket) do
    {:noreply, assign(socket, open_note: nil)}
  end

  def handle_event("add_note", %{"startLine" => start_line, "endLine" => end_line, "noteText" => note_text }, socket) do
    new_note = %{start_line: start_line, end_line: end_line, note: note_text, user_id: socket.assigns.current_user.id, book_id: socket.assigns.book.id}
    UserContent.create_note(new_note)
    new_notes = UserContent.get_notes_for_book(@book_id)

    {:noreply, assign(socket, notes: new_notes, content: calc_html(new_notes))}
  end

  def format_email(email) do
    email
    |> String.split("@")
    |> List.first
  end

  def get_notes(line, notes) do
    notes
    |> Enum.filter(fn(note) -> line >= note.start_line and line <= note.end_line end)
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
    [{ele, props ++ [{"id", "#{@prefix}#{indx}"}], content ++ note_link(indx) , misc}]
  end

  def note_link(indx) do
#    [{"a", [{"href", "#"}, {"class", "noteLink"}, {"phx-click", "hitme"}, {"phx-value-line-number", "#{indx}"}], ["note"], %{}}]
    [{"a", [{"href", "#"}, {"class", "noteLink"}, {"phx-click", "open_note"}, {"phx-value-line-number", "#{indx}"}], [{"i", [{"class", "fas fa-sticky-note"}], [], %{}}], %{}}]
  end

  def return_markdown do
    case File.read("./sample.md") do
      {:ok, body} -> body
      {:error, reason} -> IO.inspect(reason); ""
    end
  end

end
