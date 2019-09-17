defmodule Pluggy.GroupController do
  require IEx

  alias Pluggy.Student
  alias Pluggy.Group
  alias Pluggy.User
  import Pluggy.Template, only: [render: 2, srender: 2]
  import Plug.Conn, only: [send_resp: 3]

  def index(conn, params) do
    # get user if logged in
    session_user = conn.private.plug_session["user_id"]

    current_user =
      case session_user do
        nil -> nil
        _ -> User.get(session_user)
      end


      #send_resp(conn, 200, srender("groups/group", user: %{id: 0, username: "", permissions: 0}, group: %Group{id: 0, name: "3B", img: "dank/img.png"}, students: [%{id: 10, first_name: "Daniel", last_name: "Kull"}]))
      send_resp(conn, 200, srender("groups/group", user: current_user, group: Group.get(params["id"]), students: [%{id: 10, first_name: "Daniel", last_name: "Kull"}]))
      #send_resp(conn, 200, srender("students/group", group: Group.get(params["id"]), user: current_user, students: Group.get_students(params["id"])))
  end
end
