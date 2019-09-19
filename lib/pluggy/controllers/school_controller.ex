defmodule Pluggy.SchoolController do
  require IEx

  alias Pluggy.Group
  alias Pluggy.School
  alias Pluggy.User

  import Pluggy.Template, only: [srender: 2]
  import Plug.Conn, only: [send_resp: 3]

  def index(conn), do: send_resp(conn, 200, srender("schools/index", user: getUser(conn), schools: School.all()))

  def new(conn), do: send_resp(conn, 200, srender("schools/new", user: getUser(conn)))

  def edit(conn, id), do: send_resp(conn, 200, srender("schools/edit", user: getUser(conn), school: School.get(String.to_integer(id))))

  def add(conn, id), do: send_resp(conn, 200, srender("schools/add", user: getUser(conn), teachers: User.getAllTeachers()))

  def update(conn, id, params) do
    School.update(id, params)
    redirect(conn, "/schools")
  end

  def add_teachers(conn, school_id, params) do
    School.add_teachers(school_id, params)
    redirect(conn, "/schools/#{school_id}")
  end

  def destroy_teachers(conn, school_id, teacher_id) do
    School.destroy_teachers(school_id, teacher_id)
    redirect(conn, "/schools/#{school_id}")
  end

  def create(conn, params) do
    if params["name"] != "" do
      params |> School.create
      #move uploaded file from tmp-folder (might want to first check that a file was uploaded)
      if params["file"] do
        File.rename(params["file"].path, "priv/static/uploads/#{params["file"].filename}")
      end
      redirect(conn, "/schools")
    else
      redirect(conn, "./new")
    end
  end

  def show(conn, id) do
    school_struct = School.get(String.to_integer(id))
    group_structs = Group.get(String.to_integer(id))

    send_resp(conn, 200, srender("groups/group", school: school_struct, user: getUser(conn), groups: group_structs))
  end

  defp getUser(conn) do
    # get user if logged in
    session_user = conn.private.plug_session["user_id"]
    case session_user do
      nil -> nil
      _ -> User.get(session_user)
    end
  end

  defp redirect(conn, url) do
    Plug.Conn.put_resp_header(conn, "location", url) |> send_resp(303, "")
  end
end
