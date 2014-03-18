class BlogsController < ApplicationController
  
  #htpasswd :user => 'staff', :pass => 'kGD8dVrg'
  layout "blogs", :except => [:push_proofreader, :comments, :data]
  
  # GET /blogs
  # GET /blogs.xml
  def index
    @blogs = Blog.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @blogs }
    end
  end

  # GET /blogs/1
  # GET /blogs/1.xml
  def show
    @blog = Blog.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  # { render :xml => @blog }
    end
  end

  # GET /blogs/new
  # GET /blogs/new.xml
  def new
    @blog = Blog.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @blog }
    end
  end

  # GET /blogs/1/edit
  def edit
    @blog = Blog.find(params[:id])
  end

  # POST /blogs
  # POST /blogs.xml
  def create
    @blog = Blog.new(params[:blog])

    respond_to do |format|
      if @blog.save
        flash[:notice] = 'Blog was successfully created.'
        format.html { redirect_to(@blog) }
        format.xml  { render :xml => @blog, :status => :created, :location => @blog }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @blog.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /blogs/1
  # PUT /blogs/1.xml
  def update
    @blog = Blog.find(params[:id])

    respond_to do |format|
      if @blog.update_attributes(params[:blog])
        flash[:notice] = 'Blog was successfully updated.'
        format.html { redirect_to(@blog) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @blog.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /blogs/1
  # DELETE /blogs/1.xml
  def destroy
    @blog = Blog.find(params[:id])
    @blog.destroy

    respond_to do |format|
      format.html { redirect_to(blogs_url) }
      format.xml  { head :ok }
    end
  end
  
  def data
    @blog = Blog.find(params[:id])
  end
  
  # proofreaderの保存
  def push_proofread
    #レスポンス生成
    buf = 'NG'
    #proofreader保存
    @blog = Blog.find(params[:id])
    if @blog
      proofread = Proofread.new(params[:proofread])
      if proofread
        proofread.save
        @blog.proofread = proofread
        @blog.save
        buf = 'OK'
      end
    end
    render :text => buf
  end
  
  # 
  def comments
    @blog = Blog.find(params[:id])
  end
  
  def delete_blog_comment
    blog_comment = BlogComment.find params[:comment_id]
    if blog_comment
      blog_comment.destroy
      render :text => '200', :status => 200 and return
    else
      render :text => '404', :status => 200 and return
    end 
  end
end
