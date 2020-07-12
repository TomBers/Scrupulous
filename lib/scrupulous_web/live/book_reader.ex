defmodule ScrupulousWeb.BookReader do
  use Phoenix.LiveView

  alias Scrupulous.UserContent
  alias Scrupulous.StaticContent

  def handle_params(%{"book" => book, "page" => pageStr}, _uri, socket) do
    {page, _rem} = Integer.parse(pageStr)
    start_line = page * 50
    end_line = start_line + 50

    book = StaticContent.get_book!(book)
    notes =
      UserContent.get_notes_between_lines(book.id, start_line, end_line)
      |> Enum.sort_by(&(length(&1.skruples)), &>=/2)

    lines = FileStream.read_book(book.file_name, start_line, end_line)


    {:noreply, assign(socket, title: book.title, book_id: book.id, notes: notes, lines: lines, next_page: page + 1, previous_page: page - 1, user_id: 1)}
  end

  def mount(_params, _session, socket) do
    {:ok, socket}
  end



  def handle_event("add_skruple", %{"note" => note_id}, socket) do
    IO.inspect(note_id)
    {:noreply, socket}
  end


#  Helper funcs

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

end
