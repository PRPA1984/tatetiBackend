class UsersController < ApplicationController

    def current_user
        token = request.headers["Authorization"]
        @current_user ||= User.find_by(token: token)
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
            if current_user.present?
                current_user.update!(token: nil)
                return render(status:200)
            else
                render(json: {"errors": "User not found"}, status:400)
            end
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
        if current_user.present?
            render(json: {
                "id": current_user.id,
                "name": current_user.name,
                "matchmaking": current_user.matchmaking
            }, status: 200)
        else
            render(json: {'errors': 'User not found'}, status: 400)
        end
    end

    def matchHistory
        if current_user.present?
            boards = Board.joins(:users).where(users: {id: current_user.id})
            if boards.present?
                boards.map { |board|
                    {
                        "board": board,
                        "green_player": board.users[0].name,
                        "red_player": board.users[1].name
                    }
                }
                byebug
                return render(json: boards, status: 200)
            else
                return render(json: {'errors': 'Boards not found'}, status: 400)
            end
        else
            return render(json: {'errors': 'User not found'}, status: 400)
        end
    end


    def user_params
        params.require(:user).permit(:token, :username, :name, :password)
    end

end
