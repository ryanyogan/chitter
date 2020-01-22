defmodule Chitter.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      Chitter.Repo,
      ChitterWeb.Endpoint,
      Pow.Store.Backend.MnesiaCache
    ]

    opts = [strategy: :one_for_one, name: Chitter.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    ChitterWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
