defmodule Scrupulous.ArticleContent.Note do
  use Ecto.Schema
  import Ecto.Changeset
  alias Scrupulous.ArticleContent.Article
  alias Scrupulous.Accounts.User
  alias Scrupulous.ArticleContent.Skruple

  schema "article_notes" do
    field :end_line, :integer
    field :note, :string
    field :start_line, :integer

    belongs_to :article, Article
    belongs_to :user, User

    has_many :article_skruples, Skruple, on_delete: :delete_all

    timestamps()
  end

  @doc false
  def changeset(note, attrs) do
    note
    |> cast(attrs, [:start_line, :end_line, :note, :article_id, :user_id])
    |> validate_required([:start_line, :end_line, :note, :article_id, :user_id])
  end
end
