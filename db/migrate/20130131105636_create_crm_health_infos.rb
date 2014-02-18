class CreateCrmHealthInfos < ActiveRecord::Migration
  def change
    create_table :crm_health_infos do |t|
      t.date :birth
      t.integer :feet
      t.boolean :gender
      t.integer :inches
      t.integer :smoker
      t.integer :weight
      t.integer :cigarettes_per_month
      t.integer :cigars_per_month
      t.date :last_cigar
      t.date :last_cigarette
      t.date :last_nicotine_patch_or_gum
      t.date :last_pipe
      t.date :last_tobacco_chewed

      t.timestamps
    end
  end
end
