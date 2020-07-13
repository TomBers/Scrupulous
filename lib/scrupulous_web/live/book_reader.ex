defmodule ScrupulousWeb.BookReader do
  use Phoenix.LiveView

  alias Scrupulous.UserContent
  alias Scrupulous.StaticContent
  alias Scrupulous.UserContent.Note

  def handle_params(%{"book" => book, "page" => pageStr}, _uri, socket) do
    {page, _rem} = Integer.parse(pageStr)
    start_line = page * 50
    end_line = start_line + 50

    book = StaticContent.get_book!(book)
    notes =
      UserContent.get_notes_between_lines(book.id, start_line, end_line)
      |> Enum.sort_by(&(length(&1.skruples)), &>=/2)

    lines = FileStream.read_book(book.file_name, start_line, end_line)


    {:noreply, assign(socket, title: book.title, book_id: book.id, notes: notes, lines: lines, page: page, open_note: nil)}
  end

  def mount(_params, %{"user_token" => user_token}, socket) do
    current_user = Scrupulous.Accounts.get_user_by_session_token(user_token)
    {:ok, assign(socket, current_user: current_user)}
  end


  def handle_event("add_note", %{"startLine" => start_line, "endLine" => end_line, "noteText" => note_text }, socket) do

    new_note = %{start_line: start_line, end_line: end_line, note: note_text, user_id: socket.assigns.current_user.id, book_id: socket.assigns.book_id}
    UserContent.create_note(new_note)
    {:noreply, assign(socket, notes: get_updated_notes(socket))}
  end

  def handle_event("add_skruple", %{"note" => note_id}, socket) do
    new_skruple = %{note_id: note_id, user_id: socket.assigns.current_user.id}
    UserContent.create_skruple(new_skruple)
    {:noreply, assign(socket, notes: get_updated_notes(socket))}
  end

  def handle_event("open_note", %{"line-number" => line_number}, socket) do
    open_note =
      if is_nil(socket.assigns.open_note) do
        String.to_integer(line_number)
      else
        nil
    end
    {:noreply, assign(socket, open_note: open_note)}
  end

  def handle_event("close_note", _params, socket) do
    {:noreply, assign(socket, open_note: nil)}
  end




  def get_updated_notes(socket) do
    start_line = socket.assigns.page * 50
    UserContent.get_notes_between_lines(socket.assigns.book_id, start_line, start_line + 50)
    |> Enum.sort_by(&(length(&1.skruples)), &>=/2)
  end

#  Helper funcs

  def is_note_open(line, open_note) do
    line == open_note
  end

  def has_note(line, notes) do
    notes
    |> Enum.any?(fn(note) -> note.end_line == line end)
  end

  def get_notes(line, notes) do
    notes
    |> Enum.filter(fn(note) -> line >= note.start_line and line <= note.end_line end)
  end

  def get_category_links(resources, category) do
    resources
    |> Enum.filter(fn(resource) -> resource.category == category end)
  end

  def format_email(email) do
    email
    |> String.split("@")
    |> List.first
  end

  def have_skruped(user, skruples) do
    skruples
    |> Enum.any?(fn(skruple) -> skruple.user_id == user.id end)
  end

  def get_note_class(line, open_note) do
    if is_note_open(line, open_note) do
      "note activeIcon"
    else
      "note"
    end
  end


end
