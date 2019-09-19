defmodule Pluggy.User do
  defstruct(id: nil, username: "", permissions: nil)

  alias Pluggy.User
  alias Pluggy.School

  def get(id) do
    Postgrex.query!(DB, "SELECT id, username, permissions FROM users WHERE id = $1 LIMIT 1", [id],
      pool: DBConnection.Poolboy
    ).rows
    |> to_struct
  end

  def get_teachers() do
    Postgrex.query!(DB, "SELECT id, username, permissions FROM users WHERE permissions != 0", [],
      pool: DBConnection.Poolboy
    ).rows
    |> to_struct_list
  end

  def get_schools(%User{id: id}) do
    Postgrex.query!(DB, "SELECT s.id, s.name, s.img, s.about FROM users u
    INNER JOIN user_school_relations usr ON u.id = usr.user_id
    INNER JOIN schools s ON s.id = usr.school_id

    WHERE u.id = $1", [id],
      pool: DBConnection.Poolboy
    ).rows
    |> School.to_struct_list
  end

  def to_struct([[id, username, permissions]]) do
    %User{id: id, username: username, permissions: permissions}
  end

  def to_struct_list(_, acc \\ [])
  def to_struct_list([], acc), do: Enum.reverse(acc)
  def to_struct_list([head | tail], acc), do: to_struct_list(tail, [to_struct([head]) | acc])
end
