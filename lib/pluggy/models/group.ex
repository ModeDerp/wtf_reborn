defmodule Pluggy.Group do
  defstruct(id: nil, school_id: nil, name: "", img: "", about: "")

  alias Pluggy.Group
  alias Pluggy.Student

  def all() do
    Postgrex.query!(DB, "SELECT * FROM groups", [],
      pool: DBConnection.Poolboy
    ).rows
    |> to_struct_list
  end

  def create(school_id, params) do
    school_id = String.to_integer(school_id)
    name = params["name"]
    img = params["img"]
    about = params["about"]

    Postgrex.query!(DB, "INSERT INTO groups(name, img, about, school_id) VALUES($1, $2, $3, $4)", [name, img, about, school_id],
      pool: DBConnection.Poolboy)
  end

  def update(id, params) do
    name = params["name"]
    about = params["about"]
    _img = params["img"]
    id = String.to_integer(id)

    Postgrex.query!(
      DB,
      "UPDATE groups SET name = $1, about = $2 WHERE id = $3",
      [name, about, id],
      pool: DBConnection.Poolboy
    )
  end

  def add_students(group_id, params) do
    group = String.to_integer(group_id)
    student = String.to_integer(params["student_id"])

    Postgrex.query!(
      DB,
      "INSERT INTO student_group_relations (student_id, group_id) VALUES ($1, $2)",
      [student, group],
      pool: DBConnection.Poolboy
    )
  end

  def destroy_students(group_id, student_id) do
    group = String.to_integer(group_id)
    student = String.to_integer(student_id)

    Postgrex.query!(
      DB,
      "DELETE FROM student_group_relations WHERE group_id = $1 AND student_id = $2",
      [group, student],
      pool: DBConnection.Poolboy
    )
  end

  def destroy_groups(group_id) do
    group = String.to_integer(group_id)

    Postgrex.query!(
      DB,
      "DELETE FROM student_group_relations WHERE group_id = $1",
      [group],
      pool: DBConnection.Poolboy
    )

    Postgrex.query!(
      DB,
      "DELETE FROM groups WHERE id = $1" ,
      [group],
      pool: DBConnection.Poolboy
    )

  end

  def remove([]), do: {:ok, "Successfully deleted all groups"}
  def remove([head | tail]) do
    remove(head)
    remove(tail)
  end
  def remove(id) do
    Postgrex.query!(DB, "DELETE FROM groups WHERE id = $1", [id],
      pool: DBConnection.Poolboy)
  end

  def get(id) do
    Postgrex.query!(DB, "SELECT * FROM groups WHERE id = $1 LIMIT 1", [id],
      pool: DBConnection.Poolboy
    ).rows
    |> to_struct
  end

  def get_students(%Group{id: id}) do
    Postgrex.query!(DB, "SELECT students.id, first_name, last_name, students.img, students.about FROM groups JOIN student_group_relations ON group_id = groups.id JOIN students ON student_id = students.id WHERE groups.id = $1;", [id],
      pool: DBConnection.Poolboy
      ).rows
    |> Student.to_struct_list
  end

  def to_struct([]), do: nil
  def to_struct([[id, school_id, name, img, about]]) do
    %Group{id: id, school_id: school_id, name: name, img: img, about: about}
  end

  def to_struct_list(_, acc \\ [])
  def to_struct_list([], acc), do: Enum.reverse(acc)
  def to_struct_list([head | tail], acc), do: to_struct_list(tail, [to_struct([head]) | acc])
end
