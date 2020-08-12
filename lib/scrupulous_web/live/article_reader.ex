defmodule ScrupulousWeb.ArticleReader do
  use Phoenix.LiveView

  alias Scrupulous.BuildHtml

  alias Scrupulous.ArticleContent

  def handle_params(params, _uri, socket) do
    {article_slug, open_note_line} = extract_prams(params)
    article = ArticleContent.get_article_from_slug(article_slug)
    notes = ArticleContent.get_notes_for_article(article.id)
    {:noreply, assign(socket, article: article, content: BuildHtml.calc_html(article, notes), prefix: BuildHtml.get_prefix(), notes: notes, open_note: open_note_line)}
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
    article_id = socket.assigns.article.id
    user = socket.assigns.current_user
    make_note(start_line, end_line, note_text, user, article_id)

    new_notes = ArticleContent.get_notes_for_article(article_id)
    {:noreply, assign(socket, notes: new_notes, content: BuildHtml.calc_html(socket.assigns.article, new_notes))}
  end

  def handle_event("add_skruple", %{"note" => note_id}, socket) do
    make_skruple(note_id, socket.assigns.current_user)
    {:noreply, assign(socket, notes: ArticleContent.get_notes_for_article(socket.assigns.article.id))}
  end

  #  Create methods
  def make_note(_start_line, _end_line, _note, user, _article_id) when is_nil(user) do
    nil
  end

  def make_note(start_line, end_line, note, user, article_id) do
    new_note = %{start_line: start_line, end_line: end_line, note: note, user_id: user.id, article_id: article_id }
    ArticleContent.create_note(new_note)
  end

  def make_skruple(_note_id, user) when is_nil(user) do
    nil
  end

  def make_skruple(article_id, user) do
    new_skruple = %{note_id: article_id, user_id: user.id}
    ArticleContent.create_skruple(new_skruple)
  end


end
