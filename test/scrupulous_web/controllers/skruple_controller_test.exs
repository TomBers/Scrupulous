defmodule ScrupulousWeb.SkrupleControllerTest do
  use ScrupulousWeb.ConnCase

  alias Scrupulous.UserContent
  alias Scrupulous.UserContent.Skruple

  @create_attrs %{

  }
  @update_attrs %{

  }
  @invalid_attrs %{}

  def fixture(:skruple) do
    {:ok, skruple} = UserContent.create_skruple(@create_attrs)
    skruple
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all skruples", %{conn: conn} do
      conn = get(conn, Routes.skruple_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create skruple" do
    test "renders skruple when data is valid", %{conn: conn} do
      conn = post(conn, Routes.skruple_path(conn, :create), skruple: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.skruple_path(conn, :show, id))

      assert %{
               "id" => id
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.skruple_path(conn, :create), skruple: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update skruple" do
    setup [:create_skruple]

    test "renders skruple when data is valid", %{conn: conn, skruple: %Skruple{id: id} = skruple} do
      conn = put(conn, Routes.skruple_path(conn, :update, skruple), skruple: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.skruple_path(conn, :show, id))

      assert %{
               "id" => id
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, skruple: skruple} do
      conn = put(conn, Routes.skruple_path(conn, :update, skruple), skruple: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete skruple" do
    setup [:create_skruple]

    test "deletes chosen skruple", %{conn: conn, skruple: skruple} do
      conn = delete(conn, Routes.skruple_path(conn, :delete, skruple))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.skruple_path(conn, :show, skruple))
      end
    end
  end

  defp create_skruple(_) do
    skruple = fixture(:skruple)
    %{skruple: skruple}
  end
end
