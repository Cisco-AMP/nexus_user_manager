module NexusUserManager
  class Role
    attr_accessor :name, :privileges

    def initialize(role, privileges, role_checker, privilege_checker)
      @name = role
      @privileges = privileges.map do |privilege|
        Privilege.new(privilege)
      end
      @role_checker = role_checker
      @privilege_checker = privilege_checker
    end

    def privilege_names
      @privileges.map do |privilege|
        privilege.name
      end
    end

    def setup_role?
      if @role_checker.exists?(@name)
        puts " * Role '#{@name}' already exists. Skipping..."
        return false
      end

      missing_privileges = []
      @privileges.each do |privilege|
        unless @privilege_checker.verify(privilege.name)
          missing_privileges << privilege.name
        end
      end
      unless missing_privileges.empty?
        puts " * Not creating role '#{@name}' due to missing privileges:"
        missing_privileges.each { |privilege| puts "   * #{privilege}" }
        return false
      end
      true
    end

    def create(api)
      if setup_role?
        if api.create_role(
          id: @name,
          name: @name,
          description: @name,
          privileges: privilege_names
        )
          puts " * Created role '#{@name}'."
        else
          puts " * Failed to create role '#{@name}'..."
        end
      end
    end
  end
end
