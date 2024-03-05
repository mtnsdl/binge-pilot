class AddIdToContents < ActiveRecord::Migration[7.1]
  def change
    add_column :contents, :content_identifier, :integer
  end
end
