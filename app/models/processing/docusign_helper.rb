module Processing
	module DocusignHelper
		def self.table_name_prefix
    	'processing_docusign_helper_'
  	end
		
		extend ActiveSupport::Concern
		
    # you can include other things here
    included do
      # ... include other modules.
    end
 
    # include class methods here
    module ClassMethods
			def eligible?
				# ...
			end

			def send_case
				# ...
			end
    end
 
	end
end
