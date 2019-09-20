defmodule Pluggy.Student do
  defstruct(id: nil, first_name: "", last_name: "", img: nil, about: "")

  alias Pluggy.Student

  def all do
    Postgrex.query!(DB, "SELECT * FROM students", [], pool: DBConnection.Poolboy).rows
    |> to_struct_list
  end

  def create(params) do
    first_name = params["first_name"]
    last_name = params["last_name"]
    about = params["about"]
    img = params["img"]

    Postgrex.query!(DB, "INSERT INTO students (first_name, last_name, about, img) VALUES ($1, $2, $3, $4)", [first_name, last_name, about, img],
      pool: DBConnection.Poolboy
    )
  end

  def update(id, params) do
    first_name = params["first_name"]
    last_name = params["last_name"]
    about = params["about"]
    _img = params["img"]
    id = String.to_integer(id)

    Postgrex.query!(
      DB,
      "UPDATE students SET first_name = $1, last_name = $2, about = $3 WHERE id = $4",
      [first_name, last_name, about, id],
      pool: DBConnection.Poolboy
    )
  end

  @spec get(any) :: Pluggy.Student.t()
  def get(id) do
    Postgrex.query!(DB, "SELECT * FROM students WHERE id = $1 LIMIT 1", [String.to_integer(id)],
      pool: DBConnection.Poolboy
    ).rows
    |> to_struct
  end

  def delete(student_id) do
    student = String.to_integer(student_id)

    Postgrex.query!(
      DB,
      "DELETE FROM student_group_relations WHERE student_id = $1",
      [student],
      pool: DBConnection.Poolboy
    )

    Postgrex.query!(
      DB,
      "DELETE FROM students WHERE id = $1" ,
      [student],
      pool: DBConnection.Poolboy
    )

  end

  def to_struct([[id, first_name, last_name, img, about]]) do
    %Student{id: id, first_name: first_name, last_name: last_name, img: img, about: about}
  end

  def to_struct_list(_, acc \\ [])
  def to_struct_list([], acc), do: Enum.reverse(acc)
  def to_struct_list([head | tail], acc), do: to_struct_list(tail, [to_struct([head]) | acc])
end
