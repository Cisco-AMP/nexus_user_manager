require 'nexus_user_manager/privilege_checker'

RSpec.describe 'NexusUserManager::PrivilegeChecker' do
  let(:api) { double }
  let(:privilege) { 'p1' }
  let(:privileges) { [{'name'=>'p1'}, {'name'=>'p2'}] }

  before(:each) do
    allow(api).to receive(:list_privileges).and_return(privileges)
    @privilege_checker = NexusUserManager::PrivilegeChecker.new(api)
  end

  describe '#privileges' do
    it 'gets the current privilege list from Nexus' do
      expect(api).to receive(:list_privileges)
      @privilege_checker.privileges
    end
  end

  describe '#verify' do
    it 'returns true if the privilege exists in Nexus' do
      expect(@privilege_checker.verify(privilege)).to eq(true)
    end

    it 'returns false if the privilege does not exist in Nexus' do
      expect(@privilege_checker.verify('not_real')).to eq(false)
    end
  end
end
