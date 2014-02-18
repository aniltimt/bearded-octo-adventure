class CreateCrmContactMethods < ActiveRecord::Migration
  def up
    execute('CREATE VIEW crm_contact_methods AS SELECT
            * FROM clu_enums.crm_contact_methods;')
  end

  def down
    execute('DROP VIEW IF EXISTS crm_contact_methods;')
  end
end
