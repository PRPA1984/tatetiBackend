class Board < ApplicationRecord

    serialize :board    

    has_and_belongs_to_many :users, join_table: "boards_users" #First user = Green, Second user = Red

    before_create :before_create

    def before_create
        self.board = {}
        self.turn = "green"
    end
    

    def checkUserColor(player)
        if self.users.index(player) == 0
            return "green"
        elsif self.users.index(player) == 1
            return "red"
        end
    end

    def getPlayerNameBycolor(color)
        if color == "green"
            return self.users[0].name
        elsif color == "red"
            return self.users[1].name
        end
    end

    def newMovement(player, row)
        self.board[row] = player.name
        if self.checkUserColor(player) == "green"
            self.turn = "red"
        else
            self.turn = "green"
        end
    end

    def setWinner(player)
        self.winner = player.name
    end

    def checkGame(player)

        array = []
        self.board.each do |key,value|
            if value == player.name
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
