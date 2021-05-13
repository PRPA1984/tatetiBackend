class ApplicationController < ActionController::API
    
    def current_user
        token = request.headers["Authorization"]
        @current_user ||= User.find_by(token: token)
    end

    def current_board
        @current_board ||= Board.preload(:users).find(params[:id])
    end

    def validateCurrentUserNotBlank
        return if current_user.present?

        return render(json: formatError("User not found"), status: 400)
    end

    def validateCurrentBoardNotBlank
        return if current_board.present?

        return render(json: formatError("Board not found"), status: 400)
    end

    def formatError(error)
        return {"error": error}
    end

    def boardFormat(board)
        return {
            "id": board.id,
            "board": board.board,
            "turn": board.turn,
            "winner": board.winner,
            "greenPlayer": board.users[0].name,
            "redPlayer": board.users[1].name
        }
    end

    def userFormat(user)
        return {
            "id": user.id,
            "name": user.name,
            "matchmaking": user.matchmaking
        }
    end
end
