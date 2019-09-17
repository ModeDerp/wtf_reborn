defmodule Pluggy.Student do
  defstruct(id: nil, first_name: "")

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

  @spec get(any) :: Pluggy.Student.t()
  def get(id) do
    Postgrex.query!(DB, "SELECT * FROM students WHERE id = $1 LIMIT 1", [String.to_integer(id)],
      pool: DBConnection.Poolboy
    ).rows
    |> to_struct
  end

  def to_struct([[id, first_name]]) do
    %Student{id: id, first_name: first_name}
  end

  def to_struct_list(rows) do
    for [id, first_name] <- rows, do: %Student{id: id, first_name: first_name}
  end
end
