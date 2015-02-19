class PostsController < ApplicationController
  before_filter :authenticate_user!, :except => [:index, :show]
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.order(score: :desc)
  end

  def upvote
    @post = Post.find(params[:id])
    if @post.score == nil
      @post.score = 1
    else
     @post.score += 1
    end
    @post.save
    respond_to do |format|
      format.html { redirect_to posts_path, notice: 'Score counted.' }
    end

  end

  def downvote
    @post = Post.find(params[:id])
    if @post.score == nil
      @post.score = 0
    elsif @post.score == 0
      @post.score == 0
    else
      @post.score -= 1
    end
    @post.save
    respond_to do |format|
      format.html { redirect_to posts_path, notice: 'Score counted.' }
    end
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
  end

  # GET /posts/new
  def new
    @post = Post.new 
    
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts
  # POST /posts.json
  def create

    @post = Post.new(post_params)
    @post.user_id = current_user.id
    
    respond_to do |format|
      if @post.save
        format.html { redirect_to posts_path, notice: 'Post was successfully created.' }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new }
        format.json { render json: posts_path.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    @post = Post.find(params[:id])
    respond_to do |format|
      if @post.user != current_user 
        format.html { redirect_to posts_path, notice: 'That post is not yours to edit' } 
        format.json { render json: @post.errors, status: :unprocessable_entity } 
      elsif @post.update(post_params) 
        format.html { redirect_to posts_path, notice: 'Post was successfully updated.' } 
        format.json { head :no_content } 
      else 
        format.html { render :edit } 
        format.json { render json: posts_path.errors, status: :unprocessable_entity } 
      end 
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post = Post.find(params[:id])  
    if @post.user != current_user 
      flash[:notice] = 'That post is not yours to destory'  
      respond_to do |format| 
        format.html { redirect_to :back } 
        format.json { head :no_content } 
      end 
    else @post.destroy  
      respond_to do |format| 
        format.html { redirect_to posts_url } 
        format.json { head :no_content } 
      end 
    end 
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:title, :url, :user_id)
    end
end
