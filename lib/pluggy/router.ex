defmodule Pluggy.Router do
  use Plug.Router

  alias Pluggy.School
  alias Pluggy.Group
  alias Pluggy.SchoolController
  alias Pluggy.StudentController
  alias Pluggy.UserController
  alias Pluggy.GroupController
  alias Pluggy.User

  plug(Plug.Static, at: "/", from: :pluggy)
  plug(:put_secret_key_base)

  plug(Plug.Session,
    store: :cookie,
    key: "_pluggy_session",
    encryption_salt: "cookie store encryption salt",
    signing_salt: "cookie store signing salt",
    key_length: 64,
    log: :debug,
    secret_key_base: "-- LONG STRING WITH AT LEAST 64 BYTES --"
  )

  plug(:fetch_session)
  plug(Plug.Parsers, parsers: [:urlencoded, :multipart])
  plug(:match)
  plug(:dispatch)

  get("/") do
    if getUser(conn) do
      handleRequest(conn, &SchoolController.index/1)
    else
      redirect(conn, "/login")
    end
  end

  get("json/:id", do: send_resp(conn, 200, Poison.encode!(Group.get_students(Group.get(String.to_integer(id))))))

  get("/groups", do: handleRequest(conn, &GroupController.index/1))
  get("/schools/:id/groups/new", do: GroupController.new(conn, id))
  get("/groups/:id", do: GroupController.show(conn, id))
  get("/schools/:school_id/groups/:group_id/edit", do: GroupController.edit(conn, school_id, group_id))
  get("/groups/:id/students/add", do: GroupController.add(conn,id))


  get("/login", do: send_resp(conn, 200, Pluggy.Template.srender("users/login")))
  # get("/students", do: handleRequest(conn, &StudentController.index/1, 0))
  get("/students/new", do: StudentController.new(conn))
  # get("/students/:id", do: StudentController.show(conn, id))
  get("/students/:id/edit", do: StudentController.edit(conn, id))
  get("/teachers/new", do: UserController.new_teacher(conn))
  get("/schools/:id/teachers/add", do: SchoolController.add(conn, id))
  get("/schools/new", do: SchoolController.new(conn))

  get("schools/:id", do: SchoolController.groups_admin(conn, id))
  get("/schools", do: SchoolController.index(conn))
  get("/schools/:id/edit", do: SchoolController.edit(conn, id))
  get("/schools/:school_id/groups/:group_id/quiz", do: send_resp(conn, 200, Pluggy.Template.srender("quiz/index", user: getUser(conn), school: School.get(String.to_integer(school_id)), group: Group.get(String.to_integer(group_id)))))

  post("/groups/:id/add", do: GroupController.add_students(conn, id, conn.body_params))
  post("/schools/:id/teachers/add", do: SchoolController.add_teachers(conn, id, conn.body_params))
  post("/schools/:id/groups/create", do: GroupController.create(conn, id, conn.body_params))
  post("/students/create", do: StudentController.create(conn, conn.body_params))
  post("/students/:id/edit", do: StudentController.update(conn, id, conn.body_params))
  post("/schools/:school_id/groups/:group_id/edit", do: GroupController.update(conn, school_id, group_id, conn.body_params))
  post("/groups/:id/students/:student/destroy", do: GroupController.destroy_students(conn, id, student))
  post("/schools/:school_id/groups/:group_id/destroy", do: GroupController.destroy_groups(conn, school_id, group_id))
  post("/schools/create", do: SchoolController.create(conn, conn.body_params))
  post("/schools/:id/edit", do: SchoolController.update(conn, id, conn.body_params))
  post("/schools/:id/destroy", do: SchoolController.destroy(conn, id))
  post("/schools/:school_id/teachers/:teacher_id/destroy", do: SchoolController.destroy_teachers(conn, school_id, teacher_id))

  post("/students/:id/destroy", do: StudentController.destroy(conn, id))

  post("/users/login", do: UserController.login(conn, conn.body_params))
  post "/users/create", do: UserController.create(conn, conn.body_params, 0)
  post("/teachers/create", do: UserController.create(conn, conn.body_params, 1))
  post("/users/logout", do: UserController.logout(conn))

  match _ do
    send_resp(conn, 404, "oops")
  end

  defp handleRequest(conn, f, req_perm \\ nil) do
    user = getUser(conn)
    case user do
      nil -> send_resp(conn, 200, Pluggy.Template.srender("users/login"))
      _ ->  if req_perm == nil do
              f.(conn)
            else
              permissions(conn, f, req_perm, user)
            end
    end
  end

  defp permissions(conn, f, req_perm, user) do
    if user.permissions <= req_perm do
      f.(conn)
    else
      send_resp(conn, 200, Pluggy.Template.srender("users/login"))
    end
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

  defp put_secret_key_base(conn, _) do
    put_in(
      conn.secret_key_base,
      "-- LONG STRING WITH AT LEAST 64 BYTES LONG STRING WITH AT LEAST 64 BYTES --"
    )
  end
end
