class PagesController < ApplicationController
  def permalink
    @page = Page.find_by(permalink: params[:permalink])
    @contact = Contact.new if @page&.permalink == 'contact'
    render :show
  end

  def show
    @page = Page.find_by(permalink: params[:permalink])
    @contact = Contact.new if @page&.permalink == 'contact'
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
      redirect_to page_path(@page.permalink), notice: 'Page was successfully updated.'
    else
      render :edit
    end
  end

  private

  def about
  end
end

  def page_params
    params.require(:page).permit(:title, :content)
  end
end
