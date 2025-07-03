io.stdout:setvbuf('no')

function love.load()
	--hello!
	love.window.setMode(640, 480)
	print('test')
	testVar='a'
	print(type(1.0))
end

function love.draw()
	love.graphics.print("Hello World!", 400, 300)
end