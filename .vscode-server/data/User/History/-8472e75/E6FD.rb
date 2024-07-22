class PagesController < ApplicationController
  before_action :authenticate_admin_user!, only: [:edit, :update]

  def show
    @page = Page.find_by(permalink: params[:permalink])
    if @page
      render :show
    else
      redirect_to root_path, alert: "Page not found"
    end
  end

  def edit
    @page = Page.find(params[:id])
  end

  def update
    @page = Page.find(params[:id])
    if @page.update(page_params)
      redirect_to page_path(permalink: @page.permalink), notice: 'Page was successfully updated.'
    else
      render :edit
    end
  end

  private
  def page_params
    params.require(:page).permit(:title, :content, :permalink)
  end
end
