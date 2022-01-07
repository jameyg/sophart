defmodule Liveupload.Repo do
  use Ecto.Repo,
    otp_app: :liveupload,
    adapter: Ecto.Adapters.SQLite3
end
