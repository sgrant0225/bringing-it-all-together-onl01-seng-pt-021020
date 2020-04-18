require 'pry'

class Dog 
  
  attr_accessor :name, :breed 
  attr_reader :id
  
  def initialize(id: nil, name:, breed:)
    @name = name
    @breed = breed
  end  
  
  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS dogs (
        id INTEGER PRIMARY KEY,
        name TEXT,
        breed TEXT
        )
        SQL
        DB[:conn].execute(sql)
  end  
  
  def self.drop_table
   DB[:conn].execute("DROP TABLE IF EXISTS dogs;")
  end  
  
  def save
   if self.id == true
       update
    else
    sql = <<-SQL
      INSERT INTO dogs (name, breed)
      VALUES (?, ?)
    SQL
 
    DB[:conn].execute(sql, self.name, self.breed)
    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM dogs")[0][0]
   end
    self #returns an instance of the dog class
  end 
  
  def self.create(name:, breed:) 
   dog = Dog.new(name: name, breed: breed) 
   dog.save
   dog
  end  
  
 #this method convert what the database gives us into a object.we're reading data from SQLite and temporarily representing that data in Ruby
  def self.new_from_db(row)
    hash = {
      name: row[1],
      breed: row[2]
    }
    self.create(hash)
  end
  
  def self.find_by_id(id) #pass in the id_x parameter
    dog = DB[:conn].execute("select * from dogs where id = ?", id).first #pass it in here #.first pulls out the 1st element
    binding.pry
    dog = Dog.new(id: dog[0], name: dog[1], breed: dog[2])
  end  
  
  
  
  
end