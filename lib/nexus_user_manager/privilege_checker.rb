module NexusUserManager
  class PrivilegeChecker
    def initialize(api)
      @api = api
    end

    def privileges
      @api.list_privileges.map { |privilege| privilege['name'] }
    end

    def verify(name)
      privileges.include?(name)
    end
  end
end
