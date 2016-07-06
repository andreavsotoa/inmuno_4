class AddBalanceToUsuarios < ActiveRecord::Migration
  def change
    add_column :usuarios, :balance, :decimal
  end
end
