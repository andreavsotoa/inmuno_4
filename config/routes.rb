Rails.application.routes.draw do
  namespace :administrator do
    resource :pacientes do
       collection do
             get :buscar
             get :buscar_paciente
             get :buscarFrasco
             get :buscarPruebas
       end
    end

    namespace :menu_nivel0 do
      resources :menu_nivel1s
    end

    resources :pacientes
    resources :configurations
    resources :tips
    resources :faqs
    resources :menu_nivel0s
    resources :contactos, only: [:index, :edit, :update, :destroy]

    # get 'pacientes/buscar', :to => 'pacientes#buscar'
  end

  namespace :paciente do
    # get 'pacientes' => 'pacientes#index', :as => "paciente"
  end

#get 'administrator/home/index' => 'administrator/home#index', :as => "admin"

 
devise_scope :usuario do
  get 'usuarios' => 'registrations#show', :as => "usuario_registration"
  get 'usuarios' => 'registrations#showPruebas', :as => "usuario_registration_pruebas"
  get 'usuarios/index', :to => 'registrations#index', :as => :usuarios_list
  get 'adminHome', :action => 'adminHome', :controller => 'registrations', :as => 'adminHome'

  get 'registrations/pacientes/:id/edit' => 'registrations#editPaciente', :as => "edit_paciente_registration"
  get 'registrations/editPrueba/:id' => 'registrations#editPrueba', :as => "edit_prueba_registration" 
  patch 'registrations/pacientes(.:format)'=> "registrations#update"
  put 'registrations/pacientes(.:format)'=> "registrations#update"


  put 'usuarios/pacientes(.:format)'=> "registrations#update"

  get 'registrations/showFrascos/:id' => 'registrations#showFrascos', :as => "show_frascos_registration" 
  get 'registrations/showFrascosPaciente/:id' => 'registrations#showFrascosPaciente', :as => "show_frascos_paciente_registration" 

  #get 'consulting/show/:id' => 'consultings#show', :as => "frascos_consulting" 
##'usuarios/edit_paciente', :to => 'registration#edit_paciente'
end

  # patch 'registrations/editPaciente/:id(.:format)'=> "registrations#update"

  devise_for :usuarios, controllers: {registrations: "registrations", sessions: "sessions"}

  mount Ckeditor::Engine => '/ckeditor'

  # devise_scope :usuarios do
  #   get 'usuarios/edit_paciente', :to => 'registration#edit_paciente'
  #   get 'usuarios/edit_prueba', :to => 'registration#edit_prueba'
  # end

  # resources :usuarios, only: [:index]

  resource :usuario, only: [:edit] do
    collection do
      patch 'update_password'
    end
  end

  # resources :cambiar_passwords, only: [:edit, :update]

  # devise_scope :usuario do
  #  get '/passwordusuarios/edit(.:format)' => "passwordusuarios#edit", :as => :cambiar_password
  #  patch '/passwordusuarios/(.:format)'=> "passwordusuarios#update"
  #  put '/passwordusuarios/(.:format)'=> "passwordusuarios#update"
  # end

  get '/patients/:id', to: 'patients#show', as: 'patient'

  resource :inbox, :controller => 'inbox', :only => [:show,:create]

  PagesController.action_methods.each do |action|
    if action!="faq" && action!="tip" && action!="contacto" && action!="opcionPrincipal"
      get "pages/contenido", to: "pages#contenido", as: "#{action}"
    end
  end

  get 'pages/faq' => 'pages#faq', as: :faq
  get 'pages/tip' => 'pages#tip', as: :tip
  # get 'pages/contacto' => 'pages#contacto', as: :contacto

  scope '/pages' do
    resources :contactos, only: [:new, :create, :show]
  end

  get 'administrator/home/index' => 'administrator/home#index', :as => "admin"
  get 'paciente/home/index' => 'paciente/pacientes#index', :as => "paciente"

  root 'pages#home'

  # nuevas rutas del proyecto para la materia
  get 'ejemplo1' => 'paciente/pacientes#index'
  get 'vacunas/listar'
  get 'vacunas/solicitar'
  post 'vacunas/crear_solicitud'
end
