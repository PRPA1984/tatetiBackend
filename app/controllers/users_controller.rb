class UsersController < ApplicationController

    before_action :validateCurrentUserNotBlank, only: [:logout, :current]

    def login
        username = user_params[:username]
        password = user_params[:password]
        user = User.find_by(username: username, password: password)
        if user.present?
            token = user.generateToken
            user.save
            return render(json: {"token": token}, status: 200)
        else
            return render(json: formatError("User not found"), status: 400)
        end
    end

    def logout
        current_user.update(token: nil)
        return render(status:200)
    end

    def create
        user = User.new(user_params)
        if user.save
            return render(json: {"token": user.token}, status:200)
        else
            errors = user.errors.full_messages.join(", ")
            return render(json: formatError(errors), status:400)
        end
    end

    def current
        render(json: userFormat(current_user), status: 200)
    end


    def user_params
        params.require(:user).permit(:token, :username, :name, :password)
    end

end
