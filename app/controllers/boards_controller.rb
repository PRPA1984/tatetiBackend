include BoardService

class BoardsController < ApplicationController

    def newGame
        result = BoardService.newGame(token)
        if result.instance_of? Board
            return render(json: result, status: 200)
        elsif result == "In queue"
            return render(json: {"state": result}, status: 200)
        else
            return render(json: {"errors": result, status: 400})
        end
    end

    def newTurn
        byebug
        result = BoardService.newTurn(token, board_id, selected_row)
        if result.instance_of? Board
            return render(json: result, status: 200)
        else
            return render(json: {"errors": result, status:400})
        end
    end

    def show
        result = BoardService.current_board(token, board_id)
        if result.instance_of? Board
            return render(json: result, status: 200)
        else
            return render(json: {"errors": result}, status: 400)
        end
    end
    

    def board_params
        params.require(:board).permit(:id, :selected_row)
    end
    
end
