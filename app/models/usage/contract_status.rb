class Usage::ContractStatus < CluEnum
  self.table_name = 'usage_contract_statuses'
  self.primary_key = :id
  attr_accessible :value
end
