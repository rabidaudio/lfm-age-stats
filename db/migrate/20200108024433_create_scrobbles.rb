class CreateScrobbles < ActiveRecord::Migration[6.0]
  def change
    create_table :scrobbles do |t|
      t.string :track
      t.string :artist
      t.string :album
      t.string :track_mbid
      t.string :artist_mbid
      t.string :album_mbid
      t.string :username
      t.datetime :scrobbled_at
      t.date :release_date

      t.timestamps
    end
    add_index :scrobbles, :username
    add_index :scrobbles, :scrobbled_at
    add_index :scrobbles, :release_date
  end
end
