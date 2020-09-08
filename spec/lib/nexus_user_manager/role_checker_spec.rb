require 'nexus_user_manager/role_checker'

RSpec.describe 'NexusUserManager::RoleChecker' do
  let(:api) { double }
  let(:role) { 'role1' }
  let(:roles) { [{'id'=>'role1'}, {'id'=>'role2'}] }

  before(:each) do
    allow(api).to receive(:list_roles).and_return(roles)
    @role_checker = NexusUserManager::RoleChecker.new(api)
  end

  describe '#roles' do
    it 'gets the current role list from Nexus' do
      expect(api).to receive(:list_roles)
      @role_checker.roles
    end
  end

  describe '#exists?' do
    it 'returns true if the role exists in Nexus' do
      expect(@role_checker.exists?(role)).to eq(true)
    end

    it 'returns false if the role does not exist in Nexus' do
      expect(@role_checker.exists?('not_real')).to eq(false)
    end
  end
end
