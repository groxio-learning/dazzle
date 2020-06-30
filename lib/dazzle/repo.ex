defmodule Dazzle.Repo do
  use Ecto.Repo,
    otp_app: :dazzle,
    adapter: Ecto.Adapters.Postgres
end
