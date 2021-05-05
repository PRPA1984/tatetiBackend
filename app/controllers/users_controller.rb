#require 'UserService.rb'
include UserService

class UsersController < ApplicationController

    def login
        result = UserService.login(user_params)
        if result == "User not found"
            return render(json: {"errors": result}, status: 400)
        else
            return render(json: {"token": result}, status: 200)
        end
    end

    def logout
        result = UserService.logout(user_params)
        if result == true
            return render(status:200)
        else
            return render(json: result, status:400)
        end
    end

    def create
        result = UserService.create(user_params)
        if result.instance_of? User
            return render(json: result, status:200)
        else
            return render(json: {"errors": result}, status:400)
        end
    end

    def current
        result = UserService.searchUserByToken(token)
        if result.instance_of? User
            return render(json: result, status: 200)
        else
            return render(json: {"errors": result}, status: 400)
        end
    end


    def user_params
        params.require(:user).permit(:token, :username, :name, :password)
    end

end
