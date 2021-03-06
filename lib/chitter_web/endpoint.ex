defmodule ChitterWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :chitter

  socket "/socket", ChitterWeb.UserSocket,
    websocket: true,
    longpoll: false

  socket "/live", Phoenix.LiveView.Socket

  plug Plug.Static,
    at: "/",
    from: :chitter,
    gzip: false,
    only: ~w(css fonts images js favicon.ico robots.txt)

  if code_reloading? do
    socket "/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket
    plug Phoenix.LiveReloader
    plug Phoenix.CodeReloader
  end

  plug Plug.RequestId
  plug Plug.Telemetry, event_prefix: [:phoenix, :endpoint]

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug Plug.MethodOverride
  plug Plug.Head

  plug Plug.Session,
    store: :cookie,
    key: "_chitter_key",
    signing_salt: "z647Kr25"

  plug Pow.Plug.Session,
    otp_app: :chitter,
    cache_store_backend: Pow.Store.Backend.MnesiaCache

  plug ChitterWeb.Router
end
