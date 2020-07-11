defmodule ScrupulousWeb.ScoreView do
  use ScrupulousWeb, :view

  def format_email(email) do
    email
    |> String.split("@")
    |> List.first
  end

end
