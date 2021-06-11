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
      # Start the Checkers and their supervisors
      checker_child_spec()
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported option
    opts = [strategy: :one_for_one, name: InStock.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Returns a child spec for an ad-hoc supervisor that will start the dynamic
  # supervisor CheckerSupervisor and then start its initial children
  #
  # References:
  # - https://elixirforum.com/t/understanding-dynamicsupervisor-no-initial-children/14938/2
  # - https://github.com/slashdotdash/til/blob/master/elixir/dynamic-supervisor-start-children.md
  defp checker_child_spec() do
    checker_children = [
      InStock.Checker.CheckerSupervisor,
      {Task, &InStock.Checker.CheckerSupervisor.spawn_checkers/0}
    ]

    checker_opts = [
      strategy: :rest_for_one,
      name: InStock.Checker.CheckerStartSupervisor
    ]

    %{
      id: InStock.Checker.CheckerStartSupervisor,
      start: {
        Supervisor,
        :start_link,
        [checker_children, checker_opts]
      }
    }
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    InStockWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
