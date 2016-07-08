
# Devise:: le estamos indicando que herede de devise.
#no se va a escribir el código del controlador de devise sino que vamos a modificar #solamente lo que el padre (devise) haría.
#luego es nesario que el router se modifique para que utilice el nuevo controlador

class RegistrationsController < Devise::RegistrationsController
prepend_before_filter :require_no_authentication, only: [ :cancel]
prepend_before_filter :authenticate_scope!, only: [:edit, :update, :destroy]
skip_before_filter :require_no_authentication, :only => [:create, :update]
before_action :cargarOpcionesDelPrincipal
require 'date'
require 'will_paginate/array'

include CodigosGenerales
layout :colocar_layout

def index
  @pacientes = Usuario.where(rol: 3)
end 

def new
  @numero_paciente = Usuario.last.numero_excel.to_i + 1

	super

#  @paciente.numero_excel = Usuario.last.numero_excel
end

def edit
  #if !params[:format].blank?
  #  @paciente = Usuario.find( params[:format])
  #  build_resource({})
  #  self.resource = @paciente
  #  render editPaciente 
  #else
    render :edit
  #end
end 

def editPaciente
  @paciente = Usuario.find(params[:id])
  build_resource({})
  self.resource = @paciente
  #render :editPaciente 
end

def editPrueba
  puts "ESTOY EN EDIT PRUEBA"
  @paciente = Usuario.find(params[:id])
  #puts @paciente
  #puts "FRASCOS"
  build_resource({})
  self.resource = @paciente
  #render :editPaciente  
end

def showFrascos
  puts "ESTOY EN SHOW FRASCOS"
  @paciente = Usuario.find(params[:id])
  puts "FRASCOS DEL PACIENTE"
  puts @paciente.frascos
  # EN @FRASCO ESTAN TANTOS STRINGS COMO FRASCOS TIENE EL PACIENTE
  @hash_frascos = {}
  if @paciente.frascos != nil
  lista_frascos = @paciente.frascos.split('$')
  puts lista_frascos
  lista_frascos.each do |frasco,i|
    detalle_frasco = frasco.split('#')

    puts detalle_frasco[2]

    if detalle_frasco[2].to_s[0] != 'S' and detalle_frasco[2].to_s[0] != 'N' and detalle_frasco[2].to_s[0] != 'R' 
      fecha_ret = cambiar_formato_fecha(detalle_frasco[2].to_s)
    else
      fecha_ret = detalle_frasco[2].to_s
    end


    fecha_sol = cambiar_formato_fecha(detalle_frasco[1].to_s)

    detalle = {:fecha_solicitud => fecha_sol,:fecha_retiro => fecha_ret}
    num_frasco = detalle_frasco[0]
    if num_frasco != nil
      @hash_frascos[num_frasco.to_s] = detalle
    end
  end
  #@hash_frascos.keys.paginate(page: params[:page],per_page: 2)
  @hash_original = @hash_frascos
  puts "POS 1"
  puts @hash_original["1"][:fecha_solicitud]

  @hash_frascos = @hash_frascos.keys.paginate(page: params[:page],per_page: 5)
  #puts @hash_frascos
  build_resource({})
  self.resource = @paciente
end
end

