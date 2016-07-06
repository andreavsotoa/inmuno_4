class SolicitudMailer < ApplicationMailer   
  default template_path: 'solicitud_mailer' # to make sure that your mailer uses the devise views

  def solicitud_especial(comentario)
    from = 'emailutilitario139@gmail.com'
    email = 'emailutilitario139@gmail.com'
    subject = "solicitud especial de vacuna"
    @comentario = comentario
    mail(from: from, to: email, subject: subject)
  end
end

# def respuestaContacto_email(contacto)
#     @contacto = contacto
#     puts "respuestaContacto_email"
#     puts @contacto.email
#     attachments.inline['logo.png'] = File.read("#{Rails.root}/app/assets/images/logo.png")
#     mail(to: @contacto.email, subject: 'ALERASIN - Respuesta a su consulta')
# end