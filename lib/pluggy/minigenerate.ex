defmodule Pluggy.Minigenerate do
  def fill_database() do
    Postgrex.query!(DB, "INSERT INTO students(first_name, last_name, img, about) VALUES($1, $2, $3, $4)", ["Chris", "McCoy", "/safe_man.png", "He is safely endangered!"], pool: DBConnection.Poolboy)
    Postgrex.query!(DB, "INSERT INTO students(first_name, last_name, img, about) VALUES($1, $2, $3, $4)", ["McChris", "McComb", "/safe_man.png", "He is safely endangered!"], pool: DBConnection.Poolboy)
    Postgrex.query!(DB, "INSERT INTO students(first_name, last_name, img, about) VALUES($1, $2, $3, $4)", ["Christoffer", "McCotton", "/safe_man.png", "He is safely endangered!"], pool: DBConnection.Poolboy)
    Postgrex.query!(DB, "INSERT INTO students(first_name, last_name, img, about) VALUES($1, $2, $3, $4)", ["Chrissy", "McCoyer", "/safe_man.png", "He is safely endangered!"], pool: DBConnection.Poolboy)

    Postgrex.query!(DB, "INSERT INTO groups(name, img, about) VALUES($1, $2, $3)", ["Safely endangered people", "/i_have_friends.png", "A fun group of people"], pool: DBConnection.Poolboy)
    Postgrex.query!(DB, "INSERT INTO groups(name, img, about) VALUES($1, $2, $3)", ["Boring old rags", "", "Pffft, they couldn't even afford an image... pity"], pool: DBConnection.Poolboy)
  end
end
