require 'nexus_user_manager'

RSpec.describe 'NexusUserManager::Manager' do
  before(:each) do
    @manager = NexusUserManager::Manager.new
  end

  let(:role1) { double }
  let(:role2) { double }
  let(:roles) { [role1, role2] }
  let(:user1) { double }
  let(:user2) { double }
  let(:users) { [user1, user2] }

  describe '#user_checker' do
    before(:each) do
      api = double
      allow(api).to receive(:list_users).and_return([])
      @manager.nexus_api = api
    end

    it 'creates a new UserChecker object' do
      expect(@manager.user_checker).to be_a(NexusUserManager::UserChecker)
    end

    it 'reuses the same object if it exists' do
      test_object = @manager.user_checker
      expect(@manager.user_checker).to be(test_object)
    end
  end

  describe '#role_checker' do
    before(:each) do
      api = double
      allow(api).to receive(:list_roles).and_return([])
      @manager.nexus_api = api
    end

    it 'creates a new RoleChecker object' do
      expect(@manager.role_checker).to be_a(NexusUserManager::RoleChecker)
    end

    it 'reuses the same object if it exists' do
      test_object = @manager.role_checker
      expect(@manager.role_checker).to be(test_object)
    end
  end

  describe '#privilege_checker' do
    before(:each) do
      api = double
      allow(api).to receive(:list_privileges).and_return([])
      @manager.nexus_api = api
    end

    it 'creates a new PrivilegeChecker object' do
      expect(@manager.privilege_checker).to be_a(NexusUserManager::PrivilegeChecker)
    end

    it 'reuses the same object if it exists' do
      test_object = @manager.privilege_checker
      expect(@manager.privilege_checker).to be(test_object)
    end
  end

  describe '#required_roles' do
    it 'returns an array of roles' do
      roles = @manager.required_roles
      expect(roles).to be_a(Array)
      expect(roles.first).to be_a(NexusUserManager::Role)
    end
  end

  describe '#create_required_roles' do
    it 'does not create roles if there are none' do
      expect(@manager).to receive(:required_roles).and_return([])
      expect { @manager.create_required_roles }.to output(/no roles/i).to_stdout
    end

    it 'creates required roles' do
      allow(role1).to receive(:name).and_return('nx_role1')
      allow(role2).to receive(:name).and_return('nx_role2')
      allow(@manager).to receive(:required_roles).and_return(roles)
      expect(role1).to receive(:create).and_return(true)
      expect(role2).to receive(:create).and_return(true)
      @manager.create_required_roles
    end
  end

  describe '#find_objects' do
    it 'prints a warning when no matching objects are found' do
      allow(@manager).to receive(:required_roles).and_return([])
      expect { expect(@manager.find_objects('name', ['role1'])).to eq([]) }
        .to output(/warning: no role/i).to_stdout
    end

    it 'prints a warning when multiple matching objects are found' do
      allow(role1).to receive(:name).and_return('role')
      allow(role2).to receive(:name).and_return('role')
      allow(@manager).to receive(:required_roles).and_return([role1, role2])
      expect { expect(@manager.find_objects('name', ['role'])).to eq([]) }
        .to output(/warning: multiple role/i).to_stdout
    end

    it 'returns the matching objects' do
      allow(role1).to receive(:name).and_return('role1')
      allow(role2).to receive(:name).and_return('role2')
      allow(@manager).to receive(:required_roles).and_return([role1, role2])
      expect(@manager.find_objects('name', ['role1'])).to eq([role1])
    end
  end

  describe '#required_users' do
    it 'returns an array of users' do
      users = @manager.required_users
      expect(users).to be_a(Array)
      expect(users.first).to be_a(NexusUserManager::User)
    end
  end

  describe '#create_required_users' do
    it 'does not create users if there are none' do
      expect(@manager).to receive(:required_users).and_return([])
      expect { @manager.create_required_users }.to output(/no users/i).to_stdout
    end

    it 'creates required users' do
      allow(user1).to receive(:name).and_return('nx_user1')
      allow(user2).to receive(:name).and_return('nx_user2')
      allow(@manager).to receive(:required_users).and_return(users)
      expect(user1).to receive(:create).and_return(true)
      expect(user2).to receive(:create).and_return(true)
      @manager.create_required_users
    end
  end
end