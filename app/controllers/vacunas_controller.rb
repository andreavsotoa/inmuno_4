class VacunasController < ApplicationController
  def listar
    @frascos = current_usuario.frascos
  end

  def solicitar
    unless current_usuario.tiene_todas_las_pruebas_alergicas?
      flash[:notice] = 'Primero debe registrar sus alergias'
      redirect_to root_path
    end

    
  end

  def pagar
  end
end
