defmodule Pluggy.StudentController do
  require IEx

  alias Pluggy.Student
  alias Pluggy.User
  import Pluggy.Template, only: [render: 2, srender: 2]
  import Plug.Conn, only: [send_resp: 3]

  def index(conn) do
    # get user if logged in
    session_user = conn.private.plug_session["user_id"]


    current_user =
      case session_user do
        nil -> nil
        _ -> User.get(session_user)
      end

    send_resp(conn, 200, srender("students/index", students: Student.all(), user: current_user))
  end

  def new(conn), do: send_resp(conn, 200, srender("students/new", []))
  # def show(conn, id), do: send_resp(conn, 200, srender("fruits/show", fruit: Fruit.get(id)))
  # def edit(conn, id), do: send_resp(conn, 200, srender("fruits/edit", fruit: Fruit.get(id)))

  def create(conn, params) do
    if params["first_name"] != "" && params["last_name"] != "" do
      params |> Student.create
      #move uploaded file from tmp-folder (might want to first check that a file was uploaded)
      if params["file"] do
        File.rename(params["file"].path, "priv/static/uploads/#{params["file"].filename}")
      end
      redirect(conn, "/students")
    else
      redirect(conn, "./new")
    end
  end

  @spec update(Plug.Conn.t(), any, any) :: Plug.Conn.t()
  def update(conn, id, params) do
    Fruit.update(id, params)
    redirect(conn, "/fruits")
  end

  def destroy(conn, id) do
    Fruit.delete(id)
    redirect(conn, "/fruits")
  end

  defp redirect(conn, url) do
    Plug.Conn.put_resp_header(conn, "location", url) |> send_resp(303, "")
  end
end
