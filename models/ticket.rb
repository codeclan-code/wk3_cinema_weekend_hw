require_relative('../db/sql_runner')
# v1
class Ticket

  attr_reader :id, :film_id, :customer_id

  def   initialize(options)
    @id = options['id'].to_i if options['id']
    @film_id = options['film_id'].to_i
    @customer_id = options['customer_id'].to_i
  end

  def save()
    sql = "INSERT INTO tickets (film_id, customer_id)
    VALUES ($1, $2) RETURNING id"
    values = [@film_id, @customer_id]
    ticket = SqlRunner.run(sql, values).first
    @id = ticket['id'].to_i
  end

  def self.delete_all()
    sql = "DELETE FROM tickets"
    SqlRunner.run(sql)
  end

  def update()
    sql = "UPDATE tickets SET film_id = $1, customer_id = $2 WHERE id = $3"
    values = [@film_id, @customer_id, @id]
    SqlRunner.run( sql, values )
  end
  #
  def delete()
    sql = "DELETE FROM tickets WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def self.all()
    sql = "SELECT * FROM tickets"
    tickets = SqlRunner.run( sql )
    result = tickets.map { |ticket_hash| Ticket.new( ticket_hash ) }
    return result
  end

end
