require 'nexus_user_manager/privilege'

RSpec.describe 'NexusUserManager::Privilege' do
  let(:name) { 'name' }

  describe '#name' do
    it 'returns the privilege name' do
      privilege = NexusUserManager::Privilege.new(name)
      expect(privilege.name).to eq(name)
    end
  end
end
