class BoardsController < ApplicationController
    def current_user
        token = request.headers["Authorization"]
        @current_user ||= User.find_by(token: token)
    end

    def current_board
        @current_board ||= Board.preload(:users).find(params[:id])
    end

    def newGame
        if current_user.matchmaking
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
        board = Board.joins(:users).where(users: {id: current_user.id}).order(:created_at).last
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
        if current_user.matchmaking
            return render(json: {"state": 'In queue'}, status: 200)
        else
            return render(json: {"state": 'Not in queue'}, status: 200)

        end
    end

    def newTurn

        row = params[:selected_row].to_i        
        if current_board == nil
            return render(json: {'errors': 'Board not found'}, status: 400)
        elsif current_board.winner != nil
            return render(json: {'errors': 'There is already a winner: ' + current_board.getPlayerNameBycolor(current_board.winner), status:400})
        elsif current_board.checkUserColor(current_user) != current_board.turn
            return render(json: {'errors': "This is not your turn", status:400})
        elsif
            current_board.board[row].present?
            return render(json: {'errors': "This row is not available", status:400})
        end
        current_board.newMovement(current_user, row)
        current_board.checkGame(current_user)
        current_board.save
        return render(json: {
            "id": board.id,
            "board": board.board,
            "turn": board.turn,
            "winner": board.winner,
            "greenPlayer": board.users[0].name,
            "redPlayer": board.users[1].name
    }, status: 200)    end

    def show
        if current_board.present?
            return render(json: {
                "id": board.id,
                "board": board.board,
                "turn": board.turn,
                "winner": board.winner,
                "greenPlayer": board.users[0].name,
                "redPlayer": board.users[1].name
        }, status: 200)
        else
            return render(json: {"errors": "Board not found"}, status: 400)
        end
    end
    

    def board_params
        params.require(:board).permit(:id, :selected_row)
    end
    
end
