class AddIdentifierToGenres < ActiveRecord::Migration[7.1]
  def change
    add_column :genres, :genre_identifier, :integer
  end
end
