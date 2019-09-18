defmodule Pluggy.GroupController do
  require IEx

  alias Pluggy.Student
  alias Pluggy.Group
  alias Pluggy.User
  import Pluggy.Template, only: [render: 2, srender: 2]
  import Plug.Conn, only: [send_resp: 3]

  def index(conn) do
    session_user = conn.private.plug_session["user_id"]

    current_user =
      case session_user do
        nil -> nil
        _ -> User.get(session_user)
      end

      send_resp(conn, 200, srender("groups/index", user: current_user, groups: Group.all()))
  end

  def new(conn), do: send_resp(conn, 200, srender("groups/new", []))

  def edit(conn, id), do: send_resp(conn, 200, srender("groups/edit", group: Group.get(String.to_integer(id))))

  def add(conn, id), do: send_resp(conn, 200, srender("groups/add", students: Student.all(), group: Group.get(String.to_integer(id))))

  def update(conn, id, params) do
    Group.update(id, params)
    redirect(conn, "/groups")
  end

  def add_students(conn, group_id, params) do
    Group.add_students(group_id, params)
    redirect(conn, "/group/#{group_id}")
  end

  def create(conn, params) do
    if params["name"] != "" do
      params |> Group.create
      #move uploaded file from tmp-folder (might want to first check that a file was uploaded)
      if params["file"] do
        File.rename(params["file"].path, "priv/static/uploads/#{params["file"].filename}")
      end
      redirect(conn, "/groups")
    else
      redirect(conn, "./new")
    end
  end

  def show(conn, id) do
    # get user if logged in
    session_user = conn.private.plug_session["user_id"]

    current_user =
      case session_user do
        nil -> nil
        _ -> User.get(session_user)
      end
    group_struct = Group.get(String.to_integer(id))
    student_structs = Group.get_students(Group.get(String.to_integer(id)))
    IO.inspect(current_user)
    IO.inspect(group_struct)
    IO.inspect(student_structs)

    send_resp(conn, 200, srender("groups/group", group: group_struct, user: current_user, students: student_structs))
  end

  defp redirect(conn, url) do
    Plug.Conn.put_resp_header(conn, "location", url) |> send_resp(303, "")
  end
end
