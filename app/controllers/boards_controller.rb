class BoardsController < ApplicationController

    def newGame
        
        board = Board.new(new_board_params)
        if board.save
            render(json: board, status: 200)
        else
            render(json: board.errors.full_messages, status: 400)
        end
    end

    def newTurn
        #Formato: {
        #   El id va en el path(tabla)
        #   "player": "player",
        #   "selected_row"   
        #
        begin
            board = Board.find(new_turn_params[:id])
        rescue => exception
            board = nil
        end
        
        row = new_turn_params[:selected_row].to_i
        player = new_turn_params[:player]
        
        if board == nil
            status = 400
            message = "Board not found"
        elsif board.newTurn(row, player)
            board.checkGame(player)
            message = board
            status = 200
        else
            message = board
            status = 400
        end

        render(json: message, status: status)
    end
    

    def new_board_params
        params.require(:board).permit(:first_player, :second_player)
    end

    def new_turn_params
        params.permit(:player, :selected_row, :id)
    end
    
end
