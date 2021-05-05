module UserService
    def searchUserByToken(token)
        user = User.find_by(token: token).first
        return user == nil ? "User not found" : user
    end

    def login(params)
        username = params[:username]
        password = params[:password]
        user = User.where(username: username, password: password).first
        if user == nil
            return "User not found"
        else
            user.token = SecureRandom.urlsafe_base64(nil, false)
            user.save
            return user.token
        end
    end

    def create(params)
        user = User.new(params)
        if user.save
            return user
        else
            return user.errors.full_messages
        end
    end

    def getMatchHistory(token)
        user = searchUserByToken(token)
        if !user.instance_of? User
            return user
        end
        
        Board.joins(:users).where(users:{id: user.id})
    end

    def logout(string_token)
        if checkTokenFormat(string_token)
            token = string_token.remove("bearer ")
            user = User.find_by(token: token).first
            if user == nil 
                return "User not found"
            else
                user.token = nil
                user.save
                return true
            end
        else
           return "Wrong token format"
        end
    end
end