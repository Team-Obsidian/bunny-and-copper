io.stdout:setvbuf('no')

function love.load()
	require "config"

	--hello!
	love.window.setMode(1280, 720)
	print('test')
	testVar='a'
	print(type(1.0))

	chr_All = {}

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
		item.x = item.x or 0
		item.y = item.y or 0
		item.width = item.width or 100
		item.height = item.height or 100
		item.radius = item.radius or 50
		item.speed = item.speed or 300
		item.id = item.id or 0
		table.insert(chr_All, item)
	end
end

function love.update(dt)
	pressing = {}
	pressing.up = love.keyboard.isDown(config.up)
	pressing.down = love.keyboard.isDown(config.down)
	pressing.left = love.keyboard.isDown(config.left)
	pressing.right = love.keyboard.isDown(config.right)
	angleMod = 1
	if (not pressing.down or not pressing.up) and (not pressing.left or not pressing.right) then
		angleMod = math.sqrt(2)/2
	end

	for i, chr in pairs(chr_All) do
		if chr.id == 1 then
			if pressing.up then
				chr.y = chr.y - chr.speed*dt*angleMod
			end
			if pressing.down then
				chr.y = chr.y + chr.speed*dt*angleMod
			end
			if pressing.left then
				chr.x = chr.x - chr.speed*dt*angleMod
			end
			if pressing.right then
				chr.x = chr.x + chr.speed*dt*angleMod
			end
		end
	end
end

function love.keypressed(key, scancode, isrepeat)
	if key == 'o' then
		genObj{}
	elseif key == 'p' then
		genObj{id=1}
	end
end

function love.draw()
	love.graphics.print("Hello World!", 400, 300)
	for i, chr in pairs(chr_All) do
		if chr.id == 1 then
			love.graphics.setColor(1, 0.2, 0.3)
		end
		renderRect(chr)	

		love.graphics.setColor(1, 1, 1)		
	end

end