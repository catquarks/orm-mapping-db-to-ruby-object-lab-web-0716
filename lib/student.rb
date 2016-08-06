class Student
  attr_accessor :id, :name, :grade

  def initialize(options = [id=nil, name=nil, grade=nil])
    @id = options[0]
    @name = options[1]
    @grade = options[2]
  end

  def self.new_from_db(row)
    student = self.new
    student.id = row[0]
    student.name = row[1]
    student.grade = row[2]
    student
  end

  def self.all
    sql = 'SELECT * FROM students'
    results = DB[:conn].execute(sql)
    student = self.new
    results.collect do |result|
      self.new(result)
    end

  end

  def self.first_x_students_in_grade_10(x)
    sql = 'SELECT * FROM students WHERE grade = 10 LIMIT (?)'
    results = DB[:conn].execute(sql, x)
    results    
  end

  def self.first_student_in_grade_10
    sql = 'SELECT * FROM students WHERE grade = 10 LIMIT 1'
    results = DB[:conn].execute(sql)
    self.new(results.first)
  end

  def self.count_all_students_in_grade_9
    sql = 'SELECT COUNT(*) FROM students WHERE grade = 9'
    results = DB[:conn].execute(sql)
    results
  end

  def self.all_students_in_grade_X(x)
    sql = 'SELECT * FROM students WHERE grade = (?)'
    results = DB[:conn].execute(sql,x)
    results
  end

  def self.students_below_12th_grade
    sql = 'SELECT COUNT(*) FROM students WHERE grade < 12'
    results = DB[:conn].execute(sql)
    results
  end

  def self.find_by_name(name)
    sql = 'SELECT * FROM students WHERE name = (?)'
    result = DB[:conn].execute(sql, name)
    student = self.new
    student.id = result.first[0]
    student.name = result.first[1]
    student.grade = result.first[2]
    student
  end
  
  def save
    sql = <<-SQL
      INSERT INTO students (name, grade) 
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end
  
  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end
end
