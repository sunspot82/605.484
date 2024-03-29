class ProjectAssignmentsController < ApplicationController
  
  before_filter :get_owners
  
  # GET /project_assignments
  # GET /project_assignments.xml
  def index
    if @engineer && ! @project
       @project_assignments = ProjectAssignment.find(:all, :conditions => ["engineer_id = ?",@engineer.id])
    elsif ! @engineer && @project
       @project_assignments = ProjectAssignment.find(:all, :conditions => ["project_id = ?",@project.id])
    elsif @engineer && @project
       @project_assignments = ProjectAssignment.find(:all, :conditions => ["engineer_id = ? AND project_id = ?",@engineer.id,@project.id])
    else
       @project_assignments = ProjectAssignment.find(:all)
    end
       
    @project_assignments = @project_assignments.paginate :per_page => 5, :page => params[:page], :order => :start_date
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @project_assignments }
    end
  end

  # GET /project_assignments/1
  # GET /project_assignments/1.xml
  def show
    @project_assignment = ProjectAssignment.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @project_assignment }
    end
  end

  # GET /project_assignments/new
  # GET /project_assignments/new.xml
  def new
    @project_assignment = ProjectAssignment.new
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @project_assignment }
    end
  end

  # GET /project_assignments/1/edit
  def edit
    @project_assignment = ProjectAssignment.find(params[:id])
  end

  # POST /project_assignments
  # POST /project_assignments.xml
  def create
    @project_assignment = ProjectAssignment.new(params[:project_assignment])

    respond_to do |format|
      if @project_assignment.save
        flash[:notice] = 'ProjectAssignment was successfully created.'
        format.html { redirect_to(@project_assignment) }
        format.xml  { render :xml => @project_assignment, :status => :created, :location => @project_assignment }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @project_assignment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /project_assignments/1
  # PUT /project_assignments/1.xml
  def update
    @project_assignment = ProjectAssignment.find(params[:id])

    respond_to do |format|
      if @project_assignment.update_attributes(params[:project_assignment])
        flash[:notice] = 'ProjectAssignment was successfully updated.'
        format.html { redirect_to(@project_assignment) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @project_assignment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /project_assignments/1
  # DELETE /project_assignments/1.xml
  def destroy
    @project_assignment = ProjectAssignment.find(params[:id])
    @project_assignment.destroy

    respond_to do |format|
      format.html { redirect_to(project_assignments_url) }
      format.xml  { head :ok }
    end
  end
  
private
   def get_owners      
      if params[:engineer_id]
         @engineer = Engineer.find(params[:engineer_id])
      end
      if params[:project_id]
         @project = Project.find(params[:project_id])
      end      
   end
  
end
