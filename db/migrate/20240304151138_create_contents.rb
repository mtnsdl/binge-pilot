class CreateContents < ActiveRecord::Migration[7.1]
  def change
    create_table :contents do |t|
      t.string :type
      t.string :name
      t.string :picture_url
      t.string :streaming_platform
      t.string :streaming_url

      t.timestamps
    end
  end
end
