defmodule ScrupulousWeb.SkrupleController do
  use ScrupulousWeb, :controller

  alias Scrupulous.UserContent
  alias Scrupulous.UserContent.Skruple

  action_fallback ScrupulousWeb.FallbackController

  def index(conn, _params) do
    skruples = UserContent.list_skruples()
    render(conn, "index.json", skruples: skruples)
  end

  def create(conn, %{"skruple" => skruple_params}) do
    with {:ok, %Skruple{} = skruple} <- UserContent.create_skruple(skruple_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.skruple_path(conn, :show, skruple))
      |> render("show.json", skruple: skruple)
    end
  end

  def show(conn, %{"id" => id}) do
    skruple = UserContent.get_skruple!(id)
    render(conn, "show.json", skruple: skruple)
  end

  def update(conn, %{"id" => id, "skruple" => skruple_params}) do
    skruple = UserContent.get_skruple!(id)

    with {:ok, %Skruple{} = skruple} <- UserContent.update_skruple(skruple, skruple_params) do
      render(conn, "show.json", skruple: skruple)
    end
  end

  def delete(conn, %{"id" => id}) do
    skruple = UserContent.get_skruple!(id)

    with {:ok, %Skruple{}} <- UserContent.delete_skruple(skruple) do
      send_resp(conn, :no_content, "")
    end
  end
end
