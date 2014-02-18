# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130429003346) do

  create_table "addresses", :force => true do |t|
    t.string   "value"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.integer  "contact_info_id"
  end

  create_table "carriers", :force => true do |t|
    t.string   "abbrev"
    t.string   "name"
    t.string   "compulify_code"
    t.boolean  "enabled"
    t.integer  "naic_code"
    t.integer  "smm_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "clu_enums", :id => false, :force => true do |t|
    t.string "title"
  end

  create_table "contact_infos", :force => true do |t|
    t.string   "company"
    t.integer  "preferred_contact_method_id"
    t.string   "fax"
    t.string   "city"
    t.integer  "state_id"
    t.string   "zip"
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
    t.string   "preferred_contact_time"
  end

  create_table "crm_activities", :force => true do |t|
    t.integer  "activity_type_id"
    t.integer  "connection_id"
    t.string   "description"
    t.integer  "foreign_key"
    t.integer  "owner_id"
    t.integer  "status_id"
    t.integer  "user_id"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "crm_activity_statuses", :id => false, :force => true do |t|
    t.integer "id",   :default => 0, :null => false
    t.string  "name"
  end

  create_table "crm_activity_types", :id => false, :force => true do |t|
    t.integer "id",   :default => 0, :null => false
    t.string  "name"
  end

  create_table "crm_auto_system_task_rules", :force => true do |t|
    t.integer  "role_id"
    t.integer  "task_type_id"
    t.integer  "template_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.integer  "delay"
    t.string   "label"
    t.string   "name"
    t.integer  "status_type_id"
  end

  create_table "crm_auto_user_task_rules", :force => true do |t|
    t.integer  "role_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.integer  "delay"
    t.string   "label"
    t.string   "name"
    t.integer  "status_type_id"
  end

  create_table "crm_beneficiaries", :force => true do |t|
    t.boolean  "contingent"
    t.integer  "percentage"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.date     "birth_or_trust_date"
    t.integer  "genre_id"
    t.string   "name"
    t.boolean  "gender"
    t.string   "relationship"
    t.text     "ssn"
    t.string   "trustee"
    t.integer  "case_id"
  end

  create_table "crm_beneficiary_or_owner_types", :id => false, :force => true do |t|
    t.integer "id",   :default => 0, :null => false
    t.string  "name"
  end

  create_table "crm_case_requirements", :force => true do |t|
    t.string   "name"
    t.string   "required_of"
    t.date     "ordered"
    t.date     "recieved"
    t.string   "requirement_type"
    t.string   "status"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "crm_cases", :force => true do |t|
    t.boolean  "active"
    t.integer  "agent_id"
    t.integer  "approved_details_id"
    t.float    "approved_premium_due"
    t.boolean  "bind"
    t.integer  "connection_id"
    t.boolean  "cross_sell"
    t.string   "current_insurance_amount"
    t.boolean  "equal_share_contingent_bens"
    t.boolean  "equal_share_primary_bens"
    t.string   "exam_company"
    t.string   "exam_num"
    t.string   "exam_status"
    t.datetime "exam_time"
    t.boolean  "insurance_exists"
    t.boolean  "ipo"
    t.string   "policy_number"
    t.date     "policy_period_expiration"
    t.integer  "quoted_details_id"
    t.integer  "status_id"
    t.integer  "submitted_details_id"
    t.integer  "submitted_qualified"
    t.boolean  "underwriter_assist"
    t.integer  "up_sell"
    t.datetime "created_at",                                                                   :null => false
    t.datetime "updated_at",                                                                   :null => false
    t.date     "effective_date"
    t.date     "termination_date"
    t.integer  "staff_assignment_id"
    t.integer  "owner_id"
    t.string   "reason"
    t.boolean  "esign",                                                     :default => true
    t.integer  "replaced_by_id"
    t.boolean  "insured_is_owner",                                          :default => false
    t.integer  "premium_payer_id"
    t.boolean  "insured_is_premium_payer",                                  :default => false
    t.decimal  "flat_extra",                  :precision => 8, :scale => 2
    t.integer  "flat_extra_years"
    t.decimal  "incl_1035",                   :precision => 8, :scale => 2
    t.boolean  "owner_is_premium_payer"
  end

  create_table "crm_citizenships", :id => false, :force => true do |t|
    t.integer "id",   :default => 0, :null => false
    t.string  "name"
  end

  create_table "crm_connection_types", :id => false, :force => true do |t|
    t.integer "id",   :default => 0, :null => false
    t.string  "name"
  end

  create_table "crm_connections", :force => true do |t|
    t.boolean  "active"
    t.integer  "agent_id"
    t.integer  "birth_state_id"
    t.string   "birth_country"
    t.integer  "citizenship_id"
    t.text     "critical_note"
    t.date     "dl_expiration"
    t.integer  "dl_state_id"
    t.string   "dln"
    t.boolean  "email_send_failed"
    t.string   "ip_address"
    t.integer  "marital_status_id"
    t.text     "note"
    t.string   "occupation"
    t.integer  "profile_id"
    t.text     "priority_note"
    t.integer  "product_type_id"
    t.string   "salutation"
    t.integer  "spouse_id"
    t.string   "ssn"
    t.string   "suffix"
    t.float    "years_at_address"
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
    t.integer  "connection_type_id"
    t.integer  "health_info_id"
    t.date     "birth"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "middle_name"
    t.boolean  "gender"
    t.string   "title"
    t.integer  "contact_info_id"
    t.integer  "financial_info_id"
    t.integer  "primary_contact_id"
    t.integer  "staff_assignment_id"
    t.string   "nickname"
    t.date     "anniversary"
    t.string   "relationship_to_agent"
    t.date     "relationship_to_agent_start"
    t.integer  "parent_id"
  end

  create_table "crm_contact_methods", :id => false, :force => true do |t|
    t.integer "id",   :default => 0, :null => false
    t.string  "name"
  end

  create_table "crm_ezl_joins", :force => true do |t|
    t.integer  "ezl_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.integer  "connection_id"
  end

  create_table "crm_financial_infos", :force => true do |t|
    t.integer  "asset_401k"
    t.integer  "asset_home_equity"
    t.integer  "asset_investments"
    t.integer  "asset_pension"
    t.integer  "asset_real_estate"
    t.integer  "asset_savings"
    t.integer  "liability_auto"
    t.integer  "liability_credit"
    t.integer  "liability_education"
    t.integer  "liability_estate_settlement"
    t.integer  "liability_mortgage"
    t.integer  "liability_other"
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
    t.integer  "net_worth"
    t.integer  "income"
    t.date     "bankruptcy"
    t.date     "bankruptcy_discharged"
    t.integer  "asset_total"
    t.integer  "liability_total"
  end

  create_table "crm_health_histories", :force => true do |t|
    t.boolean  "diabetes_1"
    t.boolean  "diabetes_2"
    t.boolean  "diabetes_neuropathy"
    t.boolean  "anxiety"
    t.boolean  "depression"
    t.boolean  "epilepsy"
    t.boolean  "parkinsons"
    t.boolean  "mental_illness"
    t.boolean  "alcohol_abuse"
    t.boolean  "drug_abuse"
    t.boolean  "elft"
    t.boolean  "hepatitis_c"
    t.boolean  "rheumatoid_arthritis"
    t.boolean  "asthma"
    t.boolean  "copd"
    t.boolean  "emphysema"
    t.boolean  "sleep_apnea"
    t.boolean  "crohns"
    t.boolean  "ulcerative_colitis_iletis"
    t.boolean  "weight_loss_surgery"
    t.boolean  "breast_cancer"
    t.boolean  "prostate_cancer"
    t.boolean  "skin_cancer"
    t.boolean  "internal_cancer"
    t.boolean  "atrial_fibrillations"
    t.boolean  "heart_murmur_valve_disorder"
    t.boolean  "irregular_heart_beat"
    t.boolean  "heart_attack"
    t.boolean  "stroke"
    t.boolean  "vascular_disease"
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
  end

  create_table "crm_health_infos", :force => true do |t|
    t.date     "birth"
    t.integer  "feet"
    t.boolean  "gender"
    t.integer  "inches"
    t.integer  "smoker"
    t.integer  "weight"
    t.integer  "cigarettes_per_month"
    t.integer  "cigars_per_month"
    t.date     "last_cigar"
    t.date     "last_cigarette"
    t.date     "last_nicotine_patch_or_gum"
    t.date     "last_pipe"
    t.date     "last_tobacco_chewed"
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
    t.integer  "bp_systolic"
    t.integer  "bp_diastolic"
    t.integer  "cholesterol"
    t.float    "cholesterol_hdl"
    t.date     "bp_control_start"
    t.date     "cholesterol_control_start"
    t.date     "last_bp_treatment"
    t.date     "last_cholesterol_treatment"
    t.boolean  "criminal"
    t.boolean  "hazardous_avocation"
    t.date     "last_dl_suspension"
    t.date     "last_dui_dwi"
    t.date     "last_reckless_driving"
    t.date     "penultimate_car_accident"
    t.integer  "moving_violation_history_id"
    t.integer  "health_history_id"
  end

  create_table "crm_moving_violation_histories", :force => true do |t|
    t.integer  "last_6_mo"
    t.integer  "last_1_yr"
    t.integer  "last_2_yr"
    t.integer  "last_3_yr"
    t.integer  "last_5_yr"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "crm_note_types", :id => false, :force => true do |t|
    t.integer "id",   :default => 0, :null => false
    t.string  "name"
  end

  create_table "crm_notes", :force => true do |t|
    t.boolean  "confidential"
    t.integer  "user_id"
    t.integer  "note_type_id"
    t.text     "text"
    t.string   "title"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.integer  "case_id"
    t.integer  "connection_id"
  end

  create_table "crm_opennesses", :id => false, :force => true do |t|
    t.integer "id",         :default => 0, :null => false
    t.string  "name"
    t.integer "sort_order"
  end

  create_table "crm_owners", :force => true do |t|
    t.string   "tin"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.date     "birth_or_trust_date"
    t.integer  "genre_id"
    t.string   "name"
    t.boolean  "gender"
    t.string   "relationship"
    t.string   "ssn"
    t.string   "trustee"
    t.integer  "case_id"
    t.integer  "contact_info_id"
  end

  create_table "crm_physician_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "crm_physicians", :force => true do |t|
    t.string   "address"
    t.string   "findings"
    t.date     "last_seen"
    t.string   "name"
    t.string   "phone"
    t.string   "reason"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.integer  "physician_type_id"
    t.integer  "years_of_service"
    t.integer  "connection_id"
  end

  create_table "crm_policy_types", :id => false, :force => true do |t|
    t.integer "id",                        :default => 0, :null => false
    t.string  "name",                                     :null => false
    t.integer "marketech_product_type_id",                :null => false
    t.integer "sort_order"
    t.boolean "active"
  end

  create_table "crm_status_types", :force => true do |t|
    t.string   "color"
    t.string   "name"
    t.integer  "sort_order"
    t.integer  "owner_id"
    t.integer  "ownership_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "crm_statuses", :force => true do |t|
    t.boolean  "active"
    t.integer  "case_id"
    t.integer  "created_by"
    t.boolean  "current"
    t.integer  "openness_id"
    t.integer  "status_type_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.integer  "system_task_id"
  end

  create_table "crm_system_task_types", :id => false, :force => true do |t|
    t.integer "id",   :default => 0, :null => false
    t.string  "name"
  end

  create_table "crm_system_tasks", :force => true do |t|
    t.integer  "assigned_to_id"
    t.integer  "created_by"
    t.string   "recipient"
    t.integer  "task_type_id"
    t.integer  "template_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.date     "completed_at"
    t.integer  "connection_id"
    t.date     "due_at"
    t.string   "label"
    t.integer  "status_id"
    t.integer  "owner_id"
    t.integer  "ownership_id"
  end

  create_table "crm_tasks", :force => true do |t|
    t.string   "label"
    t.integer  "task_type_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "crm_user_tasks", :force => true do |t|
    t.integer  "created_by"
    t.integer  "assigned_to"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.date     "completed_at"
    t.integer  "connection_id"
    t.date     "due_at"
    t.string   "label"
    t.integer  "status_id"
  end

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "email_addresses", :force => true do |t|
    t.string   "value"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.integer  "contact_info_id"
  end

  create_table "helps", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "marital_statuses", :id => false, :force => true do |t|
    t.integer "id",   :default => 0, :null => false
    t.string  "name"
  end

  create_table "marketing_auto_task_rules", :force => true do |t|
    t.integer  "campaign_id"
    t.integer  "auto_system_task_rule_id"
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
  end

  create_table "marketing_campaigns", :force => true do |t|
    t.integer  "owner_id"
    t.integer  "ownership_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.string   "name"
  end

  create_table "marketing_clq_templates", :id => false, :force => true do |t|
    t.integer "id",   :default => 0, :null => false
    t.string  "name"
    t.text    "body"
  end

  create_table "marketing_email_attachments", :force => true do |t|
    t.integer  "message_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
  end

  create_table "marketing_email_messages", :force => true do |t|
    t.string   "subject"
    t.integer  "template_id"
    t.string   "topic"
    t.text     "body"
    t.integer  "connection_id"
    t.integer  "profile_id"
    t.string   "recipient"
    t.integer  "sender_id"
    t.datetime "sent"
    t.integer  "failed_attempts"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.integer  "user_id"
  end

  create_table "marketing_email_smtp_servers", :force => true do |t|
    t.integer  "owner_id"
    t.integer  "ownership_id"
    t.string   "host"
    t.integer  "port"
    t.boolean  "ssl"
    t.string   "username"
    t.string   "address"
    t.text     "crypted_password"
    t.integer  "membership_id"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "marketing_email_templates", :force => true do |t|
    t.integer  "owner_id"
    t.integer  "ownership_id"
    t.text     "body"
    t.string   "subject"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
    t.string   "name"
    t.string   "description"
    t.boolean  "enabled"
    t.string   "thumbnail_file_name"
    t.string   "thumbnail_content_type"
    t.integer  "thumbnail_file_size"
    t.datetime "thumbnail_updated_at"
  end

  create_table "marketing_memberships", :force => true do |t|
    t.integer  "owner_id"
    t.integer  "ownership_id"
    t.boolean  "canned_template_privilege"
    t.boolean  "custom_template_privilege"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  create_table "marketing_message_media_messages", :force => true do |t|
    t.integer  "template_id"
    t.text     "body"
    t.integer  "connection_id"
    t.integer  "profile_id"
    t.string   "recipient"
    t.integer  "sender_id"
    t.datetime "sent"
    t.integer  "failed_attempts"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "marketing_message_media_templates", :force => true do |t|
    t.integer  "owner_id"
    t.integer  "ownership_id"
    t.text     "body"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.string   "name"
    t.string   "description"
    t.boolean  "enabled"
  end

  create_table "marketing_organizations", :force => true do |t|
    t.integer  "group_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "marketing_snail_mail_messages", :force => true do |t|
    t.text     "body"
    t.integer  "template_id"
    t.integer  "profile_id"
    t.string   "recipient"
    t.integer  "sender_id"
    t.integer  "user_id"
    t.integer  "connection_id"
    t.datetime "sent"
    t.integer  "failed_attempts"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "marketing_snail_mail_templates", :force => true do |t|
    t.string   "name"
    t.string   "body"
    t.string   "description"
    t.boolean  "enabled"
    t.integer  "owner_id"
    t.integer  "ownership_id"
    t.string   "thumbnail_file_name"
    t.string   "thumbnail_content_type"
    t.integer  "thumbnail_file_size"
    t.datetime "thumbnail_updated_at"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
  end

  create_table "marketing_tasks", :force => true do |t|
    t.integer  "campaign_id"
    t.integer  "client_id"
    t.integer  "system_task_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "marketing_vici_client_data", :force => true do |t|
    t.integer  "client_id"
    t.integer  "vici_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "ownerships", :id => false, :force => true do |t|
    t.integer "id",    :default => 0, :null => false
    t.string  "value"
  end

  create_table "phone_types", :id => false, :force => true do |t|
    t.integer "id",   :default => 0, :null => false
    t.string  "name"
  end

  create_table "phones", :force => true do |t|
    t.string   "ext"
    t.integer  "phone_type_id"
    t.string   "value"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.integer  "contact_info_id"
  end

  create_table "processing_agency_work_case_data", :force => true do |t|
    t.integer  "case_id"
    t.integer  "agency_works_id"
    t.boolean  "imported_to_agency_work"
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
  end

  create_table "processing_docusign_helper_case_data", :force => true do |t|
    t.integer  "case_id"
    t.integer  "envolope_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "processing_docusign_helper_templates", :force => true do |t|
    t.string   "clu_name"
    t.string   "docusign_template_name"
    t.string   "docusign_template_id"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
  end

  create_table "processing_exam_one_case_data", :force => true do |t|
    t.integer  "case_id"
    t.boolean  "info_sent"
    t.string   "or01_code"
    t.string   "schedule_now_code"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "processing_exam_one_control_codes", :force => true do |t|
    t.string  "carrier"
    t.integer "control_code"
    t.boolean "esign"
    t.boolean "ez_life_profile"
    t.string  "policy_type"
    t.string  "state"
    t.boolean "take_out_packet"
    t.string  "company_code"
  end

  create_table "processing_exam_one_statuses", :force => true do |t|
    t.integer  "case_id"
    t.string   "description"
    t.datetime "completed_at"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.integer  "connection_id"
    t.integer  "exam_one_status_id"
  end

  create_table "processing_igo_carrier_products", :force => true do |t|
    t.integer "carrier_id"
    t.string  "carrier_name"
    t.integer "product_id"
    t.string  "product_name"
    t.integer "product_type_id"
  end

  create_table "processing_smm_statuses", :force => true do |t|
    t.integer  "case_id"
    t.integer  "client_id"
    t.string   "desc"
    t.integer  "order_id"
    t.date     "scheduled"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "quoting_ltc_benefit_period_options", :id => false, :force => true do |t|
    t.integer "id",    :default => 0, :null => false
    t.string  "name"
    t.string  "value"
  end

  create_table "quoting_ltc_extra_field_sets", :force => true do |t|
    t.integer  "benefit_period_id"
    t.integer  "elimination_period"
    t.integer  "health_id"
    t.integer  "inflation_protection_id"
    t.integer  "quoter_id"
    t.boolean  "shared_benefit"
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
  end

  create_table "quoting_ltc_health_class_options", :id => false, :force => true do |t|
    t.integer "id",    :default => 0, :null => false
    t.string  "name"
    t.string  "value"
  end

  create_table "quoting_ltc_inflation_protection_options", :id => false, :force => true do |t|
    t.integer "id",    :default => 0, :null => false
    t.string  "name"
    t.string  "value"
  end

  create_table "quoting_moving_violations", :force => true do |t|
    t.date     "date"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.integer  "health_info_id"
  end

  create_table "quoting_neli_extra_field_sets", :force => true do |t|
    t.boolean  "hiv"
    t.boolean  "in_ltc_facility"
    t.boolean  "terminal"
    t.boolean  "tobacco"
    t.integer  "quoter_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "quoting_premium_mode_options", :id => false, :force => true do |t|
    t.integer "id",     :default => 0, :null => false
    t.string  "name"
    t.string  "value"
    t.integer "active"
  end

  create_table "quoting_quoter_types", :id => false, :force => true do |t|
    t.integer "id",                 :default => 0, :null => false
    t.string  "name",                              :null => false
    t.string  "pinney_quoter_code",                :null => false
  end

  create_table "quoting_quoters", :force => true do |t|
    t.integer  "client_id"
    t.integer  "coverage_amount"
    t.string   "income_option"
    t.boolean  "joint"
    t.date     "joint_birth"
    t.string   "joint_gender"
    t.string   "joint_health"
    t.integer  "joint_state_id"
    t.integer  "premium_mode_id"
    t.integer  "quoter_type_id"
    t.integer  "state_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.boolean  "married"
    t.integer  "health_info_id"
  end

  create_table "quoting_relatives_diseases", :force => true do |t|
    t.boolean  "basal_cell_carcinoma"
    t.boolean  "breast_cancer"
    t.boolean  "cardiovascular_disease"
    t.boolean  "cardiovascular_impairments"
    t.boolean  "cerebrovascular_disease"
    t.boolean  "colon_cancer"
    t.boolean  "coronary_artery_disease"
    t.boolean  "diabetes"
    t.boolean  "intestinal_cancer"
    t.boolean  "kidney_disease"
    t.boolean  "malignant_melanoma"
    t.boolean  "other_internal_cancer"
    t.boolean  "ovarian_cancer"
    t.boolean  "prostate_cancer"
    t.integer  "age_of_contraction"
    t.integer  "age_of_death"
    t.boolean  "parent"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
    t.integer  "health_info_id"
  end

  create_table "quoting_results", :force => true do |t|
    t.decimal  "annual_premium",            :precision => 8, :scale => 2
    t.integer  "carrier_id"
    t.string   "carrier_health_class"
    t.string   "plan_name"
    t.decimal  "planned_modal_premium",     :precision => 8, :scale => 2
    t.integer  "policy_type_id"
    t.integer  "user_id"
    t.datetime "created_at",                                              :null => false
    t.datetime "updated_at",                                              :null => false
    t.decimal  "monthly_premium",           :precision => 8, :scale => 2
    t.integer  "connection_id"
    t.integer  "quote_param_dyn_id"
    t.integer  "category_id"
    t.integer  "health_class_id"
    t.integer  "premium_mode_id"
    t.integer  "face_amount"
    t.string   "illustration_file_name"
    t.string   "illustration_content_type"
    t.integer  "illustration_file_size"
    t.datetime "illustration_updated_at"
  end

  create_table "quoting_spia_extra_field_sets", :force => true do |t|
    t.string   "income_option"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "quoting_spia_income_option_options", :id => false, :force => true do |t|
    t.integer "id",    :default => 0, :null => false
    t.string  "name",                 :null => false
    t.string  "value",                :null => false
  end

  create_table "quoting_tli_category_options", :id => false, :force => true do |t|
    t.integer "id",             :default => 0, :null => false
    t.string  "name"
    t.string  "compulife_code"
    t.boolean "active"
    t.integer "duration"
  end

  create_table "quoting_tli_health_class_options", :id => false, :force => true do |t|
    t.integer "id",    :default => 0, :null => false
    t.string  "name"
    t.string  "value"
  end

  create_table "quoting_tli_table_rating_options", :id => false, :force => true do |t|
    t.integer "id",     :default => 0, :null => false
    t.string  "name",                  :null => false
    t.integer "value",                 :null => false
    t.boolean "active"
  end

  create_table "reporting_lead_type_assignment_totals", :force => true do |t|
    t.integer  "count"
    t.integer  "lead_type"
    t.date     "start"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "reporting_lead_type_assignments_for_weeks", :force => true do |t|
    t.integer  "agent_id"
    t.integer  "lead_type"
    t.integer  "sun"
    t.integer  "mon"
    t.integer  "tue"
    t.integer  "wed"
    t.integer  "thu"
    t.integer  "fri"
    t.integer  "sat"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "reporting_legacy_searches", :force => true do |t|
    t.string   "search_name"
    t.string   "first_name"
    t.string   "middle_name"
    t.string   "last_name"
    t.string   "city"
    t.string   "zip"
    t.string   "phone"
    t.string   "email"
    t.string   "i_c"
    t.string   "status"
    t.string   "agent_name"
    t.string   "carrier_name"
    t.string   "lead_type"
    t.string   "app_status"
    t.integer  "age_from"
    t.integer  "age_to"
    t.integer  "state_id"
    t.integer  "owner_id"
    t.integer  "ownership_id"
    t.integer  "campaign_id"
    t.integer  "source"
    t.integer  "sales_support_id"
    t.integer  "profile_id"
    t.integer  "policy_type_id"
    t.integer  "face_amount_from"
    t.integer  "face_amount_to"
    t.integer  "annual_premium_from"
    t.integer  "annual_premium_to"
    t.integer  "status_category_id"
    t.integer  "status_id"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  create_table "reporting_memberships", :force => true do |t|
    t.integer  "owner_id"
    t.integer  "ownership_id"
    t.boolean  "canned_reports_privilege"
    t.boolean  "custom_reports_privilege"
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
  end

  create_table "reporting_search_condition_sets", :force => true do |t|
    t.string   "name"
    t.integer  "search_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "reporting_search_conditions", :force => true do |t|
    t.boolean  "current"
    t.date     "date_max"
    t.date     "date_min"
    t.integer  "search_field_id"
    t.integer  "search_condition_set_id"
    t.string   "text"
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
  end

  create_table "reporting_search_fields", :force => true do |t|
    t.boolean  "current"
    t.boolean  "date_range"
    t.string   "name"
    t.string   "other_enum_name"
    t.string   "other_enum_field"
    t.boolean  "text_field"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "reporting_searches", :force => true do |t|
    t.integer  "owner_id"
    t.integer  "ownership_id"
    t.string   "name"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.text     "query"
  end

  create_table "smokers", :id => false, :force => true do |t|
    t.integer "id",              :default => 0, :null => false
    t.string  "name",                           :null => false
    t.integer "compulife_value",                :null => false
  end

  create_table "states", :id => false, :force => true do |t|
    t.integer "id",             :default => 0, :null => false
    t.string  "abbrev"
    t.integer "compulife_code"
    t.string  "name"
    t.integer "tz_id"
  end

  create_table "tagging_auto_tag_rule_sets", :force => true do |t|
    t.integer  "auto_tag_rule_id"
    t.string   "name"
    t.integer  "tag_key_id"
    t.integer  "tag_value_id"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "tagging_auto_tag_rules", :force => true do |t|
    t.integer  "tag_key_id"
    t.integer  "tag_value_id"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
    t.integer  "auto_tag_rule_set_id"
    t.integer  "connection_pattern_id"
    t.integer  "user_pattern_id"
  end

  create_table "tagging_memberships", :force => true do |t|
    t.boolean  "custom_tags_privilege"
    t.integer  "owner_id"
    t.integer  "ownership_id"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
  end

  create_table "tagging_tag_keys", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.integer  "owner_id"
    t.integer  "ownership_id"
  end

  create_table "tagging_tag_rule_operators", :id => false, :force => true do |t|
    t.integer "id",   :default => 0, :null => false
    t.string  "name",                :null => false
  end

  create_table "tagging_tag_types", :id => false, :force => true do |t|
    t.integer "id",   :default => 0, :null => false
    t.string  "name",                :null => false
  end

  create_table "tagging_tag_values", :force => true do |t|
    t.string   "value"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "tagging_tags", :force => true do |t|
    t.integer  "tag_key_id"
    t.integer  "tag_value_id"
    t.integer  "tag_type_id"
    t.integer  "user_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.integer  "connection_id"
  end

  create_table "time_zones", :id => false, :force => true do |t|
    t.integer "id",     :default => 0, :null => false
    t.string  "name"
    t.integer "offset"
  end

  create_table "usage_agent_field_sets", :force => true do |t|
    t.boolean  "temporary_suspension"
    t.integer  "premium_limit"
    t.integer  "tz_max"
    t.integer  "tz_min"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
    t.integer  "aml_id"
  end

  create_table "usage_aml_vendors", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "usage_amls", :force => true do |t|
    t.date     "completion"
    t.integer  "vendor_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "usage_ascendents_descendents", :id => false, :force => true do |t|
    t.integer "ascendent_id"
    t.integer "descendent_id"
  end

  create_table "usage_commission_levels", :id => false, :force => true do |t|
    t.integer "id",   :default => 0, :null => false
    t.string  "name"
  end

  create_table "usage_contract_statuses", :id => false, :force => true do |t|
    t.integer "id",    :default => 0, :null => false
    t.string  "value",                :null => false
  end

  create_table "usage_contracts", :force => true do |t|
    t.integer  "carrier_id"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.string   "carrier_contract_id"
    t.boolean  "corporate"
    t.integer  "status_id"
    t.date     "effective_date"
    t.date     "expiration"
    t.integer  "agent_field_set_id"
    t.integer  "state_id"
    t.integer  "appointment"
  end

  create_table "usage_lead_distribution_weights", :force => true do |t|
    t.integer  "agent_id"
    t.integer  "tag_value_id"
    t.integer  "weight"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.integer  "premium_limit"
    t.integer  "countdown"
    t.integer  "lock_version"
  end

  create_table "usage_lead_distributions", :force => true do |t|
    t.integer  "count"
    t.date     "date"
    t.integer  "agent_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "usage_license_statuses", :id => false, :force => true do |t|
    t.integer "id",    :default => 0, :null => false
    t.string  "value"
  end

  create_table "usage_licenses", :force => true do |t|
    t.date     "expiration"
    t.boolean  "expiration_warning_sent"
    t.string   "number"
    t.integer  "status_id"
    t.integer  "state_id"
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
    t.boolean  "corporate"
    t.date     "effective_date"
    t.boolean  "home"
    t.boolean  "life"
    t.boolean  "p_and_c"
    t.boolean  "vehicle"
    t.integer  "agent_field_set_id"
  end

  create_table "usage_notes", :force => true do |t|
    t.text     "body"
    t.integer  "creator_id"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "usage_patterns", :force => true do |t|
    t.integer  "owner_id"
    t.integer  "ownership_id"
    t.string   "field_name"
    t.integer  "operator_id"
    t.integer  "model_for_pattern_id"
    t.string   "value"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
  end

  create_table "usage_profiles", :force => true do |t|
    t.string   "name"
    t.integer  "owner_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
    t.integer  "contact_info_id"
    t.integer  "ownership_id"
  end

  create_table "usage_profiles_users", :id => false, :force => true do |t|
    t.integer "profile_id"
    t.integer "user_id"
  end

  create_table "usage_roles", :id => false, :force => true do |t|
    t.integer "id",                                          :default => 0, :null => false
    t.string  "name"
    t.integer "can_have_children",              :limit => 1
    t.integer "can_edit_crm_core",              :limit => 1
    t.integer "can_edit_crm_status_meta",       :limit => 1
    t.integer "can_edit_descendents",           :limit => 1
    t.integer "can_edit_descendents_resources", :limit => 1
    t.integer "can_edit_nephews",               :limit => 1
    t.integer "can_edit_nephews_resources",     :limit => 1
    t.integer "can_edit_profiles",              :limit => 1
    t.integer "can_edit_self",                  :limit => 1
    t.integer "can_edit_siblings",              :limit => 1
    t.integer "can_edit_siblings_resources",    :limit => 1
    t.integer "can_view_descendents",           :limit => 1
    t.integer "can_view_descendents_resources", :limit => 1
    t.integer "can_view_nephews",               :limit => 1
    t.integer "can_view_nephews_resources",     :limit => 1
    t.integer "can_view_siblings",              :limit => 1
    t.integer "can_view_siblings_resources",    :limit => 1
    t.integer "can_edit_tags",                  :limit => 1
  end

  create_table "usage_sales_support_field_sets", :force => true do |t|
    t.string   "docusign_email"
    t.string   "docusign_account_id"
    t.string   "docusign_password"
    t.string   "metlife_agent_id"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  create_table "usage_staff_assignments", :force => true do |t|
    t.integer  "administrative_assistant_id"
    t.integer  "case_manager_id"
    t.integer  "manager_id"
    t.integer  "policy_specialist_id"
    t.integer  "sales_assistant_id"
    t.integer  "sales_coordinator_id"
    t.integer  "sales_support_id"
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
  end

  create_table "usage_users", :force => true do |t|
    t.integer  "agent_field_set_id"
    t.boolean  "enabled"
    t.string   "login"
    t.integer  "parent_id"
    t.integer  "role_id"
    t.string   "crypted_password"
    t.string   "password_salt"
    t.string   "persistence_token"
    t.string   "single_access_token"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "middle_name"
    t.date     "birth"
    t.boolean  "gender"
    t.boolean  "can_have_children"
    t.boolean  "can_edit_crm_core"
    t.boolean  "can_edit_crm_status_meta"
    t.boolean  "can_edit_crm_tags"
    t.boolean  "can_edit_profiles"
    t.boolean  "can_edit_self"
    t.boolean  "can_edit_siblings"
    t.boolean  "can_view_siblings"
    t.datetime "created_at",                                    :null => false
    t.datetime "updated_at",                                    :null => false
    t.string   "title"
    t.datetime "current_login_at"
    t.string   "current_login_ip"
    t.integer  "failed_login_count",             :default => 0, :null => false
    t.datetime "last_login_at"
    t.string   "last_login_ip"
    t.datetime "last_request_at"
    t.integer  "login_count",                    :default => 0, :null => false
    t.string   "perishable_token"
    t.integer  "sales_support_field_set_id"
    t.text     "note"
    t.integer  "manager_id"
    t.integer  "commission_level_id"
    t.string   "nickname"
    t.boolean  "can_view_siblings_resources"
    t.boolean  "can_edit_siblings_resources"
    t.boolean  "can_view_descendents"
    t.boolean  "can_edit_descendents"
    t.boolean  "can_view_descendents_resources"
    t.boolean  "can_edit_descendents_resources"
    t.boolean  "can_view_nephews"
    t.boolean  "can_edit_nephews"
    t.boolean  "can_view_nephews_resources"
    t.boolean  "can_edit_nephews_resources"
    t.integer  "contact_info_id"
    t.integer  "selected_profile_id"
    t.integer  "agent_of_record_id"
    t.date     "anniversary"
    t.integer  "staff_assignment_id"
  end

  create_table "websites", :force => true do |t|
    t.string   "url"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.integer  "contact_info_id"
  end

end
