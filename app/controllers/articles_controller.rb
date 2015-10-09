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

valid_keys= ["id","title","content","status"]

total_row = 0
    spreadsheet = Article.open_spreadsheet(params[:file])

    # spreadsheet.sheets.each_with_index do |sheet, index|
    #   spreadsheet.default_sheet = spreadsheet.sheets[index]
# byebug
      header = Array.new
      spreadsheet.row(1).each { |row| header << row.downcase.tr(' ', '_') }
      (2..spreadsheet.last_row).each do |i|
        row = Hash[[header, spreadsheet.row(i)].transpose]
          data = Article.create(row)


spreadsheet.default_sheet= spreadsheet.sheets.last

 header = Array.new
      spreadsheet.row(1).each { |row| header << row.downcase.tr(' ', '_') }
      (2..spreadsheet.last_row).each do |i|
        row = Hash[[header, spreadsheet.row(i)].transpose]
        data=row.to_hash.slice(*valid_keys)
          #user_id=Article.all.select(:id)
# accesible=["id","content"]

    # comment= row.to_hash.slice(accesible)
    # byebug

               comment = Article.last.comments.create(data)


    @articles=Article.all.order(:created_at).page(params[:page]).per(5)
    @comments = Comment.all

end




      # end

end




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

       respond_to do |format|
         format.html
         format.csv { send_data Article.to_csv }
         format.xls
       end

   end


private

def params_article

params.require(:article).permit(:title, :content, :status)

end


end
