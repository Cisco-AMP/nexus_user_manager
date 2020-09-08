module NexusUserManager
  class RoleChecker
    def initialize(api)
      @api = api
    end

    def roles
      @api.list_roles.map { |role| role['id'] }
    end

    def exists?(id)
      roles.include?(id)
    end
  end
end
