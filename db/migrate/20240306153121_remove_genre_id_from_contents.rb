class RemoveGenreIdFromContents < ActiveRecord::Migration[7.1]
  def change
    remove_reference :contents, :genre
  end
end
