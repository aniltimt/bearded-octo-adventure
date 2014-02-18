class CreateQuotingTliCategoryOptions < ActiveRecord::Migration
  def up
    execute('CREATE VIEW quoting_tli_category_options AS SELECT 
            * FROM clu_enums.quoting_tli_category_options;')
  end
  
  def down
    execute('DROP VIEW IF EXISTS quoting_tli_category_options;')
  end

end
