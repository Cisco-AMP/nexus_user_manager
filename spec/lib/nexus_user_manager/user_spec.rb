require 'nexus_user_manager/user'
require 'nexus_user_manager/role'
require 'nexus_user_manager/privilege'

RSpec.describe 'NexusUserManager::User' do
  let(:name) { 'test-name' }
  let(:password_name) { 'TEST_NAME_PASSWORD' }
  let(:password) { 'password' }
  let(:email) { 'email' }
  let(:r1) { double }
  let(:r2) { double }
  let(:roles) { [r1, r2] }
  let(:api) { double }
  let(:user_checker) { double }

  before(:each) do
    ENV[password_name] = password
    allow(r1).to receive(:name).and_return('r1')
    allow(r2).to receive(:name).and_return('r2')
    @user = NexusUserManager::User.new(name, email, roles, user_checker)
  end

  describe '#password_variable_name' do
    it 'generates the expected variable name' do
      expect(@user.password_variable_name).to eq(password_name)
    end
  end

  describe '#retrieve_password' do
    it 'gets the password from the correct env variable' do
      ENV['TEST_PASSWORD'] = password
      allow(@user).to receive(:password_variable_name).and_return('TEST_PASSWORD')
      expect(@user.retrieve_password).to eq(password)
    end
  end

  describe 'password_valid?' do
    it 'returns true when a password is set' do
      @user.password = password
      expect(@user.password_valid?).to be(true)
    end

    it 'returns false when a password is not set' do
      @user.password = nil
      expect(@user.password_valid?).to be(false)
    end
  end

  describe 'setup_user?' do
    it 'returns true if user does not exist' do
      allow(user_checker).to receive(:exists?).and_return(false)
      expect(@user.setup_user?).to be(true)
    end

    it 'returns false if user exists' do
      allow(user_checker).to receive(:exists?).and_return(true)
      expect(@user.setup_user?).to be(false)
    end
  end

  describe 'create' do
    it 'does not create a user if it has no password' do
      allow(@user).to receive(:password_valid?).and_return(false)
      expect(api).to_not receive(:create_user)
      @user.create(api)
    end

    it 'does not create a user if it already exists' do
      allow(@user).to receive(:password_valid?).and_return(true)
      allow(@user).to receive(:setup_user?).and_return(false)
      expect(api).to_not receive(:create_user)
      @user.create(api)
    end

    it 'prints failure when user is not created successfully' do
      allow(@user).to receive(:password_valid?).and_return(true)
      allow(@user).to receive(:setup_user?).and_return(true)
      expect(api).to receive(:create_user).and_return(false)
      expect { @user.create(api) }.to output(/failed/i).to_stdout
    end

    it 'prints success when user is created' do
      allow(@user).to receive(:password_valid?).and_return(true)
      allow(@user).to receive(:setup_user?).and_return(true)
      expect(api).to receive(:create_user).and_return(true)
      expect { @user.create(api) }.to output(/created/i).to_stdout
    end
  end
end
