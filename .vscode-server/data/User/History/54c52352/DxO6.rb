class ContactsController < ApplicationController
  def create
    @contact = Contact.new(contact_params)
    if @contact.save
      redirect_to page_path('contact'), notice: 'Your message has been sent successfully.'
    else
      redirect_to page_path('contact'), alert: 'There was an error sending your message.'
    end
  end

  private

  def contact_params
    params.require(:contact).permit(:name, :email, :message)
  end
end