def showFrascosPaciente
  puts "ESTOY EN SHOW FRASCOS"
  @paciente = Usuario.find(params[:id])
  puts "FRASCOS DEL PACIENTE"
  puts @paciente.frascos
  # EN @FRASCO ESTAN TANTOS STRINGS COMO FRASCOS TIENE EL PACIENTE
  @hash_frascos = {}
  if @paciente.frascos != nil
  lista_frascos = @paciente.frascos.split('$')
  puts lista_frascos
  lista_frascos.each do |frasco,i|
    detalle_frasco = frasco.split('#')

    puts detalle_frasco[2]

    if detalle_frasco[2].to_s[0] != 'S' and detalle_frasco[2].to_s[0] != 'N' and detalle_frasco[2].to_s[0] != 'R' 
      fecha_ret = cambiar_formato_fecha(detalle_frasco[2].to_s)
    else
      fecha_ret = detalle_frasco[2].to_s
    end


    fecha_sol = cambiar_formato_fecha(detalle_frasco[1].to_s)

    detalle = {:fecha_solicitud => fecha_sol,:fecha_retiro => fecha_ret}
    num_frasco = detalle_frasco[0]
    if num_frasco != nil
      @hash_frascos[num_frasco.to_s] = detalle
    end
  end
  #@hash_frascos.keys.paginate(page: params[:page],per_page: 2)
  @hash_original = @hash_frascos
  puts "POS 1"
  puts @hash_original["1"][:fecha_solicitud]

  @hash_frascos = @hash_frascos.keys.paginate(page: params[:page],per_page: 5)
  #puts @hash_frascos
  build_resource({})
  self.resource = @paciente
end
end

def update
  puts "UPDATE"
  puts params[:usuario][:id]
  puts "OCULTO"
  puts params[:usuario][:origen]
  if "editPrueba".eql? params[:usuario][:origen]
    puts "CAI EN EL IF"
     @paciente = Usuario.find(params[:usuario][:id])
  if @paciente != current_usuario
    @numero_paciente = Usuario.last.numero_excel.to_i + 1
    #estado = 1 PENDIENTE
    params[:usuario][:estado] = 1
    if params[:usuario][:ava].blank? and 
      params[:usuario][:cuc].blank? and 
      params[:usuario][:hong].blank? and 
      params[:usuario][:berm].blank? and
      params[:usuario][:john].blank? and
      params[:usuario][:aso].blank? and
      params[:usuario][:blom].blank?  
      params[:usuario][:fecha_pruebas] = nil     
    end

    @paciente = Usuario.find(params[:usuario][:id])
    self.resource = @paciente
    self.resource.saltar_validacion_fecha_nacimiento = false
    self.resource.validar_usuario_nuevo = false
    self.resource.saltar_validacion_correo_principal = false

  if self.resource.update_without_password(pruebas_update_params)
        flash.now[:notice] = "Las pruebas alérgicas del paciente fueron modificadas correctamente"
        #redirect_to usuario_registration_pruebas_path(@paciente.id)
        render :showPruebas
        #format.json { head :no_content }
      else
        #format.html { render :editPaciente }
        puts "ELSE DEL IF"
        render :editPrueba
        #format.json { render json: @paciente.errors, status: :unprocessable_entity }
      end
    #end
    

  end 
  else
  @paciente = Usuario.find(params[:usuario][:id])
  if @paciente != current_usuario
    @numero_paciente = Usuario.last.numero_excel.to_i + 1
    #estado = 1 PENDIENTE
    params[:usuario][:estado] = 1
    if params[:usuario][:ava].blank? and 
      params[:usuario][:cuc].blank? and 
      params[:usuario][:hong].blank? and 
      params[:usuario][:berm].blank? and
      params[:usuario][:john].blank? and
      params[:usuario][:aso].blank? and
      params[:usuario][:blom].blank?  
      params[:usuario][:fecha_pruebas] = nil     
    end
    
    if account_update_params[:password].blank?
      account_update_params.delete(:password)
      account_update_params.delete(:password_confirmation)
    end
    
    @paciente = Usuario.find(params[:usuario][:id])
    self.resource = @paciente
    self.resource.saltar_validacion_usuario = false
    self.resource.saltar_validacion_correo_principal = false

    #respond_to do |format|
    #
    #def update_resource(resource, params)
    if params[:usuario][:password].blank? && params[:usuario][:password_confirmation].blank?
      if self.resource.update_without_password(account_update_params)

     # if self.resource.update(account_update_params)
        flash.now[:notice] = "Los datos del paciente fueron modificados correctamente"
        redirect_to usuario_registration_path(@paciente.id)
        #format.json { head :no_content }
      else
        #format.html { render :editPaciente }
        render :editPaciente
        #format.json { render json: @paciente.errors, status: :unprocessable_entity }
      end
    end
    #end
  end 
  end 
