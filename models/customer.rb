require_relative('../db/sql_runner')
require_relative('./film')
require_relative('./ticket')
# v1

class Customer

  attr_reader :id, :sql
  attr_accessor :name, :funds, :tickets #Update

  def   initialize(options)
    @id = options['id'].to_i if options['id']
    @name = options['name']
    @funds = options['funds'].to_i
    @tickets = tickets.to_i
    @sql = "SELECT films.* FROM films
    INNER JOIN tickets ON tickets.film_id = films.id
    WHERE customer_id = $1"
  end

  def save()
    sql = "INSERT INTO customers (name, funds)
    VALUES ($1, $2) RETURNING id"
    values = [@name, @funds]
    customer = SqlRunner.run(sql, values).first
    @id = customer['id'].to_i
  end

  def self.delete_all()
    sql = "DELETE FROM customers"
    SqlRunner.run(sql)
  end

  def update()
    sql = "UPDATE customers SET name = $1, funds = $2 WHERE id = $3"
    values = [@name, @funds, @id]
    SqlRunner.run( sql, values )
  end
  #
  def delete()
    sql = "DELETE FROM customers WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def self.all()
    sql = "SELECT * FROM customers"
    customers = SqlRunner.run( sql )
    result = customers.map { |customer_hash| Customer.new( customer_hash ) }
    return result
  end

  # def booked_films
  def films
    @sql #What about this?
    values = [@id]
    films = SqlRunner.run(sql, values)
    result = films.map{ |film| Film.new(film)}
    result.each { |film| p "#{film.title}"}
  end

  # def remaining_funds
  def funds
    @sql  #What about this?
    values = [@id]
    film_data = SqlRunner.run(sql, values)
    films = film_data.map {|film| Film.new(film)}
    remaining_funds = 100 #@funds
    films.each { |film| remaining_funds -= film.price}
    return @funds = remaining_funds
  end

  # def bought_tickets -d
  def tickets
    sql = "SELECT films.* FROM films
    INNER JOIN tickets ON tickets.film_id = films.id
    WHERE tickets.customer_id = $1"
    values = [@id]
    film_data = SqlRunner.run(sql, values)
    films = film_data.map {|film| Film.new(film)}
    tickets = films.count
    puts "Customer has #{tickets} ticket(s)"
  end

end
