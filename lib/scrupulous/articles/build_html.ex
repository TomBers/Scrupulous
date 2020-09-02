defmodule Scrupulous.BuildHtml do

  @prefix "line_"

  def get_prefix, do: @prefix

  def preview_html(article) do
    {:ok, html, []} = Earmark.as_html(article.content)
    html
  end

  def calc_html(book, notes, current_user, open_note) do
    markdown = book.content
    {:ok, ast, []} = EarmarkParser.as_ast(markdown)

    new_ast =
      ast
      |> Enum.with_index(1)
      |> Enum.map(fn({{ele, props, content, misc}, indx} ) -> calc_node(ele, props, content, misc, indx, notes, current_user, open_note) end)

    Earmark.Transform.transform(new_ast)
  end

  def calc_node(ele, props, content, misc, indx, notes, current_user, open_note) do

    if Enum.any?(notes, fn(note) -> note.end_line == indx end) do
      create_notes_elements(ele, props, content, misc, indx, notes, current_user, open_note)
    else
      {ele, props ++ [{"id", "#{@prefix}#{indx}"}, {"class", line_class(open_note, indx)}], content, misc}
    end
  end

  def create_notes_elements(ele, props, content, misc, indx, notes, current_user, open_note) do
    note_icon = [{ele, props ++ [{"id", "#{@prefix}#{indx}"}, {"class", line_class(open_note, indx)}], content ++ note_link() , misc}]
    notes_elements =
      notes
      |> Enum.filter(fn(note) -> note.end_line == indx end)
      |> Enum.map(fn(note) -> create_note_cotent(note, indx, current_user, open_note) end)
    note_icon ++ notes_elements
  end

  defp create_note_cotent(note, indx, current_user, open_note) do
    notes_class = if !is_nil(open_note) and note.id == open_note.id do "" else "hideNotes" end
    {"div", [{"class", "#{notes_class} tile is-ancestor #{@prefix}#{indx}"}], [{"div", [{"class", "tile is-parent is-vertical"}], [{"article", [{"class", "tile is-child notification"}], build_tile_contents(note, current_user), %{}}], %{}}], %{}}
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
    bottom_part = [
      {"p", [{"class", ""}], ["#{length(note.article_skruples)} Skruples ", {"a", [{"onclick", "copyStringToClipboard('#{note.id}')"}], [{"i", [{"class", "far fa-clipboard"}], [], %{}}], %{}} ], %{}}
    ]

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


  defp is_in_range(open_note, _indx) when is_nil(open_note), do: false
  defp is_in_range(open_note, indx), do: indx >= open_note.start_line and indx <= open_note.end_line

  defp line_class(open_note, indx) do
    if is_in_range(open_note, indx) do
      "selectableLine selected"
      else
      "selectableLine"
    end

  end

end
