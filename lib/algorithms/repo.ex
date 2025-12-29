defmodule Algorithms.Repo do
  use Ecto.Repo,
    otp_app: :algorithms,
    adapter: Ecto.Adapters.Postgres
end
