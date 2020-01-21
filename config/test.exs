use Mix.Config

config :chitter, ChitterWeb.Endpoint,
  http: [port: 4002],
  server: false

config :logger, level: :warn

import_config "test.secret.exs"
