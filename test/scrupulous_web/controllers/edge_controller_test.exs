defmodule ScrupulousWeb.EdgeControllerTest do
  use ScrupulousWeb.ConnCase

  alias Scrupulous.UserContent
  alias Scrupulous.UserContent.Edge

  @create_attrs %{
    label: "some label"
  }
  @update_attrs %{
    label: "some updated label"
  }
  @invalid_attrs %{label: nil}

  def fixture(:edge) do
    {:ok, edge} = UserContent.create_edge(@create_attrs)
    edge
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all edges", %{conn: conn} do
      conn = get(conn, Routes.edge_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create edge" do
    test "renders edge when data is valid", %{conn: conn} do
      conn = post(conn, Routes.edge_path(conn, :create), edge: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.edge_path(conn, :show, id))

      assert %{
               "id" => id,
               "label" => "some label"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.edge_path(conn, :create), edge: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update edge" do
    setup [:create_edge]

    test "renders edge when data is valid", %{conn: conn, edge: %Edge{id: id} = edge} do
      conn = put(conn, Routes.edge_path(conn, :update, edge), edge: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.edge_path(conn, :show, id))

      assert %{
               "id" => id,
               "label" => "some updated label"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, edge: edge} do
      conn = put(conn, Routes.edge_path(conn, :update, edge), edge: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete edge" do
    setup [:create_edge]

    test "deletes chosen edge", %{conn: conn, edge: edge} do
      conn = delete(conn, Routes.edge_path(conn, :delete, edge))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.edge_path(conn, :show, edge))
      end
    end
  end

  defp create_edge(_) do
    edge = fixture(:edge)
    %{edge: edge}
  end
end
