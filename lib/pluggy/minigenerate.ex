defmodule Pluggy.Minigenerate do
  def fill_database() do
    Postgrex.query!(DB, "INSERT INTO students(first_name, last_name, img, about) VALUES($1, $2, $3, $4)", ["Chris", "McCoy", "/safe_man.png", "He is safely endangered!"], pool: DBConnection.Poolboy)
    Postgrex.query!(DB, "INSERT INTO students(first_name, last_name, img, about) VALUES($1, $2, $3, $4)", ["McChris", "McComb", "/safe_man.png", "He is safely endangered!"], pool: DBConnection.Poolboy)
    Postgrex.query!(DB, "INSERT INTO students(first_name, last_name, img, about) VALUES($1, $2, $3, $4)", ["Christoffer", "McCotton", "/safe_man.png", "He is safely endangered!"], pool: DBConnection.Poolboy)
    Postgrex.query!(DB, "INSERT INTO students(first_name, last_name, img, about) VALUES($1, $2, $3, $4)", ["Chrissy", "McCoyer", "/safe_man.png", "He is safely endangered!"], pool: DBConnection.Poolboy)

    Postgrex.query!(DB, "INSERT INTO groups(name, img, about) VALUES($1, $2, $3)", ["Safely endangered people", "/i_have_friends.png", "A fun group of people"], pool: DBConnection.Poolboy)
    Postgrex.query!(DB, "INSERT INTO groups(name, img, about) VALUES($1, $2, $3)", ["Boring old rags", "", "Pffft, they couldn't even afford an image... pity"], pool: DBConnection.Poolboy)

    Postgrex.query!(DB, "INSERT INTO student_group_relations(student_id, group_id) VALUES($1, $2)", [1, 1], pool: DBConnection.Poolboy)
    Postgrex.query!(DB, "INSERT INTO student_group_relations(student_id, group_id) VALUES($1, $2)", [2, 1], pool: DBConnection.Poolboy)
    Postgrex.query!(DB, "INSERT INTO student_group_relations(student_id, group_id) VALUES($1, $2)", [3, 1], pool: DBConnection.Poolboy)
    Postgrex.query!(DB, "INSERT INTO student_group_relations(student_id, group_id) VALUES($1, $2)", [4, 1], pool: DBConnection.Poolboy)

    Postgrex.query!(DB, "INSERT INTO users(username, password_hash, permissions) VALUES($1, $2, $3)", ["Daniel", Bcrypt.hash_pwd_salt("123"), 0], pool: DBConnection.Poolboy)
    Postgrex.query!(DB, "INSERT INTO users(username, password_hash, permissions) VALUES($1, $2, $3)", ["Harry Potter", Bcrypt.hash_pwd_salt("123"), 1], pool: DBConnection.Poolboy)
    Postgrex.query!(DB, "INSERT INTO users(username, password_hash, permissions) VALUES($1, $2, $3)", ["Ola", Bcrypt.hash_pwd_salt("123"), 1], pool: DBConnection.Poolboy)
    Postgrex.query!(DB, "INSERT INTO users(username, password_hash, permissions) VALUES($1, $2, $3)", ["Fredrik", Bcrypt.hash_pwd_salt("123"), 1], pool: DBConnection.Poolboy)
    Postgrex.query!(DB, "INSERT INTO users(username, password_hash, permissions) VALUES($1, $2, $3)", ["Bengt", Bcrypt.hash_pwd_salt("123"), 1], pool: DBConnection.Poolboy)


    Postgrex.query!(DB, "INSERT INTO schools(name, img, about) VALUES($1, $2, $3)", ["Hogwarts", "/hogwarts.png", "A very magical place"], pool: DBConnection.Poolboy)
    Postgrex.query!(DB, "INSERT INTO schools(name, img, about) VALUES($1, $2, $3)", ["NTI Johanneberg", "/nti.png", "A very technical place"], pool: DBConnection.Poolboy)

    Postgrex.query!(DB, "INSERT INTO user_school_relations(user_id, school_id) VALUES($1, $2)", [1, 1], pool: DBConnection.Poolboy)
    Postgrex.query!(DB, "INSERT INTO user_school_relations(user_id, school_id) VALUES($1, $2)", [2, 1], pool: DBConnection.Poolboy)
    Postgrex.query!(DB, "INSERT INTO user_school_relations(user_id, school_id) VALUES($1, $2)", [3, 2], pool: DBConnection.Poolboy)
    Postgrex.query!(DB, "INSERT INTO user_school_relations(user_id, school_id) VALUES($1, $2)", [4, 2], pool: DBConnection.Poolboy)
    Postgrex.query!(DB, "INSERT INTO user_school_relations(user_id, school_id) VALUES($1, $2)", [5, 2], pool: DBConnection.Poolboy)
  end
end
