class Admin::TeacherTicketsController < ApplicationController
  
  before_filter :admin_required
  layout "admin"
  protect_from_forgery
  
  # GET /teacher_tickets
  # GET /teacher_tickets.xml
  def index
    @teacher_tickets = TeacherTicket.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @teacher_tickets }
    end
  end

  # GET /teacher_tickets/1
  # GET /teacher_tickets/1.xml
  def show
    @teacher_ticket = TeacherTicket.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @teacher_ticket }
    end
  end

  # GET /teacher_tickets/new
  # GET /teacher_tickets/new.xml
  def new
    @teacher_ticket = TeacherTicket.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @teacher_ticket }
    end
  end

  # GET /teacher_tickets/1/edit
  def edit
    @teacher_ticket = TeacherTicket.find(params[:id])
  end

  # POST /teacher_tickets
  # POST /teacher_tickets.xml
  def create
    @teacher_ticket = TeacherTicket.new(params[:teacher_ticket])

    respond_to do |format|
      if @teacher_ticket.save
        flash[:notice] = 'TeacherTicket was successfully created.'
        format.html { redirect_to(@teacher_ticket) }
        format.xml  { render :xml => @teacher_ticket, :status => :created, :location => @teacher_ticket }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @teacher_ticket.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /teacher_tickets/1
  # PUT /teacher_tickets/1.xml
  def update
    @teacher_ticket = TeacherTicket.find(params[:id])

    respond_to do |format|
      if @teacher_ticket.update_attributes(params[:teacher_ticket])
        flash[:notice] = 'TeacherTicket was successfully updated.'
        format.html { redirect_to(@teacher_ticket) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @teacher_ticket.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /teacher_tickets/1
  # DELETE /teacher_tickets/1.xml
  def destroy
    @teacher_ticket = TeacherTicket.find(params[:id])
    @teacher_ticket.destroy

    respond_to do |format|
      format.html { redirect_to(teacher_tickets_url) }
      format.xml  { head :ok }
    end
  end
  
end
