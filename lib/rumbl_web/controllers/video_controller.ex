defmodule RumblWeb.VideoController do
  use RumblWeb, :controller

  alias Rumbl.Shows
  alias Rumbl.Shows.Video

  def action(conn, _) do
    apply(__MODULE__, action_name(conn),
      [conn, conn.params, conn.assigns.current_user])
  end

  def index(conn, _params, current_user) do
    render(conn, "index.html", videos: Shows.user_videos(current_user))
  end

  def new(conn, _params, _current_user) do
    render(conn, "new.html", changeset: Shows.change_video(%Video{}))
  end

  def create(conn, %{"video" => video_params}, current_user) do
    case Shows.create_video(current_user, video_params) do
      {:ok, video} ->
        conn
        |> put_flash(:info, "Video created successfully.")
        |> redirect(to: video_path(conn, :show, video))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}, current_user) do
    render(conn, "show.html", video: Shows.user_video(current_user, id))
  end

  def edit(conn, %{"id" => id}, current_user) do
    video = Shows.user_video(current_user, id)
    changeset = Shows.change_video(video)
    render(conn, "edit.html", video: video, changeset: changeset)
  end

  def update(conn, %{"id" => id, "video" => video_params}, current_user) do
    video = Shows.user_video(current_user, id)

    case Shows.update_video(video, video_params) do
      {:ok, video} ->
        conn
        |> put_flash(:info, "Video updated successfully.")
        |> redirect(to: video_path(conn, :show, video))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", video: video, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}, current_user) do
    video = Shows.user_video(current_user, id)
    {:ok, _video} = Shows.delete_video(video)

    conn
    |> put_flash(:info, "Video deleted successfully.")
    |> redirect(to: video_path(conn, :index))
  end
end
