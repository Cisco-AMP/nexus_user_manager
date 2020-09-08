require 'nexus_user_manager/role'
require 'nexus_user_manager/privilege'

RSpec.describe 'NexusUserManager::Role' do
  let(:name) { 'name' }
  let(:p1) { 'p1' }
  let(:p2) { 'p2' }
  let(:privileges) { [p1, p2] }
  let(:role_checker) { double }
  let(:privilege_checker) { double }

  before(:each) do
    @role = NexusUserManager::Role.new(name, privileges, role_checker, privilege_checker)
  end

  describe '#name' do
    it 'returns the role name' do      
      expect(@role.name).to eq(name)
    end
  end

  describe '#privileges' do
    it 'returns an array of role privileges' do
      @role.privileges.each do |privilege|
        expect(privilege).to be_a(NexusUserManager::Privilege)
      end
    end
  end

  describe '#privilege_names' do
    it 'returns all the privileges by name' do
      expect(@role.privilege_names).to eq(privileges)
    end
  end

  describe '#setup_role?' do
    it 'returns false if a role already exists' do
      allow(role_checker).to receive(:exists?).and_return(true)
      expect(@role.setup_role?).to be(false)
    end

    it 'returns false if not all required privileges exist' do
      allow(role_checker).to receive(:exists?).and_return(false)
      allow(privilege_checker).to receive(:verify).and_return(true, false, true, false)
      expect { @role.setup_role? }.to output(/p2/).to_stdout
      expect { @role.setup_role? }.to_not output(/p1/).to_stdout
      expect(@role.setup_role?).to be(false)
    end

    it 'returns true if all required privileges exist' do
      allow(role_checker).to receive(:exists?).and_return(false)
      allow(privilege_checker).to receive(:verify).and_return(true)
      expect(@role.setup_role?).to be(true)
    end
  end

  describe '#create' do
    let(:api) { double }

    it 'creates a role if prerequisites are met' do
      allow(@role).to receive(:setup_role?).and_return(true)
      expect(api).to receive(:create_role).and_return(true)
      expect { @role.create(api) }.to output(/created/i).to_stdout
    end

    it 'prints failure when role is not created successfully' do
      allow(@role).to receive(:setup_role?).and_return(true)
      expect(api).to receive(:create_role).and_return(false)
      expect { @role.create(api) }.to output(/failed/i).to_stdout
    end

    it 'does not create a role if prerequisites are not met' do
      allow(@role).to receive(:setup_role?).and_return(false)
      expect(api).to_not receive(:create_role)
      @role.create(api)
    end
  end
end
