defmodule Scrupulous.Repo do
  use Ecto.Repo,
    otp_app: :scrupulous,
    adapter: Ecto.Adapters.Postgres
end
