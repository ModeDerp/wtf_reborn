defmodule Pluggy.StudentController do
  require IEx

  alias Pluggy.Student
  alias Pluggy.User
  alias Pluggy.UserController
  import Pluggy.Template, only: [srender: 2]
  import Plug.Conn, only: [send_resp: 3]

  def index(conn), do: send_resp(conn, 200, srender("students/index", user: UserController.getUser(conn), students: Student.all()))

  def new(conn), do: send_resp(conn, 200, srender("students/new", user: UserController.getUser(conn)))
  # def show(conn, id), do: send_resp(conn, 200, srender("fruits/show", fruit: Fruit.get(id)))
  def edit(conn, id), do: send_resp(conn, 200, srender("students/edit", user: UserController.getUser(conn), student: Student.get(id)))

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
    Student.update(id, params)
    redirect(conn, "/students")
  end

  def destroy(conn, id) do
    Student.delete(id)
    redirect(conn, "/fruits")
  end

  defp redirect(conn, url) do
    Plug.Conn.put_resp_header(conn, "location", url) |> send_resp(303, "")
  end
end
