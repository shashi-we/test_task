require 'spec_helper'

describe ConfigSetting do
	
  it "should return nil" do
		ConfigSetting.new_key.should be_nil
	end

	it "should save string value" do
		ConfigSetting.email = 'surendra@email.com'
		ConfigSetting.count.should == 1
		ConfigSetting.email.should == 'surendra@email.com'
	end

	it "should save integer value" do
		ConfigSetting.login_count = 7
		ConfigSetting.login_count.should == 7
	end

	it "should save float value" do
		ConfigSetting.subscription_charge = 49.99
		ConfigSetting.subscription_charge.should == 49.99
	end

	it "should save boolean value" do
		ConfigSetting.is_admin = true
		ConfigSetting.is_admin.should == true
	end

	it "should not save array value" do
		ConfigSetting.week_days = ['Sun','Mon','Tues','Wed']
		ConfigSetting.find_by_key('week_days').value.should be_nil
	end

	it "should update setting" do
		ConfigSetting.email = 'surendra@email.com'
		ConfigSetting.count.should == 1
		ConfigSetting.email = 'surendra-new@email.com'
		ConfigSetting.count.should == 1
		ConfigSetting.email.should == 'surendra-new@email.com'
	end
	
	it "should delete" do
		ConfigSetting.email = 'surendra@email.com'
		val = ConfigSetting.delete('email')
		ConfigSetting.count.should == 0
		val.should == 'surendra@email.com'
	end

	it "should cache" do
		ConfigSetting.email = 'surendra@email.com'
		ConfigSetting.should_not_receive(:find_by_key)
		ConfigSetting.email.should == 'surendra@email.com'
	end
end
