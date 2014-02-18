class CreatePhoneTypes < ActiveRecord::Migration
  def up
    execute('CREATE VIEW phone_types AS SELECT 
            * FROM clu_enums.phone_types;')
  end
  
  def down
    execute('DROP VIEW IF EXISTS phone_types;')
  end
end
