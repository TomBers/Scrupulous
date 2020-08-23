defmodule Scrupulous.BuildHtml do

  @prefix "line_"

  def get_prefix, do: @prefix

  def preview_html(article) do
    {:ok, html, []} = Earmark.as_html(article.content)
    html
  end

  def calc_html(book, notes, current_user) do
    markdown = book.content

    {:ok, ast, []} = EarmarkParser.as_ast(markdown)

    new_ast =
      ast
      |> Enum.with_index(1)
      |> Enum.map(fn({{ele, props, content, misc}, indx} ) -> calc_node(ele, props, content, misc, indx, notes, current_user) end)

    Earmark.Transform.transform(new_ast)
  end

  def calc_node(ele, props, content, misc, indx, notes, current_user) do
    if Enum.any?(notes, fn(note) -> note.end_line == indx end) do
      create_notes_elements(ele, props, content, misc, indx, notes, current_user)
    else
      {ele, props ++ [{"id", "#{@prefix}#{indx}"}, {"class", "selectableLine"}], content, misc}
    end
  end

  def create_notes_elements(ele, props, content, misc, indx, notes, current_user) do
    note_icon = [{ele, props ++ [{"id", "#{@prefix}#{indx}"}, {"class", "selectableLine"}], content ++ note_link(indx) , misc}]
    notes_elements =
      notes
      |> Enum.filter(fn(note) -> note.end_line == indx end)
      |> Enum.map(fn(note) -> create_note_cotent(note, indx, current_user) end)
    note_icon ++ notes_elements
  end

  defp create_note_cotent(note, indx, current_user) do
    {"div", [{"class", "hideNotes tile is-ancestor #{@prefix}#{indx}"}], [{"div", [{"class", "tile is-parent is-vertical"}], [{"article", [{"class", "tile is-child notification"}], build_tile_contents(note, current_user), %{}}], %{}}], %{}}
  end

  defp build_tile_contents(note, current_user) do
    top_part = [
      {"a", [{"class", "closeNote"}], [{"i", [{"class", "far fa-times-circle"}], [], %{}}], %{}},
      {"p", [{"class", ""}], note.note, %{}},
      {"a", [{"class", "subtitle"}, {"href", "/contributors/#{note.user_id}"}], [ScrupulousWeb.ReaderHelpers.format_email(note.user.email)], %{}}
    ]
    user_part =
      if current_user do
        calc_user_part(note, current_user)
      else
        []
      end
    bottom_part = [{"p", [{"class", ""}], "#{length(note.article_skruples)} Skruples", %{}}]

    top_part ++ user_part ++ bottom_part
  end

  defp calc_user_part(note, current_user) do
    if ScrupulousWeb.ReaderHelpers.have_skruped(current_user, note.article_skruples) do
      [{"i", [{"class", "fas fa-heart"}], [], %{}}]
    else
      [{"a", [{"href", "#"}, {"phx-click", "add_skruple"}, {"phx-value-note", "#{note.id}"}], [{"i", [{"class", "far fa-heart"}], [], %{}}], %{}}]
    end
  end

  defp note_link() do
    [{"a", [{"class", "noteLink"}], [{"i", [{"class", "fas fa-sticky-note"}], [], %{}}], %{}}]
  end

end
