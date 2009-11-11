# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
   include TagsHelper  
   
   def image?(file_type)      
      %w[application/pdf 
            image/jpg
            image/png
            image/gif
            image/tiff
            image/jpeg
            image/pjpeg].include?(file_type)  
   end
end
