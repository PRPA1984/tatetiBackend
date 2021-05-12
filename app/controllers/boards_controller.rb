class BoardsController < ApplicationController
    def current_user
        token = request.headers["Authorization"]
        @current_user ||= User.find_by(token: token)
    end

    def current_board
        @current_board ||= Board.preload(:users).find(params[:id])
    end

    def formatError(error)
        return {"error": error}
    end

    def newGame
        if current_user.blank?
            return render(json: formatError("User not found"), status: 400)
        elsif current_user.matchmaking
            return render(json: {"state": 'In queue'}, status: 200)
        end
        enemy_player = User.where(matchmaking: true).first
        if enemy_player == nil
            current_user.matchmaking = true
            current_user.save
            return render(json: {"state": 'In queue'}, status: 200)
        else
            enemy_player.matchmaking = false
            enemy_player.save
            board = Board.new
            board.users = [enemy_player, current_user]
            board.save
            return render(json: {
                    "id": board.id,
                    "board": board.board,
                    "turn": board.turn,
                    "winner": board.winner,
                    "greenPlayer": board.users[0].name,
                    "redPlayer": board.users[1].name
            }, status: 200)
        end
    end

    def lastBoard
        if current_user.blank?
            return render(json: formatError("User not found"), status: 400)
        end
        board = Board.joins(:users).where(users: {id: current_user.id}).order(:created_at).last
        if board.blank?
            return render(json: formatError("Board not found"), status: 400)
        end
        return render(json: {
            "id": board.id,
            "board": board.board,
            "turn": board.turn,
            "winner": board.winner,
            "greenPlayer": board.users[0].name,
            "redPlayer": board.users[1].name
            }, status: 200)  
    end

    def userState
        if current_user.blank?
            return render(json: formatError("User not found"), status: 400)
        elsif current_user.matchmaking
            return render(json: {"state": 'In queue'}, status: 200)
        else
            return render(json: {"state": 'Not in queue'}, status: 200)
        end
    end

    def newTurn

        row = params[:selected_row].to_i        
        if current_board == nil
            return render(json: formatError("Board not found"), status: 400)
        elsif current_user.blank?
            return render(json: formatError("User not found"), status: 400)
        elsif current_board.winner != nil
            return render(json: formatError('There is already a winner'), status:400)
        elsif current_board.checkUserColor(current_user) != current_board.turn
            return render(json: formatError("This is not your turn"), status:400)
        elsif current_board.board[row].present?
            return render(json: formatError("This row is not available"), status:400)
        end
        current_board.newMovement(current_user, row)
        current_board.checkGame(current_user)
        current_board.save
        return render(json: {
            "id": current_board.id,
            "board": current_board.board,
            "turn": current_board.turn,
            "winner": current_board.winner,
            "greenPlayer": current_board.users[0].name,
            "redPlayer": current_board.users[1].name
    }, status: 200)    end

    def show
        if current_board.present?
            return render(json: {
                "id": current_board.id,
                "board": current_board.board,
                "turn": current_board.turn,
                "winner": current_board.winner,
                "greenPlayer": current_board.users[0].name,
                "redPlayer": current_board.users[1].name
        }, status: 200)
        else
            return render(json: formatError("Board not found"), status: 400)
        end
    end

    def matchHistory
        if current_user.present?
            boards = Board.joins(:users).where(users: {id: current_user.id})
            if boards.present?
                boards = boards.map { |board|
                    {
                        "id":board.id,
                        "board": board.board,
                        "greenPlayer": board.users[0].name,
                        "redPlayer": board.users[1].name,
                        "winner": board.winner
                    }
                }
                return render(json: boards, status: 200)
            else
                return render(json: formatError("Boards not found"), status: 400)
            end
        else
            return render(json: formatError("User not found"), status: 400)
        end
    end
    

    def board_params
        params.require(:board).permit(:id, :selected_row)
    end
    
end
