class AddApiIdToContents < ActiveRecord::Migration[7.1]
  def change
    add_column :contents, :api_id, :string
  end
end
