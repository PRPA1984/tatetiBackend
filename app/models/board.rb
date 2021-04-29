class Board < ApplicationRecord

    serialize :board    


    validates :first_player, :second_player, presence: :true
    
    before_create :before_create

    def before_create
        self.board = {}
    end
    
    def newTurn(row, player)
        if(self.board[row] == nil && (player == self.first_player or player == self.second_player) && self.winner == nil)
            self.board[row] = player
            self.save
            return true
        else
            return false
        end
    end

    def setWinner(player)
        self.winner = player
        self.save
    end

    def checkGame(player)

        array = []
        self.board.each do |key,value|
            if value == player
                array.push(key)
            end
            
        end
        
        if (array.include?(1))
            if (array.include?(2) && array.include?(3)) 
                self.setWinner(player)
            elsif (array.include?(4) && array.include?(7))
                self.setWinner(player)
            elsif (array.include?(5) && array.include?(9))
                self.setWinner(player)
            end
        elsif (array.include?(2))
            if (array.include?(5) && array.include?(8)) 
                self.setWinner(player)
            end
        elsif (array.include?(3))
            if (array.include?(5) && array.include?(7))
                self.setWinner(player)
            elsif(array.include?(6) && array.include?(9))
                self.setWinner(player)
            end
        elsif (array.include?(4))
            if (array.include?(5) && array.include?(6)) 
                self.setWinner(player)
            end
        elsif(array.include?(7))
            if (array.include?(8) && array.include?(9))
                self.setWinner(player)
            end
        end
    end
end
