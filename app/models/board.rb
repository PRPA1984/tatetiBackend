class Board < ApplicationRecord
    validates :first_player, :second_player, presence: :true
    
    before_create :before_create

    def before_create
        self.board = {
            "1" => nil,
            "2" => nil,
            "3" => nil,
            "4" => nil,
            "5" => nil,
            "6" => nil,
            "7" => nil,
            "8" => nil,
            "9" => nil,
        }
    end
    
end
