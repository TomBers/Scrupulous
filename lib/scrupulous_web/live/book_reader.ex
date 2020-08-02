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

    bookmarks =
      if socket.assigns.current_user do
        UserContent.bookmark_for_page(socket.assigns.current_user.id, book.id, page)
      else
       nil
      end
    {:noreply, assign(socket, title: book.title, book: book, notes: notes, lines: lines, page: page, show_note_form: false, bookmarks: bookmarks)}
  end

  def mount(%{"book" => book, "page" => page, "note" => note_id}, %{"user_token" => user_token}, socket) do
    if String.to_integer(page) >= 0 do
      current_user = Scrupulous.Accounts.get_user_by_session_token(user_token)
      {:ok, assign(socket, current_user: current_user, open_note: String.to_integer(note_id))}
    else
      {:ok, redirect(socket, to: "/reader/#{book}/page/0")}
    end
  end

  def mount(%{"book" => book, "page" => page}, %{"user_token" => user_token}, socket) do
    if String.to_integer(page) >= 0 do
      current_user = Scrupulous.Accounts.get_user_by_session_token(user_token)
      {:ok, assign(socket, current_user: current_user, open_note: nil)}
    else
      {:ok, redirect(socket, to: "/reader/#{book}/page/0")}
    end
  end

  def mount(_params, _session, socket) do
    {:ok, assign(socket, current_user: nil, open_note: nil)}
  end


  def handle_event("bookmark", _params, socket) do
    bookmark = %{
      user_id: socket.assigns.current_user.id,
      book_id: socket.assigns.book.id,
      page: socket.assigns.page
    }
    UserContent.create_bookmark(bookmark)
#    Adding the bookmarks list as we test that it is not empty in the template.  Could put in the result, but no point
    {:noreply, assign(socket, bookmarks: [1])}
  end

  def handle_event("add_note", %{"startLine" => start_line, "endLine" => end_line, "noteText" => note_text }, socket) do
    new_note = %{start_line: start_line, end_line: end_line, note: note_text, user_id: socket.assigns.current_user.id, book_id: socket.assigns.book.id}
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

  def handle_event("close_form", _params, socket) do
    rand = Enum.random(1..10000)
    {:noreply, assign(socket, show_note_form: rand)}
  end


  def get_updated_notes(socket) do
    start_line = socket.assigns.page * 50
    UserContent.get_notes_between_lines(socket.assigns.book.id, start_line, start_line + 50)
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

  def get_line_class(line, open_note, notes) do
    if Enum.any?(
         notes,
         fn (note) ->
           open_note >= note.start_line and open_note <= note.end_line and line >= note.start_line and line <= note.end_line
         end
       ) do
      "line selected"
    else
      "line"
    end
  end


end
