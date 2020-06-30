defmodule Dazzle.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Dazzle.Repo,
      # Start the Telemetry supervisor
      DazzleWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Dazzle.PubSub},
      # Start the Endpoint (http/https)
      DazzleWeb.Endpoint
      # Start a worker by calling: Dazzle.Worker.start_link(arg)
      # {Dazzle.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Dazzle.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    DazzleWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
