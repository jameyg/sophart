defmodule LiveuploadWeb.PageController do
  use LiveuploadWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
