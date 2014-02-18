# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :crm_financial_info, :class => 'Crm::FinancialInfo' do    
    asset_401k { rand(1000) * 10000 }
    asset_home_equity { rand(1000) * 10000 }
    asset_investments { rand(1000) * 10000 }
    asset_pension { rand(1000) * 10000 }
    asset_real_estate { rand(1000) * 10000 }
    asset_savings { rand(1000) * 10000 }
    income { rand(1000) * 1000 }
    liability_auto { rand(100) * 100 }
    liability_credit { rand(100) * 100 }
    liability_education { rand(100) * 100 }
    liability_estate_settlement { rand(100) * 100 }
    liability_mortgage { rand(100) * 100 }
    liability_other { rand(100) * 100 }
    net_worth { rand(1000) * 10000 }
  end
end
