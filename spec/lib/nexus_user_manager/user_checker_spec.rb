require 'nexus_user_manager/user_checker'

RSpec.describe 'NexusUserManager::UserChecker' do
  let(:api) { double }
  let(:user) { 'user1' }
  let(:users) { [{'userId'=>'user1'}, {'userId'=>'user2'}] }

  before(:each) do
    allow(api).to receive(:list_users).and_return(users)
    @user_checker = NexusUserManager::UserChecker.new(api)
  end

  describe '#users' do
    it 'gets the current user list from Nexus' do
      expect(api).to receive(:list_users)
      @user_checker.users
    end
  end

  describe '#exists?' do
    it 'returns true if the user exists in Nexus' do
      expect(@user_checker.exists?(user)).to eq(true)
    end

    it 'returns false if the user does not exist in Nexus' do
      expect(@user_checker.exists?('not_real')).to eq(false)
    end
  end
end
