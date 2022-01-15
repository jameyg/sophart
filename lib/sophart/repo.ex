defmodule Sophart.Repo do
  use Ecto.Repo,
    otp_app: :sophart,
    adapter: Ecto.Adapters.SQLite3
end
