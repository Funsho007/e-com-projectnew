class ContactsController < ApplicationController
  def create
    @contact = Contact.new(contact_params)
    if @contact.save
      flash[:notice] = "Message sent successfully."
      redirect_to root_path
    else
      flash[:alert] = "There was an error sending your message."
      render :new
    end
  end

  private

  def contact_params
    params.require(:contact).permit(:name, :email, :message)
  end
end
