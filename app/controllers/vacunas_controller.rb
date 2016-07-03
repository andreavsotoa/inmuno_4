class VacunasController < ApplicationController
  def crear_solicitud
    if current_usuario.frascos.blank?
      if current_usuario.tiene_todas_las_pruebas_alergicas?
        if pago_params[:pagar] == 1
          pago = Pago.new(pago_params)
          pago.usuarios_id = current_usuario.id
          pago.save!
        end

        current_usuario.estado = 'ACTIVO'
        flash[:notice] = 'Solicitud registrada'
        redirect_to vacunas_solicitar_path
      else
        flash[:notice] = 'Primero debe registrar sus alergias'
        redirect_to root_path
      end
    end
  end

  def listar
    @frascos = current_usuario.frascos
  end

  def pagar
  end

  def solicitar
    @pago = Pago.new
    unless current_usuario.tiene_todas_las_pruebas_alergicas?
      flash[:notice] = 'Primero debe registrar sus alergias'
      redirect_to root_path
    end
  end

  private

  def pago_params
    params.require(:pago).permit(:fecha_pago, :tipo_pago, :numero, :banco, :monto, :pagar)
  end
end
