class ContactsController < ApplicationController
  def create
    # Process the form submission (e.g., send an email)
    # For now, we will just redirect back to the contact page with a notice
    redirect_to page_path(permalink: 'contact'), notice: 'Your message has been sent.'
  end
end
