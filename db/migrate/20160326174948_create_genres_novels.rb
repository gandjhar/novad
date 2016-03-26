class CreateGenresNovels < ActiveRecord::Migration
  def change
    create_table :genres_novels do |t|
      t.references :genre, index: true, foreign_key: true
      t.references :novel, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
