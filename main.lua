io.stdout:setvbuf('no')

function love.load()
	--hello!
	love.window.setMode(1280, 720)
	print('test')
	testVar='a'
	print(type(1.0))

	--chr_A = {}
	--chr_A.x, chr_A.y = 0,0

	function renderRect(item)
		if item~= nil then
			love.graphics.rectangle('fill', item.x, item.y, 100, 100)
		end
	end

	function renderCir(item)
		if item~= nil then
			love.graphics.circle('fill', item.x, item.y, item.radius)
		end
	end

	function genObj(item)
		item.x = 0
		item.y = 0
		item.width = 100
		item.height = 100
		item.radius = 50
		return item
	end
end

function love.update(dt)

end

function love.keypressed(key, scancode, isrepeat)
	if key == 'p' then
		chr_A = genObj{}
	end
end

function love.draw()
	love.graphics.print("Hello World!", 400, 300)
	renderRect(chr_A)
end