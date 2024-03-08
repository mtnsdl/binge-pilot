class AddOfferedAttributeToBookmarks < ActiveRecord::Migration[7.1]
  def change
    add_column :bookmarks, :offered, :boolean, default: false
  end
end
