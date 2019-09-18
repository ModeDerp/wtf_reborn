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
end
