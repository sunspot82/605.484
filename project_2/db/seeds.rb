# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)
#mail_ext = "@mailserver.net"
#User.create(:login=>'user1',:email=>"user1",:email =>"user1" + mail_ext)
fNames = %w[Dave Larry Brian Victor Pete Sam Justin Eric Tim Jesse Paul Bill William Terry Cindy Sally Tina Tiffany Tonya]
lNames = %w[Smith Davenport Michaels Rodgers Kibler Johnson Jacobs Jackson]
skills = Array.new
skills << SkillLevel.create(:name => 'No Experience',
                       :description => 'Has no prior experience.')
skills << SkillLevel.create(:name => 'Novice',
                       :description => 'Has some prior experience or only class room training.')
skills << SkillLevel.create(:name => 'Experienced',
                       :description => 'Has lots of on the job experience.')
engineers = Array.new
for i in (1..20)   
   fname = "#{fNames[i % fNames.length]}"
   lname  = "#{lNames[i % lNames.length]}"
   e = Engineer.create(:name => fname + " " + lname,
                      :years_of_experience => rand(10),
                      :skill_level_id => skills[rand(skills.length)].id)
   #User.create(:login=>fname,:name=>fname+" "+lname,:email =>fname+"@apl.jhu.edu",:password=>fname,:password_confirmation=>fname,:engineer => e)
   engineers << e
   #photo = Resource.new
   #photo.role = "Photo"
   #photo.f = File.new("public\\images\\alfred_hitchcock-clear.gif","r")
   #photo.engineer = engineers[i-1]
   #photo.save!
   puts "Created [login=#{fname};password=#{fname}]"
end

organizations = Array.new
organizations << Organization.create(:name => "Verizon")
organizations << Organization.create(:name => "Comcast")
organizations << Organization.create(:name => "Google")
organizations << Organization.create(:name => "Apple")

projects = Array.new
projects << Project.create(:name => "Hide-N-Seek",
                            :organization_id => organizations[1].id)
projects << Project.create(:name => "Future Endevours",
                            :organization_id => organizations[0].id)

scopes = Array.new
scopes << ProjectScope.create(:name=>"Maintenance")
scopes << ProjectScope.create(:name=>"Integration")
scopes << ProjectScope.create(:name=>"Testing")
scopes << ProjectScope.create(:name=>"Development")
scopes << ProjectScope.create(:name=>"Requirements")

start_date = Date.today

# Engineer 1 assigned to project 2 scope A
ProjectAssignment.create(:start_date => start_date,
                                   :end_date => start_date.step(100),
                                   :project_scope_id => scopes[0].id,
                                   :engineer_id => engineers[0].id,
                                   :project_id => projects[1].id)
# Engineer 2 assigned to project 2 scope B
ProjectAssignment.create(:start_date => start_date,
                                   :end_date => start_date.step(100),
                                   :project_scope_id => scopes[1].id,
                                   :engineer_id => engineers[1].id,
                                   :project_id => projects[1].id)
# Engineer 1 assigned to project 1 scope A
ProjectAssignment.create(:start_date => start_date,
                                   :end_date => start_date.step(100),
                                   :project_scope_id => scopes[0].id,
                                   :engineer_id => engineers[1].id,
                                   :project_id => projects[0].id)
