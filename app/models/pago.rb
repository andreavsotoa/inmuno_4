class Pago < ActiveRecord::Base
  before_save :revisar_banco
  belongs_to :usuario
  has_one :solicitud

  def revisar_banco
    self.banco = nil if self.tipo_pago != 1
  end
end
