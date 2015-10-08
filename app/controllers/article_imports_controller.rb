class ArticleImportsController < ApplicationController
  def new
    @article_import = ArticleImport.new
  end

  def create
    @article_import = ArticleImport.new(params[:product_import])
    if @article_import.save
      redirect_to root_url, notice: "Imported products successfully."
    else
      render :new
    end
  end
end
