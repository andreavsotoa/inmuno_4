class Pago < ActiveRecord::Base
  before_save :revisar_banco

  def revisar_banco
    self.banco = nil if self.tipo_pago != 1
  end
end
