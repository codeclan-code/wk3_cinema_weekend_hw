require_relative('../db/sql_runner')

class Casting

  attr_reader :id, :movies_id, :stars_id, :fee

  def   initialize(options)
    @id = options['id'].to_i if options['id']
    @movies_id = options['movies_id']
    @stars_id = options['stars_id']
    @fee = options['fee'].to_i
  end

  def save()
    sql = "INSERT INTO casting (movies_id, stars_id, fee)
    VALUES ($1, $2, $3) RETURNING id"
    values = [@movies_id, @stars_id, @fee]
    casting = SqlRunner.run(sql, values).first
    @id = casting['id'].to_i
  end

  def self.delete_all()
    sql = "DELETE FROM casting"
    SqlRunner.run(sql)
  end

end
