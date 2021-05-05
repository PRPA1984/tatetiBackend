include UserService

module BoardService
    def newGame(token)
        user = UserService.searchUserByToken(token)
        if !user.instance_of? User
            return user
        end
        enemy_player = User.where(matchmaking: true).first
        if enemy_player == nil
            user.matchmaking = true
            user.save
            return "In queue"
        else
            enemy_player.matchmaking = false
            enemy_player.save
            board = Board.new
            board.users = [enemy_player, user]
            board.save
            return board
        end
    end

    def newTurn(token, board_id, selected_row)
        token = params[:token]
        board_id = params[:board_id]
        row = params[:selected_row].to_i
        begin
            board = Board.find(board_id)
        rescue => exception
            board = nil
        end
        
        player = UserService.searchUserByToken(token)
        
        if board == nil
            return "Board not found"
        elsif !player.instance_of? User
            return player
        elsif board.winner != nil
            return "There is already a winner: " + board.winner
        elsif board.checkUserColor(player) != board.turn
            return "This is not your turn"
        end
        board[row] = player
        board.checkGame(player)
        board.save
        return board
    end

    def current_board(params)
        token = params[:token]
        board_id = params[:board_id]
        user = UserService.searchUserByToken(token)
        if !user.instance_of? User
            return user
        end
        
        board = Board.find(board_id)
        if board == nil
            return "Board not found"
        elsif !board.users.include? user
            return "You do not have access to this board"
        else
            return board
        end
    end
end