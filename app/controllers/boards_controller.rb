class BoardsController < ApplicationController

    before_action :validateCurrentUserNotBlank, only: [:newGame, :lastBoard, :userState, :newTurn, :matchHistory]

    before_action :validateCurrentBoardNotBlank, only: [:newTurn, :show]


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
            return render(json: boardFormat(board), status: 200)
        end
    end

    def lastBoard
        board = Board.joins(:users).where(users: {id: current_user.id}).order(:created_at).last
        if board.blank?
            return render(json: formatError("Board not found"), status: 400)
        end
        return render(json: boardFormat(board), status: 200) 
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
        if current_board.winner != nil
            return render(json: formatError('There is already a winner'), status:400)
        elsif current_board.checkUserColor(current_user) != current_board.turn
            return render(json: formatError("This is not your turn"), status:400)
        elsif current_board.board[row].present?
            return render(json: formatError("This row is not available"), status:400)
        end
        current_board.newMovement(current_user, row)
        current_board.checkGame(current_user)
        current_board.save
        return render(json: boardFormat(current_board), status: 200)  

    end

    def show
        return render(json: boardFormat(current_board), status: 200) 
    end

    def matchHistory
        boards = Board.joins(:users).where(users: {id: current_user.id})
        if boards.present?
            boards = boards.map { |board|
                {
                    "id":board.id,
                    "greenPlayer": board.users[0].name,
                    "redPlayer": board.users[1].name,
                    "winner": board.winner
                }
            }
            return render(json: boards, status: 200)
        else
            return render(json: formatError("Boards not found"), status: 400)
        end
    end
    

    def board_params
        params.require(:board).permit(:id, :selected_row)
    end
    
end
