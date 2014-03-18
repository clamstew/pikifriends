class SchoolsController < ApplicationController
	
	#htpasswd :user => 'staff', :pass => 'kGD8dVrg'
	layout "schools", :except => [:profile, :students, :students_data_of_class, :teachers_and_ticket, :teachers_data]
  # GET /schools
  # GET /schools.xml
  def index
    @schools = School.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @schools }
    end
  end

  # GET /schools/1
  # GET /schools/1.xml
  def show
    @school = School.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml # show.xml.erb
    end
    
  end

  # GET /schools/new
  # GET /schools/new.xml
  def new
    @school = School.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @school }
    end
    
  end

  # GET /schools/1/edit
  def edit
    @school = School.find(params[:id])
  end

  # POST /schools
  # POST /schools.xml
  def create
    @school = School.new(params[:school])

    respond_to do |format|
      if @school.save
        flash[:notice] = 'School was successfully created.'
        format.html { redirect_to(@school) }
        format.xml  { render :xml => @school, :status => :created, :location => @school }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @school.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /schools/1
  # PUT /schools/1.xml
  def update
    @school = School.find(params[:id])

    respond_to do |format|
      if @school.update_attributes(params[:school])
        flash[:notice] = 'School was successfully updated.'
        format.html { redirect_to(@school) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @school.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /schools/1
  # DELETE /schools/1.xml
  def destroy
    @school = School.find(params[:id])
    @school.destroy

    respond_to do |format|
      format.html { redirect_to(schools_url) }
      format.xml  { head :ok }
    end
  end
  
  def profile
    @school = School.find(params[:id])
  end
  
  # grade周り
  def grade_create
    @school = School.find(params[:id])
    @grade = Grade.new
    @grade.school = @school
    @grade.name = 'grade name'
    if @grade.save
      redirect_to :action =>'profile', :id => params[:id]
    end
  end
  
  def grade_update
    @grade = Grade.find(params[:grade_id])
    @grade.update_attributes(params[:grade])
    render :text => 'OK'
  end
  
  def grade_delete
    @grade = Grade.find(params[:grade_id])
    if @grade.destroy
      redirect_to :action =>'profile', :id => params[:id]
    end
  end
  
  # classroom周り
  def classroom_create
    @grade = Grade.find(params[:grade_id])
    @classroom = Classroom.new
    @classroom.name = 'classroom name'
    @classroom.grade = @grade
    if @classroom.save
      redirect_to :action =>'profile', :id => params[:id]
    end
  end
  
  def classroom_update
    @classroom = Classroom.find(params[:classroom_id])
    @classroom.update_attributes(params[:classroom])
    render :text => 'OK'
  end
  
  def classroom_delete
    @classroom = Classroom.find(params[:classroom_id])
    @classroom.destroy
    redirect_to :action =>'profile', :id => params[:id]
  end
  
  # students周り
  def students
    @school = School.find(params[:id])
    student_role_id = Role.find_by_name('student').id
    @students = User.find(:all, :conditions=>["school_id = ? AND role_id = ?",[@school.id], student_role_id])
  end
  
  #クラス分け周り
  def set_classroom_with_student
    @user = User.find(params[:student_id])
    @classroom = Classroom.find(params[:classroom_id])
    @user.classroom = @classroom
    if @user.save
      redirect_to :action =>'students', :id => params[:id]
    end
  end
  
  def unset_classroom_with_student
    @user = User.find(params[:student_id])
    @user.classroom = nil
    if @user.save
      redirect_to :action =>'students', :id => params[:id]
    end
  end
  
  #クラスの生徒のデータ
  def students_data_of_class
    @role = Role.find_by_name('student')
    @classroom = Classroom.find(params[:classroom_id])
  end
  
  def teachers_and_ticket
    role = Role.find_by_name('teacher')
    @school = School.find(params[:id])
    @teachers = User.find( :all, :conditions => ["school_id = ? AND role_id = ?", @school.id, role.id ] )
    
    @tickets = TeacherTicket.find(:all, :conditions => ["school_id = ?", @school.id])
  end
  
  def teachers_data
    
    role = Role.find_by_name('teacher')
    @school = School.find(params[:id])
    @teachers = User.find( :all, :conditions => ["school_id = ? AND role_id = ?", @school.id, role.id ] )
    
  end
end
