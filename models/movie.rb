require_relative('../db/sql_runner')
require_relative('./star')
require_relative('./casting')

class Movie

  attr_reader :id, :title, :genre, :budget

  def   initialize(options)
    @id = options['id'].to_i if options['id']
    @title = options['title']
    @genre = options['genre']
    @budget = options['budget'].to_i
  end

  def save()
    sql = "INSERT INTO movies (title, genre, budget)
    VALUES ($1, $2, $3) RETURNING id"
    values = [@title, @genre, @budget]
    movie = SqlRunner.run(sql, values).first
    @id = movie['id'].to_i
  end

  def self.delete_all()
    sql = "DELETE FROM movies"
    SqlRunner.run(sql)
  end

  def stars
    sql = "SELECT stars.* FROM stars
    INNER JOIN casting ON casting.stars_id = stars.id
    WHERE movies_id = $1 "
    values = [@id]
    stars = SqlRunner.run(sql, values)
    result = stars.map { |star| Star.new(star)  }
    return result
  end

  def remaining_budget
    sql = "SELECT casting.* FROM casting
    INNER JOIN movies ON casting.movies_id = movies.id
    WHERE movies_id = $1 "
    values = [@id]
    casting_data = SqlRunner.run(sql, values)
    castings = casting_data.map { |casting| Casting.new(casting)  }

    remaining_budget = @budget
    castings.each { |casting| remaining_budget -= casting.fee  }
    return remaining_budget
  end

end
