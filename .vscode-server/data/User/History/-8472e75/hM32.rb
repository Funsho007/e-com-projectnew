class PagesController < ApplicationController
  def permalink
    @page = Page.find_by(permalink: params[:permalink])
    if @page
      @contact = Contact.new if @page.permalink == 'contact'
    else
      render file: "#{Rails.root}/public/404.html", layout: false, status: :not_found
    end
  end

  def show
    @page = Page.find_by(permalink: params[:permalink])
    if @page
      render :show
    else
      render :not_found
    end
  end

  def edit
    @page = Page.find_by(permalink: params[:permalink])
  end

  def update
    @page = Page.find_by(permalink: params[:permalink])
    if @page.update(page_params)
      redirect_to permalink_path(@page.permalink), notice: 'Page was successfully updated.'
    else
      render :edit
    end
  end

  private

  def page_params
    params.require(:page).permit(:title, :content)
  end
