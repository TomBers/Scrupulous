defmodule ScoreQueries do
  import Ecto.Query, warn: false
  alias Scrupulous.Repo
  alias Scrupulous.UserContent.Note
  alias Scrupulous.UserContent.Skruple

  def user_notes() do
      query =
        from note in Note,
        preload: [:skruples]
    Repo.all(query)
  end

  def skruples() do
    query =
      from s in Skruple,
      join: u in assoc(s, :user),
      select: %{user: u, count: count(s.id)},
      group_by: u.id
    Repo.all(query)
  end

end
