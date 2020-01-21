use Mix.Config

config :chitter,
  ecto_repos: [Chitter.Repo]

config :chitter, ChitterWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "uYsaCPf1+EJTtbNOJgWOm7NktVbq3NOhv5XKI02rDPyCeehnjwlgEvTjtC7zKTrc",
  render_errors: [view: ChitterWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Chitter.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [
    signing_salt: "5mC30K5BSc6KHCkZemnj09B/fuV7VF25"
  ]

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :json_library, Jason

import_config "#{Mix.env()}.exs"
