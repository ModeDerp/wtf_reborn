defmodule Pluggy.School do
  defstruct(id: nil, name: "", img: "", about: "")

  alias Pluggy.School
  alias Pluggy.Group
  alias Pluggy.User

  def all() do
    Postgrex.query!(DB, "SELECT * FROM schools", [],
      pool: DBConnection.Poolboy
    ).rows
    |> to_struct_list
  end

  def create(params) do
    name = params["name"]
    img = params["img"]
    about = params["about"]

    Postgrex.query!(DB, "INSERT INTO schools(name, img, about) VALUES($1, $2, $3)", [name, img, about],
      pool: DBConnection.Poolboy)
  end

  def update(id, params) do
    name = params["name"]
    about = params["about"]
    _img = params["img"]
    id = String.to_integer(id)

    Postgrex.query!(
      DB,
      "UPDATE schools SET name = $1, about = $2 WHERE id = $3",
      [name, about, id],
      pool: DBConnection.Poolboy
    )
  end

  def add_teachers(school_id, params) do
    school = String.to_integer(school_id)
    teacher = String.to_integer(params["teacher_id"])

    Postgrex.query!(
      DB,
      "INSERT INTO user_school_relations (user_id, school_id) VALUES ($1, $2)",
      [teacher, school],
      pool: DBConnection.Poolboy
    )
  end

  def destroy_teachers(school_id, teacher_id) do
    school = String.to_integer(school_id)
    teacher = String.to_integer(teacher_id)

    Postgrex.query!(
      DB,
      "DELETE FROM user_school_relations WHERE school_id = $1 AND user_id = $2",
      [school, teacher],
      pool: DBConnection.Poolboy
    )
  end

  # def remove([]), do: {:ok, "Successfully deleted all groups"}
  # def remove([head | tail]) do
  #   remove(head)
  #   remove(tail)
  # end
  def remove(id) do
    Postgrex.query!(DB, "DELETE FROM schools WHERE id = $1", [id],
      pool: DBConnection.Poolboy)
  end

  def get(id) do
    Postgrex.query!(DB, "SELECT * FROM schools WHERE id = $1 LIMIT 1", [id],
      pool: DBConnection.Poolboy
    ).rows
    |> to_struct
  end

  def get_groups(%School{id: id}) do
    Postgrex.query!(DB, "SELECT * FROM groups WHERE school_id = $1;", [id],
      pool: DBConnection.Poolboy
      ).rows
    |> Group.to_struct_list
  end

  def get_teachers(%School{id: id}) do
    Postgrex.query!(DB, "SELECT u.id, u.username, u.permissions FROM users u
    INNER JOIN user_school_relations usr ON u.id = usr.user_id
    INNER JOIN schools s ON s.id = usr.school_id

    WHERE NOT permissions = 0 AND s.id = $1", [id],
    pool: DBConnection.Poolboy).rows
    |> User.to_struct_list
  end

  def to_struct([]), do: nil
  def to_struct([[id, name, img, about]]) do
    %School{id: id, name: name, img: img, about: about}
  end

  def to_struct_list(_, acc \\ [])
  def to_struct_list([], acc), do: Enum.reverse(acc)
  def to_struct_list([head | tail], acc), do: to_struct_list(tail, [to_struct([head]) | acc])
end
