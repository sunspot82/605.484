class EngineersController < ApplicationController
  
  #
  # GET /engineers/tag
  #
  def tag
     @engineers = Engineer.find_tagged_with(params[:id]).paginate :per_page => 5, :page => params[:page], :order => 'id'    
     flash[:notice] = "Engineers tagged with '#{params[:id]}'"
     render(:action => :index)
  end  
  #
  # Updating similar engineers listing
  #
  def get_similar     
     similarity_scores = SimilarityScore.find(:all,:conditions=>["engineer_id_1 = ? OR engineer_id_2 = ?",params[:id],params[:id]],:limit => 5,:order => "score DESC")
     @scores = Array.new     
     similarity_scores.each do |similarity_score|
        other_engineer = similarity_score.engineer_id_1        
        other_engineer = similarity_score.engineer_id_2 if other_engineer == params[:id].to_i        
        @scores << [Name.find(other_engineer), sprintf("%.3f",similarity_score.score)]
     end
     
     render :update do |page|
        page.replace_html 'top_five_similar', :partial => "engineers/top_five_similar"
     end    
  end
  #
  #  GET /engineers/search
  #  GET /engineers/search.xml
  #  Performs a search operation based on the criteria specified
  #  in the request.
  #
  def search
     #logger.info("Called Search!")
     flash[:notice] = nil
     flash[:error] = nil
     # Build query string
     params[:name][:fname] = '%' if params[:name][:fname].empty?
     params[:name][:lname] = '%' if params[:name][:lname].empty?
     query = "fname like ? AND lname like ? AND years_of_experience >= ?"
     logger.info("skill: #{params[:skill][:id]}")
     if ! params[:skill][:id].empty?
        query = "#{query} AND skill_level_id = #{params[:skill][:id]}"
     end
     if ! params[:resume].nil? && ! params[:photo].nil?
        query = "#{query} AND role in ('#{get_resume_label}','#{get_picture_label}')"
     elsif ! params[:resume].nil?
        query = "#{query} AND role = '#{get_resume_label}'"
     elsif ! params[:photo].nil?
        query = "#{query} AND role = '#{get_picture_label}'"
     end
      
     # Execute query
     name_join = 'INNER JOIN names ON names.engineer_id = engineers.id'
     resources_join = 'LEFT JOIN resources ON resources.engineer_id = engineers.id'
     @engineers = Engineer.all(:joins=>[name_join,resources_join],:conditions => [query,params[:name][:fname], params[:name][:lname], params[:experience][:years]], :order => :id).paginate :per_page => 5, :page => params[:page]
     #flash[:notice] = "Query has returned #{@engineers.length} results." if ! @engineers.nil?
     respond_to do |format|
        format.html { render :action => 'index', :object => @engineers }
        format.xml { render :xml => @engineers }
     end
  end
   
  # GET /engineers
  # GET /engineers.xml
  def index
    logger.info("engineer index")
    @engineers = Engineer.paginate :per_page => 5, :page => params[:page], :order => 'id'
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @engineers }
    end
  end
  
  # GET /engineers/1
  # GET /engineers/1.xml
  def show
    @engineer = Engineer.find(params[:id])
    @picture = get_resource(get_picture_label)
    @resume = get_resource(get_resume_label)
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @engineer }
    end
  end

  # GET /engineers/new
  # GET /engineers/new.xml
  def new
    @engineer = Engineer.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @engineer }
    end
  end

  # GET /engineers/1/edit
  def edit
    @engineer = Engineer.find(params[:id])
    @picture = get_resource(get_picture_label)
    @resume = get_resource(get_resume_label)
  end

  # POST /engineers
  # POST /engineers.xml
  def create
    @engineer = Engineer.new(params[:engineer])
    @engineer.name = Name.new(params[:name])
    respond_to do |format|
      if @engineer.save        
        flash[:notice] = 'Engineer was successfully created.'
        format.html { redirect_to(@engineer) }
        format.xml  { render :xml => @engineer, :status => :created, :location => @engineer }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @engineer.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /engineers/1
  # PUT /engineers/1.xml
  def update
    @engineer = Engineer.find(params[:id])

    respond_to do |format|
      if @engineer.update_attributes(params[:engineer])
        flash[:notice] = 'Engineer was successfully updated.'
        format.html { redirect_to(@engineer) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @engineer.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /engineers/1
  # DELETE /engineers/1.xml
  def destroy
    @engineer = Engineer.find(params[:id])
    @engineer.destroy

    respond_to do |format|
      format.html { redirect_to(engineers_url) }
      format.xml  { head :ok }
    end
  end
private
  def get_resource(role)
     @engineer.resources.find_by_role(role)
  end
  def get_resume_label
     "resume"
  end
  def get_picture_label
     "picture"
  end
end
