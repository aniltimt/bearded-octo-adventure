class Processing::DocusignHelper::Template < ActiveRecord::Base
	include Processing::DocusignHelper

	attr_accessible :clu_name, :docusign_template_id, :docusign_template_name

	# ...
end
