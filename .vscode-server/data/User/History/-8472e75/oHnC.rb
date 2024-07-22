class PagesController < ApplicationController
  before_action :set_page, only: [:show, :edit, :update]

  <%= form_with model: @contact, url: contact_path, method: :post, local: true do |form| %>
    <div class="field">
      <%= form.label :name %>
      <%= form.text_field :name, class: "input" %>
    </div>
    <div class="field">
      <%= form.label :email %>
      <%= form.email_field :email, class: "input" %>
    </div>
    <div class="field">
      <%= form.label :message %>
      <%= form.text_area :message, class: "textarea" %>
    </div>
    <div class="field">
      <%= form.submit "Send Message", class: "button is-primary" %>
    </div>
  <% end %>


  def show
    @contact = Contact.new if @page&.permalink == 'contact'
    if @page
      render :show
    else
      render :not_found
    end
  end

  def edit
    if @page
      render :edit
    else
      render :not_found
    end
  end

  def update
    if @page.update(page_params)
      redirect_to page_path(@page.permalink), notice: 'Page was successfully updated.'
    else
      render :edit
    end
  end

  private

  def set_page
    @page = Page.find_by(permalink: params[:permalink])
  end

  def page_params
    params.require(:page).permit(:title, :content, :permalink)
  end
end
