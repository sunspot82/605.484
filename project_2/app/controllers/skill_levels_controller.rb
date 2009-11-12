class SkillLevelsController < ApplicationController
  # GET /skill_levels
  # GET /skill_levels.xml
  def index
    @skill_levels = SkillLevel.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @skill_levels }
    end
  end

  # GET /skill_levels/1
  # GET /skill_levels/1.xml
  def show
    @skill_level = SkillLevel.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @skill_level }
    end
  end

  # GET /skill_levels/new
  # GET /skill_levels/new.xml
  def new
    @skill_level = SkillLevel.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @skill_level }
    end
  end

  # GET /skill_levels/1/edit
  def edit
    @skill_level = SkillLevel.find(params[:id])
  end

  # POST /skill_levels
  # POST /skill_levels.xml
  def create
    @skill_level = SkillLevel.new(params[:skill_level])

    respond_to do |format|
      if @skill_level.save
        flash[:notice] = 'SkillLevel was successfully created.'
        format.html { redirect_to(@skill_level) }
        format.xml  { render :xml => @skill_level, :status => :created, :location => @skill_level }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @skill_level.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /skill_levels/1
  # PUT /skill_levels/1.xml
  def update
    @skill_level = SkillLevel.find(params[:id])

    respond_to do |format|
      if @skill_level.update_attributes(params[:skill_level])
        flash[:notice] = 'SkillLevel was successfully updated.'
        format.html { redirect_to(@skill_level) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @skill_level.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /skill_levels/1
  # DELETE /skill_levels/1.xml
  def destroy
    @skill_level = SkillLevel.find(params[:id])
    @skill_level.destroy

    respond_to do |format|
      format.html { redirect_to(skill_levels_url) }
      format.xml  { head :ok }
    end
  end
end
