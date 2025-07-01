class CreateCamions < ActiveRecord::Migration[8.0]
  def change
    create_table :camions do |t|
      t.string :posicion
      t.string :patente
      t.string :tipo
      t.string :lista
      t.string :conductor
      t.string :punto
      t.string :estado
      t.datetime :scraped_at

      t.timestamps
    end
  end
end
