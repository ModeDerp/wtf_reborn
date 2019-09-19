defmodule Pluggy.UserController do
  # import Pluggy.Template, only: [render: 2]
  import Plug.Conn, only: [send_resp: 3]

  alias Pluggy.User

  def new_teacher(conn), do: send_resp(conn, 200, Pluggy.Template.srender("teachers/new", user: getUser(conn)))

  def login(conn, params) do
    username = params["username"]
    password = params["pwd"]

    result =
      Postgrex.query!(DB, "SELECT id, password_hash FROM users WHERE username = $1", [username],
        pool: DBConnection.Poolboy
      )

    case result.num_rows do
      # no user with that username
      0 ->
        redirect(conn, "/")

      # user with that username exists
      _ ->
        [[id, password_hash]] = result.rows

        # make sure password is correct
        if Bcrypt.verify_pass(password, password_hash) do
          Plug.Conn.put_session(conn, :user_id, id)
          |> redirect("/")
        else
          redirect(conn, "/")
        end
    end
  end

  def logout(conn) do
    Plug.Conn.configure_session(conn, drop: true)
    |> redirect("/")
  end

  def create(conn, params, permission) do
  	#pseudocode
  	# in db table users with password_hash CHAR(60)
  	hashed_password = Bcrypt.hash_pwd_salt(params["password"])
   	Postgrex.query!(DB, "INSERT INTO users (username, password_hash, permissions) VALUES ($1, $2, $3)", [params["username"], hashed_password, permission], [pool: DBConnection.Poolboy])
   	redirect(conn, "/")
  end

  def getUser(conn) do
    # get user if logged in
    session_user = conn.private.plug_session["user_id"]
    case session_user do
      nil -> nil
      _ -> User.get(session_user)
    end
  end

  defp redirect(conn, url),
    do: Plug.Conn.put_resp_header(conn, "location", url) |> send_resp(303, "")
end
