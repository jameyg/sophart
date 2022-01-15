defmodule SophartWeb.PageController do
  use SophartWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
