defmodule Pluggy.SchoolController do
  require IEx

  alias Pluggy.Group
  alias Pluggy.School
  alias Pluggy.User
  alias Pluggy.UserController

  import Pluggy.Template, only: [srender: 2]
  import Plug.Conn, only: [send_resp: 3]

  def index(conn) do
    user = UserController.getUser(conn)
    case user.permissions do
      0 -> send_resp(conn, 200, srender("schools/index", user: user, schools: School.all()))
      _ -> groups_teacher(conn)
    end
  end

  def groups_admin(conn, id) do
    school_id = String.to_integer(id)
    school = School.get(school_id)
    groups = School.get_groups(school)
    teachers = School.get_teachers(school)
    user = UserController.getUser(conn)

    send_resp(conn, 200, srender("groups/index", user: user, school: school, groups: groups, teachers: teachers))
  end

  def groups_teacher(conn) do
    user = UserController.getUser(conn)
    schools = User.get_schools(user)

    send_resp(conn, 200, srender("groups/teacher", user: user, school_groups: school_groups_list(schools)))
  end

  def school_groups_map(school), do: %{school: school, groups: School.get_groups(school)}
  def school_groups_list(list \\ [], acc \\ [])
  def school_groups_list([], acc), do: Enum.reverse(acc)
  def school_groups_list([head | tail], acc), do: school_groups_list(tail, [school_groups_map(head) | acc])

  def new(conn), do: send_resp(conn, 200, srender("schools/new", user: UserController.getUser(conn)))

  def edit(conn, id), do: send_resp(conn, 200, srender("schools/edit", user: UserController.getUser(conn), school: School.get(String.to_integer(id))))

  def add(conn, id), do: send_resp(conn, 200, srender("schools/add", user: UserController.getUser(conn), school: School.get(String.to_integer(id)), teachers: User.get_teachers()))

  def update(conn, id, params) do
    School.update(id, params)
    redirect(conn, "/schools")
  end

  def add_teachers(conn, school_id, params) do
    School.add_teachers(school_id, params)
    redirect(conn, "/schools/#{school_id}")
  end

  def destroy(conn, id) do
    School.destroy(id)
    redirect(conn, "/schools")
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

    send_resp(conn, 200, srender("groups/group", school: school_struct, user: UserController.getUser(conn), groups: group_structs))
  end

  defp redirect(conn, url) do
    Plug.Conn.put_resp_header(conn, "location", url) |> send_resp(303, "")
  end
end
