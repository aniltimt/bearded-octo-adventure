class Processing::AgencyWorks::CaseData < ActiveRecord::Base
	attr_accessible :case_id, :agency_works_id, :imported_to_agency_work

	belongs_to :case, class_name: 'Crm::Case'

  #Explicit column definitions for rspec-fire
  def agency_works_id; super; end
end
