require 'app/services/similarity/content_processor'
require 'app/models/similarity_score'

class ResourceObserver < ActiveRecord::Observer
  
  def after_save(r)
      if r.role.casecmp("resume") == 0       
         puts "Processing Resume Resource..."
         p = ContentProcessor.new
         #puts "#{r.f.path}"
         content = IO.readlines(r.attachment.path)         
         user = "#{r.engineer_id}"
         #puts "user: #{user}"
         p.process_content(user,[content])
         
         # Get updated scores.
         scores = p.similarity_to_user(user,true)
         # cleanup old comparisons.
         SimilarityScore.delete_all(["engineer_id_1 = ? OR engineer_id_2 = ?",r.engineer_id,r.engineer_id])
         # Create new score entries.         
         scores.each do |user,score|
            # do database insertion.
            SimilarityScore.create(:engineer_id_1 => r.engineer_id,
                                           :engineer_id_2 => user,
                                          :score => score)
         end
      else
         puts "Resource is not a resume!"
      end      
   end   
end