# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Usage::User.find_or_create_by_role_id(
  Usage::Role.find_by_name('admin').id,
  :enabled => true,
  :login => 'admin', # Admin is someone at our office, not owner of license
  :password => '15974ea841c1821dd2591ac56a24c17f',
  :password_confirmation => '15974ea841c1821dd2591ac56a24c17f',
  :first_name => 'Admin',
  :nickname => 'Admin',
    contact_info_attributes: {
      company: 'Umbrella Corp.'
      },
  )

Usage::User.find_or_create_by_role_id(
  Usage::Role.find_by_name('developer').id,
  :enabled => true,
  :login => 'dev', # Developer is someone at our office, not licensee's office
  :password => 'correctHorseBatteryStaple',
  :password_confirmation => 'correctHorseBatteryStaple',
  :first_name => 'Admin',
  :nickname => 'Admin',
  contact_info_attributes: {
    company: 'Umbrella Corp.'
    },
  )