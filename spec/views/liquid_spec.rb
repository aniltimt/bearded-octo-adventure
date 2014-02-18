require 'spec_helper'

describe Crm::Connection do

  #TODO: Fix these
  # before :all do
  #   conn = FactoryGirl.build :crm_connection
  #   conn.contact_info = FactoryGirl.build :contact_info
  #   conn.contact_info.emails = FactoryGirl.build_list :email_address, 3
  #   conn.contact_info.phones = FactoryGirl.build_list :phone, 3
  #   conn.contact_info.addresses = FactoryGirl.build_list :address, 3
  #   conn.contact_info.state = FactoryGirl.build :state
  #   @conn = conn
  # end

  # it 'should have working contact-info convenience methods' do
  #   conn = @conn
  #   [:email, :address].each do |sym|
  #     sym_pl = sym.to_s.pluralize
  #     conn.send(sym).should == conn.contact_info.send(sym_pl)[0].value
  #     conn.contact_info.send(sym_pl)[1..-1].should_not include(conn.send(sym))
  #   end
  #   conn.phone.should == conn.contact_info.phones.first.to_s
  #   conn.contact_info.phones[1..-1].map(&:to_s).should_not include(conn.phone)
  #   [:city, :state, :zip].each do |sym|
  #     conn.send(sym).should == conn.contact_info.send(sym)
  #   end
  # end

  # it 'should render contact info with liquid' do
  #   pending "Broken"
  #   template = Liquid::Template.parse %q(
  #     {{connection.city}}
  #     {{connection.state.abbrev}}
  #     {{connection.phone}}
  #     {{connection.email}}
  #     )
  #   template.render('connection' => @conn).should == %Q(
  #     #{@conn.contact_info.city}
  #     #{@conn.contact_info.state.abbrev}
  #     #{@conn.contact_info.phones.first.to_s}
  #     #{@conn.contact_info.emails.first.value}
  #     )
  # end

end
