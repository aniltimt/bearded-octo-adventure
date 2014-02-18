class CreateMarketingClqTemplates < ActiveRecord::Migration
  def up
    execute('CREATE VIEW marketing_clq_templates AS SELECT 
            * FROM clu_enums.marketing_clq_templates;')
  end
  
  def down
    execute('DROP VIEW IF EXISTS marketing_clq_templates;')
  end
end
