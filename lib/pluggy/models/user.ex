defmodule Pluggy.User do
  defstruct(id: nil, username: "", permissions: nil)

  alias Pluggy.User

  def get(id) do
    Postgrex.query!(DB, "SELECT id, username, permissions FROM users WHERE id = $1 LIMIT 1", [id],
      pool: DBConnection.Poolboy
    ).rows
    |> to_struct
  end

  def to_struct([[id, username, permissions]]) do
    %User{id: id, username: username, permissions: permissions}
  end
end
