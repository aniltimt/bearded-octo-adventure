require 'spec_helper'

describe TaggableStereotype do

  describe "viz. Crm::Connection" do

    #TODO: Fix these pending specs
    # before :all do
    #   Crm::Connection.taggable :foo, :bar, :baz, :qux
    #   @conn_a = FactoryGirl.create :crm_connection
    #   @conn_b = FactoryGirl.create :crm_connection
    #   @conn_c = FactoryGirl.create :crm_connection
    #   @conn_d = FactoryGirl.create :crm_connection
    #   @tag1 = Tagging::Tag.create_from_string 'foo=i', @conn_a
    #   @tag2 = Tagging::Tag.create_from_string 'bar=j', @conn_a
    #   @tag3 = Tagging::Tag.create_from_string 'foo=k', @conn_b
    #   @tag4 = Tagging::Tag.create_from_string 'bar=l', @conn_b
    #   @tag5 = Tagging::Tag.create_from_string 'foo=m', @conn_c
    #   @tag6 = Tagging::Tag.create_from_string 'bar=n', @conn_c
    #   @tag7 = Tagging::Tag.create_from_string 'foo=o', @conn_c
    #   @tag8 = Tagging::Tag.create_from_string 'bar=p', @conn_c
    # end

    it "should get the right value for #get_tag_value" do
      pending "Broken"
      @conn_a.get_tag_value(:foo).should == 'i'
      @conn_a.get_tag_value(:bar).should == 'j'
      @conn_b.get_tag_value(:foo).should == 'k'
      @conn_b.get_tag_value(:bar).should == 'l'
      @conn_c.get_tag_value(:foo).should == 'm'
      @conn_c.get_tag_value(:bar).should == 'n'
    end

    it "should get the right value for #foo and #bar" do
      pending "Broken"
      @conn_a.foo.should == 'i'
      @conn_a.bar.should == 'j'
      @conn_b.foo.should == 'k'
      @conn_b.bar.should == 'l'
      @conn_c.foo.should == 'm'
      @conn_c.bar.should == 'n'
      @conn_d.foo.should == nil
      @conn_d.bar.should == nil
      Tagging::Tag.create tag_key: @tag1.tag_key, tag_value: @tag1.tag_value, connection: @conn_d
      Tagging::Tag.create tag_key: @tag4.tag_key, tag_value: @tag4.tag_value, connection: @conn_d
      @conn_d.foo.should == 'i'
      @conn_d.bar.should == 'l'
    end
  end

  describe "viz. Usage::User" do
    it "should get the right value for #baz and #qux" do
      pending "Broken"
      Usage::User.taggable :foo, :bar, :baz, :qux
      @user = FactoryGirl.create :usage_user
      @tag_baz = Tagging::Tag.create_from_string 'baz=thisval', @user
      @tag_qux = Tagging::Tag.create_from_string 'qux=thatval', @user
      @tag_baz.tag_key.name.should == 'baz'
      @tag_baz.tag_value.value.should == 'thisval'
      @tag_qux.tag_key.name.should == 'qux'
      @tag_qux.tag_value.value.should == 'thatval'
      @user.foo.should == nil
      @user.bar.should == nil
      @user.get_tag_value(:baz).should == 'thisval'
      @user.baz.should == 'thisval'
      @user.get_tag_value(:qux).should == 'thatval'
      @user.qux.should == 'thatval'
    end
  end

end
