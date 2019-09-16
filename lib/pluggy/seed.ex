defmodule Pluggy.Seed do
  def generate do
    dropTables()
    users()
    schools()
    userSchoolRelations()
    students()
    groups()
    studentGroupRelations()
  end

  def dropTables do
    Postgrex.query!(DB, "DROP TABLE if exists schools, users, groups, students, user_school_relations, student_group_relations", [], pool: DBConnection.Poolboy)
  end
  def users do
    Postgrex.query!(DB, "CREATE TABLE users (id SERIAL PRIMARY KEY, username VARCHAR(32), password_hash VARCHAR(64), permissions INTEGER)", [], pool: DBConnection.Poolboy)
  end

  @spec schools :: Postgrex.Result.t()
  def schools do
    Postgrex.query!(DB, "CREATE TABLE schools (id SERIAL PRIMARY KEY, name VARCHAR(32), img VARCHAR(64), about TEXT)", [], pool: DBConnection.Poolboy)
  end

  def userSchoolRelations do
    Postgrex.query!(DB, "CREATE TABLE user_school_relations (user_id INTEGER REFERENCES users(id), school_id INTEGER REFERENCES schools(id))", [], pool: DBConnection.Poolboy)
  end

  def students do
    Postgrex.query!(DB, "CREATE TABLE students (id SERIAL PRIMARY KEY, first_name VARCHAR(32), last_name VARCHAR(32), img VARCHAR(64), about TEXT)", [], pool: DBConnection.Poolboy)
  end

  def groups do
    Postgrex.query!(DB, "CREATE TABLE groups (id SERIAL PRIMARY KEY, school_id INTEGER REFERENCES schools(id), name VARCHAR(32), img VARCHAR(64), about TEXT)", [], pool: DBConnection.Poolboy)
  end

  def studentGroupRelations do
    Postgrex.query!(DB, "CREATE TABLE student_group_relations (student_id INTEGER REFERENCES students(id), group_id INTEGER REFERENCES groups(id))", [], pool: DBConnection.Poolboy)
  end

end
