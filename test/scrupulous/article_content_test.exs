defmodule Scrupulous.ArticleContentTest do
  use Scrupulous.DataCase

  alias Scrupulous.ArticleContent

  describe "articles" do
    alias Scrupulous.ArticleContent.Article

    @valid_attrs %{content: "some content", slug: "some slug", title: "some title"}
    @update_attrs %{content: "some updated content", slug: "some updated slug", title: "some updated title"}
    @invalid_attrs %{content: nil, slug: nil, title: nil}

    def article_fixture(attrs \\ %{}) do
      {:ok, article} =
        attrs
        |> Enum.into(@valid_attrs)
        |> ArticleContent.create_article()

      article
    end

    test "list_articles/0 returns all articles" do
      article = article_fixture()
      assert ArticleContent.list_articles() == [article]
    end

    test "get_article!/1 returns the article with given id" do
      article = article_fixture()
      assert ArticleContent.get_article!(article.id) == article
    end

    test "create_article/1 with valid data creates a article" do
      assert {:ok, %Article{} = article} = ArticleContent.create_article(@valid_attrs)
      assert article.content == "some content"
      assert article.slug == "some slug"
      assert article.title == "some title"
    end

    test "create_article/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = ArticleContent.create_article(@invalid_attrs)
    end

    test "update_article/2 with valid data updates the article" do
      article = article_fixture()
      assert {:ok, %Article{} = article} = ArticleContent.update_article(article, @update_attrs)
      assert article.content == "some updated content"
      assert article.slug == "some updated slug"
      assert article.title == "some updated title"
    end

    test "update_article/2 with invalid data returns error changeset" do
      article = article_fixture()
      assert {:error, %Ecto.Changeset{}} = ArticleContent.update_article(article, @invalid_attrs)
      assert article == ArticleContent.get_article!(article.id)
    end

    test "delete_article/1 deletes the article" do
      article = article_fixture()
      assert {:ok, %Article{}} = ArticleContent.delete_article(article)
      assert_raise Ecto.NoResultsError, fn -> ArticleContent.get_article!(article.id) end
    end

    test "change_article/1 returns a article changeset" do
      article = article_fixture()
      assert %Ecto.Changeset{} = ArticleContent.change_article(article)
    end
  end
end
