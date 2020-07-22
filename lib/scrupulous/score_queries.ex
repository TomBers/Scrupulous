defmodule ScoreQueries do
  import Ecto.Query, warn: false
  alias Scrupulous.Repo

  alias Scrupulous.Accounts.User

  def users do
    Repo.all(User) |> Repo.preload([{:notes, :skruples}, :skruples, :resources])
  end

end
