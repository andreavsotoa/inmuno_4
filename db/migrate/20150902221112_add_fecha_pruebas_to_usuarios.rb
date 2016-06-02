class Addfecha_pruebasToUsuarios < ActiveRecord::Migration
  def change
    add_column :usuarios, :fecha_pruebas, :string
  end
end