end 

def create
  @numero_paciente = Usuario.last.numero_excel.to_i + 1
  params[:usuario][:username] = "alerasin"+params[:usuario][:numero_excel]
  params[:usuario][:password] = params[:usuario][:username]
  params[:usuario][:password_confirmation] = params[:usuario][:username]
  params[:usuario][:rol] = 3
  #ESTADO = 1, PENDIENTE
  params[:usuario][:estado] = 1

  if params[:usuario][:ava].blank? and 
     params[:usuario][:cuc].blank? and 
     params[:usuario][:hong].blank? and 
     params[:usuario][:berm].blank? and
     params[:usuario][:john].blank? and
     params[:usuario][:aso].blank? and
     params[:usuario][:blom].blank?  
     params[:usuario][:fecha_pruebas] = nil     
  end

  build_resource(sign_up_params)
  #respond_to do |format|
  @usuario.saltar_validacion_usuario = false
  @usuario.validar_usuario_nuevo = true
    if resource.save(state: :cambiando_password)
      @paciente = Usuario.where(historia: params[:usuario][:historia]).first
      redirect_to usuario_registration_path(@paciente.id)
    #  format.html { redirect_to usuario_registration_path(self.resource.id)}
    #  format.json { head :no_content }
    else
      clean_up_passwords resource
      respond_with resource
    #end
  end  
end

def show
   @paciente = Usuario.find(params[:format])
end

def showPruebas
   @paciente = Usuario.find(params[:format])
end

def adminHome
    render 'devise/registrations/show' 
end


private

# https://github.com/plataformatec/devise/wiki/How-To%3a-Allow-users-to-edit-their-account-without-providing-a-password
  def needs_password?(usuario, params)
    params[:password].present?
  end

def sign_up_params
	allow = [:email, 
           :username, 
           :nombre, 
           :apellido, 
           :password, 
           :password_confirmation,
           :email,
           :email_confirmation,
           :cedula,
           :numero_excel,
           :historia,
           :estado,
           :telefono_habitacion, 
           :telefono_trabajo,
           :celular1, 
           :celular2, 
           :email2, 
           :email2_confirmation,
           :fecha_nacimiento, 
           :ava,
           :cuc,
           :hong,
           :berm,
           :john,
           :asp,
           :blom,
           :rol,
           :fecha_pruebas ]

	params.require(resource_name).permit(allow)
end

def update_resource(resource, params)
  resource.update_without_password(params)
end

def update_resource(resource, params)
    resource.update_without_password(params)
  end


def account_update_params
  puts params[:usuario][:nombre]

params.require(:usuario).permit(
  				 :email, 
           :username, 
           :nombre, 
           :apellido, 
#           :password, 
#           :password_confirmation,
           :email,
           :email_confirmation,
           :cedula,
           :numero_excel,
           :historia,
           :estado,
           :telefono_habitacion, 
           :telefono_trabajo,
           :celular1, 
           :celular2, 
           :email2, 
           :email2_confirmation,
           :fecha_nacimiento, 
           :ava,
           :cuc,
           :hong,
           :berm,
           :john,
           :asp,
           :blom,
           :rol,
           :fecha_pruebas)
end

def pruebas_update_params
  puts params[:usuario][:nombre]

params.require(:usuario).permit(
           :ava,
           :cuc,
           :hong,
           :berm,
           :john,
           :asp,
           :blom,
           :rol,
           :fecha_pruebas)
end

#el siguiente método permite customizar el redirect despues de actualizar
#los datos personales
  def after_update_path_for(resource)
    adminHome_path(resource)
  end

  def cambiar_formato_fecha(fecha_s)
      fecha_s[8..9].to_s<<"-"<<fecha_s[5..6].to_s<<"-"<<fecha_s[0..3].to_s
  end
end