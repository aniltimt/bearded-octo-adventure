class CreateUsageCommissionLevels < ActiveRecord::Migration

  def up
    execute('CREATE VIEW usage_commission_levels AS SELECT
            * FROM clu_enums.usage_commission_levels;')
  end

  def down
    execute('DROP VIEW IF EXISTS usage_commission_levels;')
  end

end
