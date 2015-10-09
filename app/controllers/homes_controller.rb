class HomesController < ApplicationController
def index
  @articles = Article.order("id desc").page(params[:page]).per(3)
  respond_to do |format|
    format.html
  end
end


end
