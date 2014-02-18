require 'active_record_base_sample.rb'

namespace :enums do
	
	namespace :reload do
	
		task :all => :environment do
			reload 'development'
			Rake::Task['enums:reload:test'].invoke
		end
	
		task :test => :environment do
			reload 'test'
		end

	end
	
	task :reload => :environment do
		reload
	end

end

# Override/augment db:test:prepare so as not to lose our enum data in our views
namespace :db do
	namespace :test do
		task :prepare do
			Rake::Task['enums:reload:test'].invoke
		end
	end

	task :truncate => :environment do
		tables = ActiveRecord::Base.connection.execute('SHOW FULL TABLES')
		tables.each{ |tab|
			if tab[1] =~ /BASE TABLE/i
				ActiveRecord::Base.connection.execute "TRUNCATE #{tab[0]}"
  			ActiveRecord::Base.connection.execute "ALTER TABLE #{tab[0]} AUTO_INCREMENT = 1"
  		end			
		}
	end

	namespace :seed do 
	  task :dummy => :environment do
	  	# require factories
	  	require 'factory_girl_rails'
	  	tag_keys = ['source','campaign','referrer','deep purple']
		  tag_values = [nil,'arf','qrf','foo','bar','baz','qux','daisy chain']

      # define procs
      CALC_PREMIUM_LIMIT = lambda{ rand(10) ** rand(3) * 100000 }
      MAX_COUNTDOWN = 4

	    # create users around @user
      Usage::User.where(login:'username').destroy_all
	    @user = FactoryGirl.create :usage_user_w_assoc, role:Usage::Role.find_by_name('developer'), login:'username', password:'password', password_confirmation:'password'      
	    @user.update_attributes login:'username'
	    @group = FactoryGirl.create :usage_user, role:Usage::Role.find_by_name('group'), parent:@user
	    @agents = [@user]
	    @agents += FactoryGirl.create_list :usage_user_w_assoc, 2, role:Usage::Role.find_by_name('agent'), parent:@user
	    @agents += FactoryGirl.create_list :usage_user_w_assoc, 2, role:Usage::Role.find_by_name('agent'), parent:@group
			@connections = []
			@cases = []
      # create, assign children for @agents
	    @agents.each{ |agent|
		    FactoryGirl.create_list :usage_user_w_assoc, rand(4), parent:agent
	    }

      # create Profiles for users
      FactoryGirl.create_list :usage_profile_w_assoc, 2, owner_id:@user.id
      Usage::User.all.each do |user|
        FactoryGirl.create_list :usage_profile_w_assoc, rand(4), owner_id:user.id
      end
      
      # create system-wide StatusTypes
      FactoryGirl.create_list :crm_status_type, 9
      
      # create Connections for agents
      @agents.each{ |agent|
        @connections += FactoryGirl.create_list :crm_connection_w_assoc, rand(4), agent:agent
      }
      # create Connections for @user
      (1..Crm::ConnectionType.count).each{ |type_id|
        FactoryGirl.create_list :crm_connection_w_assoc, 2, agent:@user, connection_type_id:type_id
      }

      # create Cases and lead types
	    @connections.each{ |conn|
	    	# create, assign cases for connections
	    	@cases += FactoryGirl.create_list :crm_case_w_assoc, rand(4), crm_connection:conn
		    # create, assign tags for connections
		    rand(5).times{ conn.set_tag tag_keys.sample, tag_values.sample }
		  	# create lead types, assign to connections
		  	lead_type_name = tag_values.sample
		  	conn.set_tag('lead type', lead_type_name) if lead_type_name.present?
	    }
      # create Cases for @user.connections
      @user.crm_connections.where(connection_type_id: Crm::ConnectionType.where(name:['lead', 'client'])).each { |conn|
        FactoryGirl.create_list :crm_case_w_assoc, 2+rand(2), crm_connection:conn
        # create, assign tags for connections
        (2+rand(2)).times{ conn.set_tag tag_keys.sample, tag_values.sample }
        # create lead types, assign to connections
        lead_type_name = tag_values.sample
        conn.set_tag('lead type', lead_type_name) if lead_type_name.present?
      }

      # get lead types
      lead_types = Tagging::TagValue.joins(:tags => :tag_key).where("tagging_tag_keys.name = ?", 'lead type')

      # iterate through agents
      @agents.each_with_index{ |agent, i|
        # create lead distribution weights for users and lead types
        lead_types.each{ |lead_type|
          agent.lead_distribution_weights.create countdown:rand(MAX_COUNTDOWN), premium_limit:CALC_PREMIUM_LIMIT.call, tag_value:lead_type, weight:rand(MAX_COUNTDOWN)
        }
        # add agent field set
        agent.create_agent_field_set unless agent.agent_field_set.present?
        # add premium limit
        agent.agent_field_set.update_attributes premium_limit:CALC_PREMIUM_LIMIT.call
        # create licenses for agents      
        license_count = (State.count / @agents.length * 1.25).to_i
        first_license = license_count * i
        last_license = license_count + first_license
        (first_license...last_license).each do |idx|
          state_id = (idx % State.count) + 1
          new_license = Usage::License.create agent_field_set_id:agent.agent_field_set_id, number:'qwerty', state_id:state_id
          agent.agent_field_set.licenses << new_license
        end
      }	    
	  end
	end
end

def db_name env=nil
	env ||= Rails.env
	@db_name ||= Rails.configuration.database_configuration[env]['database']
end

def get_enum_names
	fpath = File::join(Rails.root, 'db/clu_enums.sql')
	arr = File::read(fpath).scan(/DROP TABLE IF EXISTS `(\w+)`/)
	arr.map{|o| o.first}
end

def reload env
	db = db_name(env)
	get_enum_names.each do |t|
			ActiveRecord::Base.connection.execute "drop view if exists #{db}.#{t};"
			ActiveRecord::Base.connection.execute "drop table if exists #{db}.#{t};"
			ActiveRecord::Base.connection.execute "CREATE VIEW #{db}.#{t} AS SELECT * FROM clu_enums.#{t};"
		end
end
