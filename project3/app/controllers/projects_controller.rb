class ProjectsController < ApplicationController
  
  # GET /projects/tag
  def tag
     @projects = Project.find_tagged_with(params[:id]).paginate :per_page => 5, :page => params[:page], :order => 'name'
     flash[:notice] = "Projects tagged with '#{params[:id]}'"
     render(:action => :index)
  end
   
  #
  #  GET /projects/search
  #  GET /projects/search.xml
  #  Performs a search operation based on the criteria specified
  #  in the request.
  #
  def search
     logger.info("Called Search!")
     if params[:query].empty?
        params[:query] = '%'
     else
        params[:query] = '%' + params[:query] + '%'  
     end
     logger.info("query: '#{params[:query]}'") 
     @projects = Project.find(:all, :conditions => ["name like ? or description like ?",params[:query],params[:query]] ).paginate :per_page => 5, :page => params[:page], :order => 'name'
     render(:action => 'index',:object => @projects)
  end
   
  # GET /projects
  # GET /projects.xml
  def index
    @projects = Project.paginate :per_page => 5, :page => params[:page], :order => 'name'

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @projects }
    end
  end

  # GET /projects/1
  # GET /projects/1.xml
  def show
    @project = Project.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @project }
    end
  end

  # GET /projects/new
  # GET /projects/new.xml
  def new
    @project = Project.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @project }
    end
  end

  # GET /projects/1/edit
  def edit
    @project = Project.find(params[:id])
  end

  # POST /projects
  # POST /projects.xml
  def create
    @project = Project.new(params[:project])

    respond_to do |format|
      if @project.save
        flash[:notice] = 'Project was successfully created.'
        format.html { redirect_to(@project) }
        format.xml  { render :xml => @project, :status => :created, :location => @project }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @project.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /projects/1
  # PUT /projects/1.xml
  def update
    @project = Project.find(params[:id])

    respond_to do |format|
      if @project.update_attributes(params[:project])
        flash[:notice] = 'Project was successfully updated.'
        format.html { redirect_to(@project) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @project.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.xml
  def destroy
    @project = Project.find(params[:id])
    @project.destroy

    respond_to do |format|
      format.html { redirect_to(projects_url) }
      format.xml  { head :ok }
    end
  end
end
