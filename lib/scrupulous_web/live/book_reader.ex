defmodule ScrupulousWeb.BookReader do
  use Phoenix.LiveView

  alias Scrupulous.UserContent
  alias Scrupulous.StaticContent

  @lines_per_page Scrupulous.Constants.lines_per_page

  def handle_params(params, _uri, socket) do
    { book, page, note_id, highlight_start, highlight_end } = extract_params(params)

    start_line = page * @lines_per_page
    end_line = start_line + @lines_per_page

    book = StaticContent.get_book!(book)
    notes =
      UserContent.get_notes_between_lines(book.id, start_line, end_line)
      |> Enum.sort_by(&(length(&1.skruples)), &>=/2)

    param_note = notes |> Enum.filter(fn(note) -> if is_nil(note_id) do false else note_id == note.id end end) |> List.first

    open_note = if is_nil(param_note) do nil else param_note.end_line end

    lines = FileStream.read_book(book.file_name, start_line, end_line)

    bookmarks =
      if socket.assigns.current_user do
        UserContent.bookmark_for_page(socket.assigns.current_user.id, book.id, page)
      else
       nil
      end
    {:noreply, assign(socket, title: book.title, book: book, notes: notes, lines: lines, page: page, show_note_form: false, bookmarks: bookmarks, search: [], open_note: open_note, param_note: param_note, lines_per_page: @lines_per_page, sl: highlight_start, el: highlight_end)}
  end

  def extract_params(%{"book" => book, "page" => page, "sl" => sl, "el" => el}) do
    {book, String.to_integer(page), nil, sl, el }
  end

  def extract_params(%{"book" => book, "page" => page, "note" => note}) do
    {book, String.to_integer(page), String.to_integer(note), nil, nil }
  end

  def extract_params(%{"book" => book, "page" => page}) do
    {book, String.to_integer(page), nil, nil, nil }
  end

  def extract_params(%{"book" => book}) do
    {book, 0, nil, nil, nil }
  end

  def mount(%{"book" => book, "page" => page}, %{"user_token" => user_token}, socket) do
    if String.to_integer(page) >= 0 do
      current_user = Scrupulous.Accounts.get_user_by_session_token(user_token)
      {:ok, assign(socket, current_user: current_user, open_note: nil)}
    else
      {:ok, redirect(socket, to: "/reader/#{book}/page/0")}
    end
  end

  def mount(%{"book" => book, "page" => page}, _session, socket) do
    if String.to_integer(page) >= 0 do
      {:ok, assign(socket, current_user: nil, open_note: nil)}
    else
      {:ok, redirect(socket, to: "/reader/#{book}/page/0")}
    end
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
    book_id = socket.assigns.book.id
    user = socket.assigns.current_user
    make_note(start_line, end_line, note_text, user, book_id)
    {:noreply, assign(socket, notes: get_updated_notes(socket))}
  end

  def handle_event("add_skruple", %{"note" => note_id}, socket) do
    make_skruple(note_id, socket.assigns.current_user)
    {:noreply, assign(socket, notes: get_updated_notes(socket))}
  end

  def handle_event("open_note", %{"line-number" => line_number}, socket) do
    open_note =
      if is_nil(socket.assigns.open_note) do
        String.to_integer(line_number)
      else
        nil
    end
    {:noreply, assign(socket, open_note: open_note, param_note: nil)}
  end

  def handle_event("close_note", _params, socket) do
    {:noreply, assign(socket, open_note: nil, param_note: nil)}
  end

  def handle_event("close_form", _params, socket) do
    rand = Enum.random(1..10000)
    {:noreply, assign(socket, show_note_form: rand)}
  end

  def handle_event("search", %{"_target" => _target, "query" => query}, socket) do
    search = if String.length(query) > 7 do
        FileStream.find_phrase(socket.assigns.book.file_name, query)
      else
        []
    end
    {:noreply, assign(socket, search: search)}
  end


  def get_updated_notes(socket) do
    start_line = socket.assigns.page * @lines_per_page
    UserContent.get_notes_between_lines(socket.assigns.book.id, start_line, start_line + @lines_per_page)
    |> Enum.sort_by(&(length(&1.skruples)), &>=/2)
  end

#  Create methods
  def make_note(_start_line, _end_line, _note, user, _book_id) when is_nil(user) do
    nil
  end

  def make_note(start_line, end_line, note, user, book_id) do
    new_note = %{start_line: start_line, end_line: end_line, note: note, user_id: user.id, book_id: book_id }
    UserContent.create_note(new_note)
  end

  def make_skruple(_note_id, user) when is_nil(user) do
    nil
  end

  def make_skruple(note_id, user) do
    new_skruple = %{note_id: note_id, user_id: user.id}
    UserContent.create_skruple(new_skruple)
  end

end
