class ProjectScopesController < ApplicationController
  # GET /project_scopes
  # GET /project_scopes.xml
  def index
    @project_scopes = ProjectScope.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @project_scopes }
    end
  end

  # GET /project_scopes/1
  # GET /project_scopes/1.xml
  def show
    @project_scope = ProjectScope.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @project_scope }
    end
  end

  # GET /project_scopes/new
  # GET /project_scopes/new.xml
  def new
    @project_scope = ProjectScope.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @project_scope }
    end
  end

  # GET /project_scopes/1/edit
  def edit
    @project_scope = ProjectScope.find(params[:id])
  end

  # POST /project_scopes
  # POST /project_scopes.xml
  def create
    @project_scope = ProjectScope.new(params[:project_scope])

    respond_to do |format|
      if @project_scope.save
        flash[:notice] = 'ProjectScope was successfully created.'
        format.html { redirect_to(@project_scope) }
        format.xml  { render :xml => @project_scope, :status => :created, :location => @project_scope }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @project_scope.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /project_scopes/1
  # PUT /project_scopes/1.xml
  def update
    @project_scope = ProjectScope.find(params[:id])

    respond_to do |format|
      if @project_scope.update_attributes(params[:project_scope])
        flash[:notice] = 'ProjectScope was successfully updated.'
        format.html { redirect_to(@project_scope) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @project_scope.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /project_scopes/1
  # DELETE /project_scopes/1.xml
  def destroy
    @project_scope = ProjectScope.find(params[:id])
    @project_scope.destroy

    respond_to do |format|
      format.html { redirect_to(project_scopes_url) }
      format.xml  { head :ok }
    end
  end
end
