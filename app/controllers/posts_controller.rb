class PostsController < ApplicationController
  def index
      @posts = Article.all

      respond_to do |format|
        format.xls { send_data(@posts.to_xls) }
        # format.xls {
        #   filename = "posts-#{Time.now.strftime("%Y%m%d%H%M%S")}.xls"
        #   send_data(@posts.to_xls, :type => "application/excel; charset=utf-8; header=present", :filename => filename)
        # }
      end
    end



end
