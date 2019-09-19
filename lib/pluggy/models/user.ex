defmodule Pluggy.User do
  defstruct(id: nil, username: "", permissions: nil)

  alias Pluggy.User

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

  def to_struct([[id, username, permissions]]) do
    %User{id: id, username: username, permissions: permissions}
  end

  def to_struct_list(_, acc \\ [])
  def to_struct_list([], acc), do: Enum.reverse(acc)
  def to_struct_list([head | tail], acc), do: to_struct_list(tail, [to_struct([head]) | acc])
end
