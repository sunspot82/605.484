# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)

noskill = SkillLevel.create(:name => "No Experience")
trained = SkillLevel.create(:name => "Trained")
experienced = SkillLevel.create(:name => "Experienced")

google = Organization.create(:name => "Google")
yahoo = Organization.create(:name => "Yahoo")
microsoft = Organization.create(:name => "Microsoft")
activision = Organization.create(:name => "Activision")

requirements = ProjectScope.create(:name => "Requirements")
design = ProjectScope.create(:name => "Design")
implementation = ProjectScope.create(:name => "Implementation")
testing = ProjectScope.create(:name => "Testing")
integration = ProjectScope.create(:name => "Integration")
maintenance = ProjectScope.create(:name => "Maintenance")

projects = ["SpringBoard", "Around the Bend", "Vantage Point", "Dream Catcher", "Four Corners"]

for h in (0..projects.length - 1)
   org_id = rand(4)
   Project.create(:name => projects[h], :description=> "Project", :organization_id => org_id)  
end

names = [ Name.new(:fname => "Larry" , :lname => "Simpleton"),
               Name.new(:fname => "Timmy" , :lname => "Thomas"),
               Name.new(:fname => "Sarah" , :lname => "Johnson"),
               Name.new(:fname => "Kenneth" , :lname => "Davis"),
               Name.new(:fname => "Jerry" , :lname => "Covington"),
               Name.new(:fname => "Tina" , :lname => "Michaels")
             ]

for i in (0..names.length - 1)
   exp = rand(10)
   skill_id = experienced.id
   if  exp <= 1
      skill_id = noskill.id
   elsif exp < 5
      skill_id = trained.id
   end
   e = Engineer.create(:years_of_experience => exp, :skill_level_id => skill_id)
   names[i].engineer_id = e.id
   names[i].save
end