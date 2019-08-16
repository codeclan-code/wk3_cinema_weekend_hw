require_relative('../db/sql_runner')

class Film

  attr_reader :id
  attr_accessor :title, :price #Update

  def   initialize(options)
    @id = options['id'].to_i if options['id']
    @title = options['title']
    @price = options['price'].to_i
  end

  def save()
    sql = "INSERT INTO films (title, price)
    VALUES ($1, $2) RETURNING id"
    values = [@title, @price]
    film = SqlRunner.run(sql, values).first
    @id = film['id'].to_i
  end
  #
  def self.delete_all()
    sql = "DELETE FROM films"
    SqlRunner.run(sql)
  end

  def update()
    sql = "UPDATE films SET title = $1, price = $2 WHERE id = $3"
    values = [@title, @price, @id]
    SqlRunner.run( sql, values )
  end
  #
  def delete()
    sql = "DELETE FROM films WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def self.all()
    sql = "SELECT * FROM films"
    films = SqlRunner.run( sql )
    result = films.map { |film_hash| Film.new( film_hash ) }
    return result
  end

  def booked_customers
    sql = "SELECT customers.* FROM customers
    INNER JOIN tickets ON tickets.customer_id = customers.id
    WHERE film_id = $1"
    values = [@id]
    customers = SqlRunner.run(sql, values)
    result = customers.map { |customer| Customer.new(customer)  }
    return result
  end
  #
  #
  # def remaining_budget
  #   sql = "SELECT casting.* FROM casting
  #   INNER JOIN movies ON casting.movies_id = movies.id
  #   WHERE movies_id = $1 "
  #   values = [@id]
  #   casting_data = SqlRunner.run(sql, values)
  #   castings = casting_data.map { |casting| Casting.new(casting)  }
  #
  #   remaining_budget = @budget
  #   castings.each { |casting| remaining_budget -= casting.fee  }
  #   return remaining_budget
  # end

end
