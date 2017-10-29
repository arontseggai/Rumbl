defmodule RumblWeb.WatchController do
  use RumblWeb, :controller
  alias Rumbl.Shows

  def show(conn, %{"id" => id}) do
    video = Shows.get_video!(id)
    render conn, "show.html", video: video
  end
end
