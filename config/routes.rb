Clu2::Application.routes.draw do

  namespace :crm do
    resources :health_infos
  end

  resources :underwriting do
    collection do
      get 'ask'
      get 'guides'
      get 'questionnaires'
      get 'table_shave'
      get 'xrae'
    end
  end

  resources :sales_tools do
    collection do
      get 'calculators'
      get 'contracting'
      get 'planning'
      get 'productivity'
      get 'quoters'
      get 'training'
    end
  end

  resources :help do
    collection do
      get 'faq'
      get 'tutorials'
      get 'about'
      get 'suggestions'
      post 'post_suggestion'
    end
  end

  match "/login", :controller => "usage/user_sessions", :action => "new"
  match "/logout", :controller => "usage/user_sessions", :action => "destroy", :via => [:get, :delete]
  match "/signup", :controller => "usage/users", :action => "new"
  match "/tagging/tag_keys/home", :controller => "tagging/tag_keys", :action => "home"
  match "/new_connection_spouse", :controller => "crm/connections", :action => "new_connection_spouse"
  # TOP-LEVEL RESOURCES

  resources :address

  resources :contact_info

  resources :email_address

  resources :leads do
    collection {
      get 'diag'
      post 'diag'
    }
  end

  resources :website

  resources :home do
    collection do
      get 'get_states'
      put 'update_contact_info'
      get 'get_gender'
    end
  end

  resources :phone do
    collection do
      get 'get_phone_type'
    end
  end

  # NAMESPACES

  resources :email_address

  resources :contact_info

  namespace :usage do
    resources :notes
    resource :user_sessions, :only => [:new, :create, :destroy]

    resources :users, :only => [:new, :create, :update] do
      collection do
        get 'personal'
        post 'update_attribute'
        get 'autocomplete_users_first_name'
        get 'assign_agent'
        get 'permissions'
        get 'lead_distribution_rules'
        put 'assign_profile'
        get 'assign_profile_model'
        get 'tasks'
        get 'incomplete_tasks'
        get 'completed_tasks'
      end

      member do
        put 'update_agent_field_set'
        put "update_password"
      end

    end
    resources :lead_distribution_weights, :only => [:index, :update]
    resources :password_resets
    resources :profiles do
      collection do
        post 'select'
        put 'assign_profile'
        put 'remove_profile'
      end
    end
    resources :contracts
    resources :licenses
  end

  namespace :crm do

    resources :beneficiaries do
      collection do
        post 'update_attributes'
        post 'update_percentages'
      end
    end

    resources :financial_infos

    resources :activities do
      collection do
        get 'all_activity_statuses'
        get 'activities_between_dates'
      end
    end

    resources :notes

    get "status_types/index"

    get "status_types/new"

    post "status_types/create"

    get "status_types/edit"

    put "status_types/update"

    resources :auto_system_task_rules, :only => [:new, :create, :index]

    resources :cases do
      collection do
        get 'index'
        get 'prospects'
        get 'leads'
        get 'book_of_business'
        get 'details'
        get 'requirements'
        get 'owner'
        get 'exam_completion'
        get 'quoter_completion'
        get 'follow_up'
        get 'exam'
        get 'autocomplete_carrier_name'
        post 'update_details_attribute'
        post 'update_quote_param'
        get 'get_policy_types'
        post 'update_agent'
        post 'owners_update'
        post 'owner_contact_info_update'
        get 'get_owner_beneficiary_type'
      end
      member do
        get 'ezlink'
      end
    end

    resources :connections do
      collection do
        get 'health_completion'
        get 'personal_completion'
        get 'connection_summary'
        get 'connection_tags'
        get 'personal'
        get 'destroy_connection_tag'
        get 'prospects'
        get 'contacts'
        get 'get_marrital_statuses'
        get 'get_citizenships'
        post 'update_agent'
        get 'add_spouse'
        get 'autocomplete_connections_first_name'
        get 'financial'
        post 'financial_info_update'
        post 'connection_info_update'
        post 'contact_info_update'
        get 'tracking'
        get 'get_connection_types'
      end
      member do
        get 'financial'
        get 'health'
        get 'personal'
        get 'tracking'
      end
    end
    resources :spouses
    resources :statuses

    resources :system_tasks do
      collection do
        get 'dashboard'
        get 'cases_current_status_system_tasks'
        get 'sidebar'
      end
    end

  end

  namespace :marketing do
    get "campaigns/edit"
    get "campaigns/destroy"
    get "marketing_base/links"
    resources :campaigns

    get 'auto_task_rules/destroy'
    resources :auto_task_rules do
      collection do
        get 'autocomplete_marketing_campaigns_name'
        get 'autocomplete_auto_system_task_rules_name'
        get 'edit'
      end
    end

    resources :memberships do
      collection do
        get 'autocomplete_usage_user_first_name'
        get 'membership_templates'
      end
    end

    namespace :email do
      resources :templates do
        collection do
          get 'autocomplete_marketing_email_templates_name'
          get 'template_liquid_options'
          get 'clone_template'
        end
      end

      resources :messages do
        member do
          post 'send_message'
        end
      end

      resources :smtp_servers
    end

    namespace :snail_mail do
      resources :templates do
        collection do
          get 'autocomplete_marketing_snail_mail_templates_name'
          get 'template_liquid_options'
        end
      end
      resources :messages
    end

  end

  namespace :quoting do

    resources :quotes do
      collection { post 'bypass_health_analyzer' }
      member { get 'results' }
    end
    resources :leads do
      collection {
        get 'new_quote'
        post 'create_quote'
      }
    end
  end

  namespace :reporting do
    resources :memberships do
      collection do
        get 'autocomplete_usage_user_first_name'
      end
    end

    resources :searches do
      member do
        get 'results'
      end
      collection do
         get 'legacy_new'
         get 'legacy_edit'
         put 'legacy_update'
         get 'legacy_update'
         get 'legacy_index'
         post 'legacy_results'
         get 'legacy_results'
         get 'autocomplete_usage_user_login'
         get 'autocomplete_usage_role_name'
         get 'autocomplete_usage_user_first_name'
         get 'search_policy_create_date'
      end
    end
  end

  namespace :tagging do
    resources :tag_keys do
      member do
        get 'home'
      end
     end

     resources :memberships do
       collection do
         get 'autocomplete_usage_user_first_name'
       end
     end

    resources :tags do
      collection do
        post 'search'
        post 'create_multiple'
      end
     end
  end

  namespace :usage do
    resource :user_sessions, :only => [:new, :create, :destroy]
    resources :users, :only => [:new, :create, :update, :index] do
      collection do
        get 'personal'
        post 'update_attribute'
        get 'autocomplete_users_first_name'
        get 'assign_agent'
        get 'permissions'
        get 'lead_distribution_rules'
        post 'update_permissions'
        get 'search_users'
        get 'search_agency_users'
        get 'l_and_c'
        get 'memberships'
        post 'update_aml_vendor'
        post 'update_usage_license'
        get 'impersonate'
        get 'end_impersonate'
      end

      member do
        put 'update_agent_field_set'
      end

    end
    resources :lead_distribution_weights, :only => [:index, :update]
    resources :password_resets
    resources :profiles, only: [] do
      collection {post 'select'}
    end
    resources :contracts do
      collection do
        get 'autocomplete_usage_aml_vendor_name'
      end
    end
    resources :licenses do
      collection do
        get 'autocomplete_usage_user_first_name'
      end
    end
    get "staff_assignment/index"
    resources :staff_assignment do
      member do
        get 'new'
  get 'autocomplete_usage_user_first_name'
      end
      collection do
        post 'create'
     end
    end
   end
  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => 'home#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'

end
