require 'nexus_api'
require 'dotenv/load'
require 'pry'
require 'psych'

require 'nexus_user_manager/version'
require 'nexus_user_manager/privilege_checker'
require 'nexus_user_manager/role_checker'
require 'nexus_user_manager/user_checker'
require 'nexus_user_manager/privilege'
require 'nexus_user_manager/role'
require 'nexus_user_manager/user'

module NexusUserManager
  class Manager
    attr_accessor :nexus_api

    NEXUS_USERNAME = ENV['NEXUS_USERNAME']
    NEXUS_PASSWORD = ENV['NEXUS_PASSWORD']
    NEXUS_HOSTNAME = ENV['NEXUS_HOSTNAME']
    CONFIG_NAME = ENV['CONFIG_NAME'].nil? ? 'nexus_users.yaml' : ENV['CONFIG_NAME']

    def initialize
      @nexus_api = NexusAPI::API.new(
        username: NEXUS_USERNAME,
        password: NEXUS_PASSWORD,
        hostname: NEXUS_HOSTNAME
      )
      yaml_file = File.read(File.join(__dir__, CONFIG_NAME))
      @config = Psych.safe_load(yaml_file)
    end

    def user_checker
      return @user_checker unless @user_checker.nil?
      @user_checker = UserChecker.new(@nexus_api)
    end

    def role_checker
      return @role_checker unless @role_checker.nil?
      @role_checker = RoleChecker.new(@nexus_api)
    end

    def privilege_checker
      return @privilege_checker unless @privilege_checker.nil?
      @privilege_checker = PrivilegeChecker.new(@nexus_api)
    end

    def required_roles
      return @required_roles unless @required_roles.nil?
      @required_roles = @config['roles'].map do |name, privileges|
        Role.new(name, privileges, role_checker, privilege_checker)
      end
    end

    def create_required_roles
      if required_roles.empty?
        puts 'No roles to create.'
      else
        puts 'Creating roles...'
        required_roles.each do |role|
          role.create(@nexus_api)
        end
        puts
      end
    end

    def find_objects(username, roles)
      role_objects = []
      roles.each do |role|
        results = required_roles.select { |object| object.name == role }
        if results.count == 0
          puts "WARNING: No Role objects found for '#{role}'. User '#{username}' will be created without it."
        elsif results.count == 1
          role_objects << results.first
        else
          puts "WARNING: Multiple Role objects found for '#{role}':"
          results.each { |object| puts "           * #{object}" }
          puts "         User '#{username}' will be created without it."
        end
      end
      role_objects
    end

    def required_users
      return @required_users unless @required_users.nil?
      @required_users = @config['users'].map do |user|
        roles = find_objects(user['name'], user['roles'])
        User.new(user['name'], user['email'], roles, user_checker)
      end
    end

    def create_required_users
      if required_users.empty?
        puts 'No users to create.'
      else
        puts 'Creating users...'
        required_users.each do |user|
          user.create(@nexus_api)
        end
        puts
      end
    end
  end
end
