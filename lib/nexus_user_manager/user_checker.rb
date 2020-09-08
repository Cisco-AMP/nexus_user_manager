module NexusUserManager
  class UserChecker
    def initialize(api)
      @api = api
    end

    def users
      @api.list_users.map { |user| user['userId'] }
    end

    def exists?(name)
      users.include?(name)
    end
  end
end
