class Album
  attr_reader :id, :artist_id
  attr_accessor :title, :genre

  def initialize(info)
    @id = info['id'].to_i if info['id']
    @title = info['title']
    @genre = info['genre']
    @artist_id = info['artist_id'].to_i if info['artist_id']
  end

  def save()
    sql = "INSERT INTO albums (title, genre, artist_id)
    VALUES ($1, $2, $3)
    RETURNING *"
    values =[@title, @genre, @artist_id]
    result = SqlRunner.run(sql, values)
    @id = result[0]['id'].to_i
  end

  def artist
    sql = "SELECT * FROM artists
    WHERE id = $1"
    values = [@artist_id]
    result = SqlRunner.run(sql, values)
    return result[0]
  end

  def update
    sql = "UPDATE albums
    SET title = $1
    WHERE id = $2 "
    values = [@title, @id]
    SqlRunner.run(sql, values)
  end

  def delete
    sql = "DELETE FROM albums
    WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end


  def self.delete_by_id(id)
    sql = "DELETE FROM albums
    WHERE id = $1"
    values = [id]
    SqlRunner.run(sql, values)
  end

  def self.delete_all
    sql = "DELETE FROM albums"
    SqlRunner.run(sql)
  end

  def self.find_by_id(wanted_id)
    sql ="SELECT * FROM albums
    WHERE id = $1"
    values = [wanted_id]
    result = SqlRunner.run(sql, values)

    if result.count > 0
      return result[0]
    else
      return nil
    end
  end

  def self.all()
    sql = "SELECT * FROM albums"
    albums = SqlRunner.run(sql)
    albums.map { |album| album }
  end




end
