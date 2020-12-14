defmodule ScrupulousWeb.SignupControllerTest do
  use ScrupulousWeb.ConnCase

  alias Scrupulous.BookClub

  @create_attrs %{email: "some email", feature: "some feature"}
  @update_attrs %{email: "some updated email", feature: "some updated feature"}
  @invalid_attrs %{email: nil, feature: nil}

  def fixture(:signup) do
    {:ok, signup} = BookClub.create_signup(@create_attrs)
    signup
  end

  describe "index" do
    test "lists all signups", %{conn: conn} do
      conn = get(conn, Routes.signup_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Signups"
    end
  end

  describe "new signup" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.signup_path(conn, :new))
      assert html_response(conn, 200) =~ "New Signup"
    end
  end

  describe "create signup" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.signup_path(conn, :create), signup: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.signup_path(conn, :show, id)

      conn = get(conn, Routes.signup_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Signup"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.signup_path(conn, :create), signup: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Signup"
    end
  end

  describe "edit signup" do
    setup [:create_signup]

    test "renders form for editing chosen signup", %{conn: conn, signup: signup} do
      conn = get(conn, Routes.signup_path(conn, :edit, signup))
      assert html_response(conn, 200) =~ "Edit Signup"
    end
  end

  describe "update signup" do
    setup [:create_signup]

    test "redirects when data is valid", %{conn: conn, signup: signup} do
      conn = put(conn, Routes.signup_path(conn, :update, signup), signup: @update_attrs)
      assert redirected_to(conn) == Routes.signup_path(conn, :show, signup)

      conn = get(conn, Routes.signup_path(conn, :show, signup))
      assert html_response(conn, 200) =~ "some updated email"
    end

    test "renders errors when data is invalid", %{conn: conn, signup: signup} do
      conn = put(conn, Routes.signup_path(conn, :update, signup), signup: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Signup"
    end
  end

  describe "delete signup" do
    setup [:create_signup]

    test "deletes chosen signup", %{conn: conn, signup: signup} do
      conn = delete(conn, Routes.signup_path(conn, :delete, signup))
      assert redirected_to(conn) == Routes.signup_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.signup_path(conn, :show, signup))
      end
    end
  end

  defp create_signup(_) do
    signup = fixture(:signup)
    %{signup: signup}
  end
end
