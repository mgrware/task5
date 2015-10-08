class ArticlesController < ApplicationController

def index
  @articles = Article.order("title").page(params[:page]).per(3)
 @comments = Comment.all
 respond_to do |format|
   format.html
   format.csv { send_data @articles.to_csv }
   format.xls
 end
end

  def new
  @article = Article.new
end

def import
  Article.import(params[:file])
  redirect_to root_url, notice: "Products imported."
end

def create
    @article = Article.new(params_article)

    if @article.save

        flash[:notice] = "Success Add Records"

        redirect_to action: 'index'

    else

        flash[:error] = "data not valid"

        render 'new'

    end

end

def edit

      @article = Article.find_by_id(params[:id])

  end

  def destroy

@article = Article.find_by_id(params[:id])

if @article.destroy

  flash[:notice] = "Success Delete a Records"

  redirect_to action: 'index'

else

  flash[:error] = "fails delete a records"

  redirect_to action: 'index'

end

end

  def update

 @article = Article.find_by_id(params[:id])

 if @article.update(params_article)

    flash[:notice] = "Success Update Records"

    redirect_to action: 'index'

 else

    flash[:error] = "data not valid"

    render 'edit'

 end

end

def show

       @article = Article.find_by_id(params[:id])

       @comments = @article.comments.order("id desc")

       @comment = Comment.new

  def download_pdf
  html = render_to_string(:action => '../pdf/my_template', :layout => false)
  pdf = PDFKit.new(html)
  send_data(pdf.to_pdf)
end
   end


private

def params_article

params.require(:article).permit(:title, :content, :status)

end


end
