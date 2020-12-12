defmodule Scrupulous.BookClubTest do
  use Scrupulous.DataCase

  alias Scrupulous.BookClub

  describe "signups" do
    alias Scrupulous.BookClub.Signup

    @valid_attrs %{email: "some email", feature: "some feature"}
    @update_attrs %{email: "some updated email", feature: "some updated feature"}
    @invalid_attrs %{email: nil, feature: nil}

    def signup_fixture(attrs \\ %{}) do
      {:ok, signup} =
        attrs
        |> Enum.into(@valid_attrs)
        |> BookClub.create_signup()

      signup
    end

    test "list_signups/0 returns all signups" do
      signup = signup_fixture()
      assert BookClub.list_signups() == [signup]
    end

    test "get_signup!/1 returns the signup with given id" do
      signup = signup_fixture()
      assert BookClub.get_signup!(signup.id) == signup
    end

    test "create_signup/1 with valid data creates a signup" do
      assert {:ok, %Signup{} = signup} = BookClub.create_signup(@valid_attrs)
      assert signup.email == "some email"
      assert signup.feature == "some feature"
    end

    test "create_signup/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = BookClub.create_signup(@invalid_attrs)
    end

    test "update_signup/2 with valid data updates the signup" do
      signup = signup_fixture()
      assert {:ok, %Signup{} = signup} = BookClub.update_signup(signup, @update_attrs)
      assert signup.email == "some updated email"
      assert signup.feature == "some updated feature"
    end

    test "update_signup/2 with invalid data returns error changeset" do
      signup = signup_fixture()
      assert {:error, %Ecto.Changeset{}} = BookClub.update_signup(signup, @invalid_attrs)
      assert signup == BookClub.get_signup!(signup.id)
    end

    test "delete_signup/1 deletes the signup" do
      signup = signup_fixture()
      assert {:ok, %Signup{}} = BookClub.delete_signup(signup)
      assert_raise Ecto.NoResultsError, fn -> BookClub.get_signup!(signup.id) end
    end

    test "change_signup/1 returns a signup changeset" do
      signup = signup_fixture()
      assert %Ecto.Changeset{} = BookClub.change_signup(signup)
    end
  end
end
