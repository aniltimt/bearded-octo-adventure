class AppCache

  @@cache = ActiveSupport::Cache::MemoryStore.new
  @@cache_blocks = {}

  def self.cached_method(cache_name, &block)
    @@cache_blocks[cache_name] = block
    self.instance_eval <<-EVAL
      def #{cache_name}
        @@cache.fetch(:#{cache_name}, &@@cache_blocks[:#{cache_name}])
      end
    EVAL
  end

  def self.reload!
    @@cache.clear
  end

  cached_method(:agent_role_id) { Usage::Role.find_by_name('sales agent').try(:id) }
  cached_method(:group_role_id) { Usage::Role.find_by_name('group').try(:id) }

end