class CreateProviders < ActiveRecord::Migration[7.1]
  def change
    create_table :providers do |t|
      t.string :streaming_platform
      t.string :streaming_url
      t.string :streaming_icon
      t.references :contents, null: false, foreign_key: true

      t.timestamps
    end
  end
end
