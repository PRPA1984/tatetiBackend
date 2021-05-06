class UsersController < ApplicationController

    def current_user
        begin
            token = request.headers["Authorization"].remove("bearer ")
            @current_user ||= User.find_by(token: token)
            raise "User not found" if @current_user.blank?
            return @current_user
        rescue => exception
            render(json: {"errors": exception.message}, status:500)
        end

    end

    def login
        username = user_params[:username]
        password = user_params[:password]
        user = User.find_by(username: username, password: password)
        if user.blank?
            return render(json: {"errors": "User not found"}, status: 400)
        else
            token = user.generateToken
            user.save
            return render(json: {"token": token}, status: 200)
        end
    end

    def logout
        begin
            current_user.update!(token: nil)
            return render(status:200)
        rescue => exception
            return render(json: current_user.errors.full_messages, status:400)
        end
    end

    def create
        user = User.new(user_params)
        if user.save
            return render(json: user.token, status:200)
        else
            return render(json: {"errors": user.errors.full_messages}, status:400)

        end
    end

    def current
        byebug
        render(json: current_user, status: 200)
    end


    def user_params
        params.require(:user).permit(:token, :username, :name, :password)
    end

end
