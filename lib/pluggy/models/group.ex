defmodule Pluggy.Group do
  defstruct(id: nil, school_id: nil, name: "", img: "", about: "")

  alias Pluggy.Group

  def get(id) do
    Postgrex.query!(DB, "SELECT * FROM groups WHERE id = $1 LIMIT 1", [id],
      pool: DBConnection.Poolboy
    ).rows
    |> IO.inspect
    |> to_struct
  end

  def to_struct([[id, school_id, name, img, about]]) do
    %Group{id: id, school_id: school_id, name: name, img: img, about: about}
  end
  def to_struct([]), do: nil
end
