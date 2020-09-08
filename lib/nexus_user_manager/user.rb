module NexusUserManager
  class User
    attr_accessor :name, :password

    def initialize(name, email, roles, user_checker)
      @name = name
      @password = retrieve_password
      @email = email
      @roles = roles
      @user_checker = user_checker
    end

    def password_variable_name
      name = @name.gsub('-','_').upcase
      "#{name}_PASSWORD"
    end

    def retrieve_password
      ENV[password_variable_name]
    end

    def password_valid?
      if @password.nil?
        puts "ERROR: No password has been configured for user '#{name}'."
        puts '       Please configure the following environment variable:'
        puts "         #{password_variable_name}"
        return false
      end
      true
    end

    def setup_user?
      if @user_checker.exists?(@name)
        puts " * User '#{@name}' already exists. Skipping..."
        return false
      end
      true
    end

    def create(api)
      if password_valid?
        if setup_user?
          if api.create_user(
            user_id: @name,
            first_name: @name,
            last_name: @name,
            password: @password,
            email: @email,
            roles: @roles.map { |role| role.name }
          )
            puts " * Created user '#{@name}'."
          else
            puts " * Failed to create user '#{@name}'..."
          end
        end
      end
    end
  end
end
