class AddIdToContents < ActiveRecord::Migration[7.1]
  def change
    add_column :contents, :content_identifier, :integer
    add_column :contents, :medium, :string
  end
end
