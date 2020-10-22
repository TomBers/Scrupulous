defmodule Scrupulous.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    import Supervisor.Spec
    children = [
      # Start the Ecto repository
      Scrupulous.Repo,
      # Start the Telemetry supervisor
      ScrupulousWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Scrupulous.PubSub},
      # Start the Endpoint (http/https)
      ScrupulousWeb.Endpoint,
      worker(Store, []),
      # Start a worker by calling: Scrupulous.Worker.start_link(arg)
      # {Scrupulous.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Scrupulous.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    ScrupulousWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
