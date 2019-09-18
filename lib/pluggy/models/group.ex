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

  def get(id) do
    Postgrex.query!(DB, "SELECT * FROM groups WHERE id = $1 LIMIT 1", [id],
      pool: DBConnection.Poolboy
    ).rows
    |> to_struct
  end

  def get_students(%Group{id: id}) do
    Postgrex.query!(DB, "SELECT students.id, first_name, last_name, students.about, students.img FROM groups JOIN student_group_relations ON group_id = groups.id JOIN students ON student_id = students.id WHERE groups.id = $1;", [id],
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
