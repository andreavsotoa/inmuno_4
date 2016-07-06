class VacunasController < ApplicationController
  def crear_solicitud
    @solicitud = Solicitud.new(solicitud_params.except(:pago))
    @solicitud.monto_pendiente = Frasco.precio
    if @solicitud.tipo_solicitud == 'casoespecial'
      SolicitudMailer.solicitud_especial(@solicitud.comentario).deliver_now
    end

    if current_usuario.balance.present? && current_usuario.balance > @solicitud.monto_pendiente
      current_usuario.update_attribute(:balance, current_usuario.balance - @solicitud.monto_pendiente)
      @solicitud.monto_pendiente = 0
    elsif current_usuario.balance.present? && current_usuario.balance > 0
      @solicitud.monto_pendiente -= current_usuario.balance
      current_usuario.update_attribute(:balance, 0)
    end

    if @solicitud.pagar.present? && @solicitud.pagar == '1'
      @pago = Pago.new(solicitud_params[:pago])
      @pago.usuarios_id = current_usuario.id
      @solicitud.pago = @pago

      if @pago.monto > @solicitud.monto_pendiente
        current_usuario.update_attribute(:balance, @pago.monto - @solicitud.monto_pendiente)
        @solicitud.monto_pendiente = 0
      elsif @pago.monto <= @solicitud.monto_pendiente
        @solicitud.monto_pendiente -= @pago.monto
      end
    end

    success = true
    begin
      ActiveRecord::Base.transaction do
        @solicitud.save!
        @pago.save! if @pago.present?
      end
    rescue => e
      success = false
    end

    if success
      flash[:notice] = 'Solicitud registrada con éxito'
      redirect_to paciente_path
    else
      flash[:notice] = 'Su solicitud no pudo ser procesada'
      redirect_to vacunas_solicitar_path
    end
  end

  def listar
    @frascos = current_usuario.lista_frascos
  end

  def solicitar
    @solicitud = Solicitud.new
    unless current_usuario.tiene_todas_las_pruebas_alergicas?
      flash[:notice] = 'Primero debe registrar sus alergias'
      redirect_to root_path
    end
  end

  private

  def solicitud_params
    params.require(:solicitud).permit(
      :tipo_solicitud, :comentario, :pagar,
      pago: [:fecha_pago, :tipo_pago, :numero, :banco, :monto]
    )
  end
end
