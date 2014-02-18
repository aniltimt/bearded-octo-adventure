require 'spec_helper.rb'

describe 'parse_to_scope class Method' do

  describe 'with complex params' do
    
    describe 'without associations' do

      it 'works with multiple params formated %s=%s %s=%s %s=%s' do
        sql = Crm::Case.parse_to_scope("connection_id=1 active=true status_id=35").to_sql
        sql.should include('SELECT `crm_cases`.* FROM `crm_cases`')
        sql.should include('crm_cases.connection_id = 1')
        sql.should include('crm_cases.active = 1')
        sql.should include('crm_cases.status_id = 35')
      end

      it 'formats dates correctly' do
        sql = Crm::Case.parse_to_scope("created_at=2013-11-15").to_sql
        sql.should include("WHERE (crm_cases.created_at = '2013-11-15")
      end

      it 'formats integers correctly' do
        sql = Crm::Case.parse_to_scope("connection_id=1").to_sql
        sql.should include("WHERE (crm_cases.connection_id = 1)")
      end

      it 'formats booleans correctly' do
        sql = Crm::Case.parse_to_scope("active=true").to_sql
        sql.should include("WHERE (crm_cases.active = 1)")
      end

      it 'does not separate on quoted whitespace' do
        sql = Crm::Case.parse_to_scope("exam_company='foo bar'").to_sql
        sql.should include("WHERE (crm_cases.exam_company = 'foo bar')")
        sql = Crm::Case.parse_to_scope('exam_company="foo bar"').to_sql
        sql.should include("WHERE (crm_cases.exam_company = 'foo bar')")
      end

      it 'works with multiple operators' do
        sql = Crm::Case.parse_to_scope("connection_id<20 active=true status_id>=35").to_sql
        sql.should include("crm_cases.connection_id < 20")
        sql.should include("crm_cases.active = 1")
        sql.should include("crm_cases.status_id >= 35")
      end 
    end

    describe 'with associations' do

      it 'can check a field on a simple belongs_to association' do
        pending "Broken"
        rel = Crm::Case.parse_to_scope("connection.first_name=Barry")
        sql = rel.to_sql
        sql.should include("INNER JOIN `crm_connections` ON `crm_connections`.`id` = `crm_cases`.`connection_id`")
        sql.should include("WHERE (crm_connections.first_name = 'Barry')")
        rel.to_a.should be_a(Array)
      end

      it 'can check a field on a belongs_to association through another belongs_to association' do
        pending "Broken"
        rel = Crm::Case.parse_to_scope("connection.agent.first_name=Barry")
        sql = rel.to_sql
        sql.should include("INNER JOIN `crm_connections` ON `crm_connections`.`id` = `crm_cases`.`connection_id`")
        sql.should include("INNER JOIN `usage_users` ON `usage_users`.`id` = `crm_connections`.`agent_id`")
        sql.should include("WHERE (usage_users.first_name = 'Barry')")
        rel.to_a.should be_a(Array)
      end

      it 'can check a field on a simple has_many association' do
        rel = Crm::Case.parse_to_scope("statuses.id<50")
        sql = rel.to_sql
        sql.should include("INNER JOIN `crm_statuses` ON `crm_statuses`.`case_id` = `crm_cases`.`id`")
        sql.should include("WHERE (crm_statuses.id < 50)")
        rel.to_a.should be_a(Array)
      end
    end
  end 
end
