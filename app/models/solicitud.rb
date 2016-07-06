class Solicitud < ActiveRecord::Base
  attr_accessor :pagar

  belongs_to :usuario
  belongs_to :pago
end
