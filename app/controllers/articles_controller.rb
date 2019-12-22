class ArticlesController < ApplicationController
  before_action :require_login, except: [:index, :show]

  include ArticlesHelper
  
  def index
    @articles = Article.all    
    @popular_articles = Article.order(view_count: :desc, created_at: :asc).limit(3)
  end
  
  def show
    @article = Article.find(params[:id])
    @article.increment_view_count

    @comment = Comment.new
    @comment.article_id = @article.id
  end

  def new
    @article = Article.new
  end

  def edit
    @article = Article.find(params[:id])
  end

  def create
    @article = Article.new(article_params)
    @article.save
    
    flash.notice = "Article #{@article.title} Created!"

    redirect_to article_path(@article)
  end

  def update
    @article = Article.find(params[:id]) 
    @article.update(article_params)

    flash.notice = "Article #{@article.title} Updated!"

    redirect_to article_path(@article)
  end

  def destroy
    @article = Article.find(params[:id])
    @article.destroy

    flash.notice = "Article #{@article.title} Deleted!"

    redirect_to articles_path
  end

  def search
    if params[:year] == "older"
      @articles = Article.where("created_at <= ?", @last_dates[4])
    else
      timepoint = Time.gm(params[:year], params[:month])

      @articles = Article.where(created_at: timepoint..timepoint + 1.year)

      if params[:month]
        @articles = @articles.where(created_at: timepoint..timepoint + 1.month)
      end
    end

    @popular_articles = Article.order(view_count: :desc, created_at: :asc).limit(3)

    render "index"
  end
end
