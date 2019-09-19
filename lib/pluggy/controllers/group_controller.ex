defmodule Pluggy.GroupController do
  require IEx

  alias Pluggy.Student
  alias Pluggy.Group
  alias Pluggy.School
  alias Pluggy.UserController
  import Pluggy.Template, only: [srender: 2]
  import Plug.Conn, only: [send_resp: 3]

  def index(conn), do: send_resp(conn, 200, srender("groups/index", user: UserController.getUser(conn), groups: Group.all()))

  def new(conn), do: send_resp(conn, 200, srender("groups/new", user: UserController.getUser(conn)))
  def new(conn, id), do: send_resp(conn, 200, srender("groups/new", user: UserController.getUser(conn), school: School.get(String.to_integer(id))))

  def edit(conn, school_id, group_id), do: send_resp(conn, 200, srender("groups/edit", user: UserController.getUser(conn), group: Group.get(String.to_integer(group_id)), school: School.get(String.to_integer(school_id))))

  def add(conn, id), do: send_resp(conn, 200, srender("groups/add", user: UserController.getUser(conn), students: Student.all(), group: Group.get(String.to_integer(id))))

  def update(conn, school_id, group_id, params) do
    Group.update(group_id, params)
    redirect(conn, "/schools/#{school_id}")
  end

  def add_students(conn, group_id, params) do
    Group.add_students(group_id, params)
    redirect(conn, "/groups/#{group_id}")
  end

  def destroy_students(conn, group_id, student_id) do
    Group.destroy_students(group_id, student_id)
    redirect(conn, "/groups/#{group_id}")
  end

  def destroy_groups(conn, school_id, group_id) do
    Group.destroy_groups(group_id)
    redirect(conn, "/schools/#{school_id}")
  end

  def create(conn, id, params) do
    if params["name"] != "" do
      Group.create(id, params)
      #move uploaded file from tmp-folder (might want to first check that a file was uploaded)
      if params["file"] do
        File.rename(params["file"].path, "priv/static/uploads/#{params["file"].filename}")
      end
      redirect(conn, "/schools/#{id}")
    else
      redirect(conn, "./new")
    end
  end

  def show(conn, id) do
    group_struct = Group.get(String.to_integer(id))
    student_structs = Group.get_students(Group.get(String.to_integer(id)))

    send_resp(conn, 200, srender("groups/group", group: group_struct, user: UserController.getUser(conn), students: student_structs))
  end

  defp redirect(conn, url) do
    Plug.Conn.put_resp_header(conn, "location", url) |> send_resp(303, "")
  end
end
