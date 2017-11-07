defmodule RumblWeb.PageController do
  use RumblWeb, :controller

  def index(conn, _params) do
    render conn, "index.html", videos: Rumbl.Shows.list_videos
  end
end
