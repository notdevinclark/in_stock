defmodule InStock.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      InStock.Repo,
      # Start the Telemetry supervisor
      InStockWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: InStock.PubSub},
      # Start the Endpoint (http/https)
      InStockWeb.Endpoint,
      # Start a worker by calling: InStock.Worker.start_link(arg)
      # {InStock.Worker, arg}
      InStock.Checker.CheckerSupervisor
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported option
    opts = [strategy: :one_for_one, name: InStock.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    InStockWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
