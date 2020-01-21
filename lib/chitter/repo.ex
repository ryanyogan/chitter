defmodule Chitter.Repo do
  use Ecto.Repo,
    otp_app: :chitter,
    adapter: Ecto.Adapters.Postgres
end
