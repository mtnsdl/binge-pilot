class AddFormatToGenres < ActiveRecord::Migration[7.1]
  def change
    add_column :genres, :genre_format, :string
  end
end
