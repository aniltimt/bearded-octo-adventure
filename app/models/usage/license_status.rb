class Usage::LicenseStatus < CluEnum
  self.table_name = 'usage_license_statuses'
  self.primary_key = :id
  attr_accessible :value
end
