class ContactsController < ApplicationController
  def create
    @contact = Contact.new(contact_params)
    if @contact.save
      redirect_to contact_path, notice: 'Your message has been sent successfully.'
    else
      @page = Page.find_by(permalink: 'contact')
      render 'pages/show'
    end
  end

  private

  def contact_params
    params.require(:contact).permit(:name, :email, :message)
  end
end
