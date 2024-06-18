defmodule Amalgama.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      Amalgama.CommandedApp,
      AmalgamaWeb.Telemetry,
      Amalgama.Repo,
      {DNSCluster, query: Application.get_env(:amalgama, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Amalgama.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Amalgama.Finch},
      # Start a worker by calling: Amalgama.Worker.start_link(arg)
      # {Amalgama.Worker, arg},
      # Start to serve requests, typically the last entry
      AmalgamaWeb.Endpoint,
      Amalgama.Accounts.Supervisor
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Amalgama.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    AmalgamaWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
