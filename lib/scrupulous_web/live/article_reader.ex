defmodule ScrupulousWeb.ArticleReader do
  use Phoenix.LiveView

  alias Scrupulous.BuildHtml

  alias Scrupulous.StaticContent
  alias Scrupulous.UserContent

  alias ScrupulousWeb.ReaderHelpers

  def handle_params(params, _uri, socket) do
    {article, open_note_line} = extract_prams(params)
    book = StaticContent.get_book_from_slug(article)
    notes = UserContent.get_notes_for_book(book.id)
    {:noreply, assign(socket, book: book, content: BuildHtml.calc_html(book, notes), prefix: BuildHtml.get_prefix(), notes: notes, open_note: open_note_line)}
  end

  def extract_prams(%{"article" => article, "note" => note}) do
    {article, String.to_integer(note)}
  end

  def extract_prams(%{"article" => article}) do
    {article, nil}
  end

  def mount(_params, %{"user_token" => user_token}, socket) do
      current_user = Scrupulous.Accounts.get_user_by_session_token(user_token)
      {:ok, assign(socket, current_user: current_user, open_note: nil)}
  end

  def mount(_params, _session, socket) do
    {:ok, assign(socket, current_user: nil, open_note: nil)}
  end


#  Events
######################

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
    book_id = socket.assigns.book.id
    user = socket.assigns.current_user
    ReaderHelpers.make_note(start_line, end_line, note_text, user, book_id)

    new_notes = UserContent.get_notes_for_book(book_id)
    {:noreply, assign(socket, notes: new_notes, content: BuildHtml.calc_html(socket.assigns.book, new_notes))}
  end

  def handle_event("add_skruple", %{"note" => note_id}, socket) do
    ReaderHelpers.make_skruple(note_id, socket.assigns.current_user)
    {:noreply, assign(socket, notes: UserContent.get_notes_for_book(socket.assigns.book.id))}
  end


end
