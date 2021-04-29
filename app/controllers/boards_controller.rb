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
        #}
        board = Board.find(new_turn_params[:id])
        row = new_turn_params[:selected_row]
        byebug
        if(board.board[row] == nil)
            board.board[row] = new_turn_params[:player]
            board.save
            render(json: board, status: 200)
        else 
            render(json: board, status: 400)
        end 
    end
    

    def new_board_params
        params.require(:board).permit(:first_player, :second_player)
    end

    def new_turn_params
        params.permit(:player, :selected_row, :id)
    end
    
end
