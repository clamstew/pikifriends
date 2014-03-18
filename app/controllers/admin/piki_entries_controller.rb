class Admin::PikiEntriesController < ApplicationController
  
  before_filter :admin_required
  layout "admin"
  protect_from_forgery
  
  # GET /piki_entries
  # GET /piki_entries.xml
  def index
    @piki_entries = PikiEntry.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @piki_entries }
    end
  end

  # GET /piki_entries/1
  # GET /piki_entries/1.xml
  def show
    @piki_entry = PikiEntry.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @piki_entry }
    end
  end

  # GET /piki_entries/new
  # GET /piki_entries/new.xml
  def new
    @piki_entry = PikiEntry.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @piki_entry }
    end
  end

  # GET /piki_entries/1/edit
  def edit
    @piki_entry = PikiEntry.find(params[:id])
  end

  # POST /piki_entries
  # POST /piki_entries.xml
  def create
    @piki_entry = PikiEntry.new(params[:piki_entry])

    respond_to do |format|
      if @piki_entry.save
        flash[:notice] = 'PikiEntry was successfully created.'
        format.html { redirect_to admin_piki_entry_path(@piki_entry) }
        format.xml  { render :xml => @piki_entry, :status => :created, :location => @piki_entry }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @piki_entry.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /piki_entries/1
  # PUT /piki_entries/1.xml
  def update
    @piki_entry = PikiEntry.find(params[:id])

    respond_to do |format|
      if @piki_entry.update_attributes(params[:piki_entry])
        flash[:notice] = 'PikiEntry was successfully updated.'
        format.html { redirect_to admin_piki_entry_path(@piki_entry) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @piki_entry.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /piki_entries/1
  # DELETE /piki_entries/1.xml
  def destroy
    @piki_entry = PikiEntry.find(params[:id])
    @piki_entry.destroy

    respond_to do |format|
      format.html { redirect_to(admin_piki_entries_url) }
      format.xml  { head :ok }
    end
  end
end
