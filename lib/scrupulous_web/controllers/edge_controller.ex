defmodule ScrupulousWeb.EdgeController do
  use ScrupulousWeb, :controller

  alias Scrupulous.UserContent
  alias Scrupulous.UserContent.Edge

  action_fallback ScrupulousWeb.FallbackController

  def index(conn, _params) do
    edges = UserContent.list_edges()
    render(conn, "index.json", edges: edges)
  end

  def create(conn, %{"edge" => edge_params}) do
    with {:ok, %Edge{} = edge} <- UserContent.create_edge(edge_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.edge_path(conn, :show, edge))
      |> render("show.json", edge: edge)
    end
  end

  def show(conn, %{"id" => id}) do
    edge = UserContent.get_edge!(id)
    render(conn, "show.json", edge: edge)
  end

  def update(conn, %{"id" => id, "edge" => edge_params}) do
    edge = UserContent.get_edge!(id)

    with {:ok, %Edge{} = edge} <- UserContent.update_edge(edge, edge_params) do
      render(conn, "show.json", edge: edge)
    end
  end

  def delete(conn, %{"id" => id}) do
    edge = UserContent.get_edge!(id)

    with {:ok, %Edge{}} <- UserContent.delete_edge(edge) do
      send_resp(conn, :no_content, "")
    end
  end
end
