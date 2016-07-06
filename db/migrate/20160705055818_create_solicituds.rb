class CreateSolicituds < ActiveRecord::Migration
  def change
    create_table :solicituds do |t|
      t.integer :numero_frasco
      t.string :tipo_solicitud
      t.text :comentario
      t.decimal :monto_pendiente
      t.integer :pago_id
      t.integer :usuario_id

      t.timestamps null: false
    end
  end
end
