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
    notes_for_line = notes |> Enum.filter(fn(note) -> note.end_line == indx end)
    note_icon = [{ele, props ++ [{"id", "#{@prefix}#{indx}"}, {"class", line_class(open_note, indx)}], content ++ note_link(length(notes_for_line)) , misc}]
    notes_elements =
      notes_for_line
      |> Enum.map(fn(note) -> create_note_cotent(note, indx, current_user, open_note) end)
    note_icon ++ notes_elements
  end

  defp create_note_cotent(note, indx, current_user, open_note) do
    notes_class = if !is_nil(open_note) and note.id == open_note.id do "openNotes" else "hideNotes" end
    {"div", [{"class", "#{notes_class} tile is-ancestor #{@prefix}#{indx}"}], [{"div", [{"class", "tile is-parent is-vertical"}], [{"article", [{"class", "tile is-child notification"}], build_tile_contents(note, current_user), %{}}], %{}}], %{}}
  end

  defp build_tile_contents(note, current_user) do
    note_ast = create_note_ast(note.note)
    top_part = [
      {"a", [{"class", "closeNote is-pulled-right"}], [{"i", [{"class", "far fa-times-circle"}], [], %{}}], %{}},
      note_ast,
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

  def create_note_ast(note) do
    # Maybe TODO add target="_blank" to link
    {:ok, ast, []} = EarmarkParser.as_ast(note)
    ast
  end

  defp calc_user_part(note, current_user) do
    if ScrupulousWeb.ReaderHelpers.have_skruped(current_user, note.article_skruples) do
      [{"i", [{"class", "fas fa-heart fa-2x is-pulled-right"}], [], %{}}]
    else
      [{"a", [{"phx-click", "add_skruple"}, {"phx-value-note", "#{note.id}"}, {"class", "is-pulled-right"}], [{"i", [{"class", "far fa-heart fa-2x"}], [], %{}}], %{}}]
    end
  end

  defp note_link(notes_length) do
    [{"a", [{"class", "noteLink"}], [{"span", [{"class", "small-white-circle article-circle"}], "#{notes_length}", %{}}], %{}}]
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
