class ContactsController < ApplicationController
  #GET request too /contact-us
  #show new contact form
  def new
    @contact = Contact.new
  end
  
  #POST request /contacts
  def create
    #mass assignment of form fields into Contact object
    @contact = Contact.new(contact_params)
    #Save the contact object to database
    if @contact.save
      #store form fields via parameters, into variables
      name = params[:contact][:name]
      email = params[:contact][:email]
      body = params[:contact][:comments]
      # Plug varaiables into the Contact Mailer 
      #email method and send email
      ContactMailer.contact_email(name, email, body).deliver
      #store success message in flash hash
      # and rediret to new action
      flash[:success] = "Message sent."
      redirect_to new_contact_path
    else
      #if contact object doesnt save
      #store errors in flash hash
      #redirect to new action
       flash[:danger] = @contact.errors.full_messages.join(", ")
       redirect_to new_contact_path
    end
  end
private
#To collect data from form, we need to use strong parameters and whitelist form fields
  def contact_params
     params.require(:contact).permit(:name, :email, :comments)
  end
end 