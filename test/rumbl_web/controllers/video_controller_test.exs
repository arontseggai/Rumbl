defmodule RumblWeb.VideoControllerTest do
  use RumblWeb.ConnCase
  alias Rumbl.Shows.Video

  @valid_attrs %{url: "https://youtube.be", title: "vid", description: "a vid"}
  @invalid_attrs %{title: "invalid"}

  setup %{conn: conn} = config do
    if username = config[:login_as] do
      user = insert_user([username: username])
      conn = assign(conn, :current_user, user)
      {:ok, conn: conn, user: user}
    else
      :ok
    end
  end

  defp video_count(query), do: Repo.one(from v in query, select: count(v.id))

  test "requires user authentication on all actions", %{conn: conn} do
    Enum.each([
      get(conn, video_path(conn, :new)),
      get(conn, video_path(conn, :index)),
      get(conn, video_path(conn, :show, "123")),
      get(conn, video_path(conn, :edit, "123")),
      put(conn, video_path(conn, :update, "123", %{})),
      post(conn, video_path(conn, :create, %{})),
      delete(conn, video_path(conn, :delete, "123")),
      ], fn conn ->
      assert html_response(conn, 302)
      assert conn.halted
    end)
  end

  @tag login_as: "max"
  test "list's user's videos on index", %{conn: conn, user: user} do
    user_video = insert_video(user, title: "Funny cats")
    other_video = insert_video(insert_user([username: "other"]), title: "Another video")

    conn = get conn, video_path(conn, :index)
    assert html_response(conn, 200) =~ ~r/Listing videos/
    assert String.contains?(conn.resp_body, user_video.title)
    refute String.contains?(conn.resp_body, other_video.title)
  end

  @tag login_as: "max"
  test "created user video and redirects", %{conn: conn, user: user} do
    count_before = video_count(Video)
    conn = post conn, video_path(conn, :create), video: @valid_attrs
    assert redirected_to(conn) == video_path(conn, :show)
    assert Repo.get_by!(Video, @valid_attrs).user_id == user.id
  end
end













