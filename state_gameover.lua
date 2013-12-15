-- Rocks-n-Blaster -- #LD48 -- by <weldale@gmail.com>


GameOverState = GameState:subclass("GameOverState")


function GameOverState:draw()

	love.graphics.setFont(headlineFont)

	love.graphics.print("Game Over", 48, 80)

	love.graphics.setFont(mainFont)

	love.graphics.print( "Hmm.. Seems I have run out of levels for you..", 48, 112)
	love.graphics.print( "This can only mean: You have won the game!", 48, 128)
	love.graphics.print( "Congratulations and thank you for playing :)", 48, 144)
	love.graphics.print( "Press any key to return to the Main Menu", 48, 160)

end


function GameOverState:keypressed(key)
	gameStateManager:changeState(MainMenuState)
end


