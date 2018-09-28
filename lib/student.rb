require 'pry'
require_relative "../config/environment.rb"

class Student

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]
  attr_accessor :name, :grade
  attr_reader :id

  def initialize(id = nil, name, grade)
    @name = name
    @grade = grade
    @id = id
  end

  def self.create_table
    sql = "CREATE TABLE students (
    id INTEGER PRIMARY KEY,
    name TEXT,
    grade INTEGER
    );"

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE students;"

    DB[:conn].execute(sql)
  end

  def save
    # new_student = Student.new(name, grade)
    # self.name
    # self.grade = grade
    if self.id
      self.update
      # sql = "UPDATE students SET name = ?, grade = ? WHERE ? = id"
      # DB[:conn].execute(sql, self.name, self.grade, self.id)
    else
      sql = "INSERT INTO students (name, grade) VALUES (?, ?);"
      DB[:conn].execute(sql, self.name, self.grade)

      sql2 = "SELECT last_insert_rowid() FROM students;"
      @id = DB[:conn].execute(sql2)[0][0]
    end
  end

  def self.create(name, grade)
    self.new(name, grade).save
  end

  def self.new_from_db(row)
    self.new(row[0], row[1], row[2])
  end

def self.find_by_name(name)
  sql = "SELECT * FROM students WHERE name = ?;"
  self.new_from_db(DB[:conn].execute(sql, name).first)
  # binding.pry
end

def update
  sql = "UPDATE students SET name = ?, grade = ? WHERE ? = id"
  DB[:conn].execute(sql, self.name, self.grade, self.id)
end

end
