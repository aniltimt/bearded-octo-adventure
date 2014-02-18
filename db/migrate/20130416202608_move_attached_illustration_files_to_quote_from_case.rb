class MoveAttachedIllustrationFilesToQuoteFromCase < ActiveRecord::Migration
  def up
    add_attachment :quoting_results, :illustration
  end

  def down
    remove_attachment :quoting_results, :illustration
  end
end
