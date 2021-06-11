defmodule InStock.Repo do
  use Ecto.Repo,
    otp_app: :in_stock,
    adapter: Ecto.Adapters.Postgres
end
