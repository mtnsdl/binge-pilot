class CreateGenres < ActiveRecord::Migration[7.1]
  def change
    create_table :genres do |t|
      t.string :name
      t.references :mood, null: false, foreign_key: true

      t.timestamps
    end
  end
end
