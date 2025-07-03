io.stdout:setvbuf('no')

function love.load()
	require "config"
	require "genericFunctions"
	--hello!
	love.window.setMode(1280, 720)
	print('test')
	testVar='a'
	print(type(1.0))

	chr_All = {}
	atk_All = {}

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

	function genChr(item)
		item.x = item.x or 0
		item.y = item.y or 0
		item.width = item.width or 100
		item.height = item.height or 100
		item.radius = item.radius or 50
		item.speed = item.speed or 300
		item.id = item.id or 0
		item.hit = item.hit or false
		table.insert(chr_All, item)
	end

	function genAtk(item)
		item.x = item.x or 0
		item.y = item.y or 0
		item.width = item.width or 100
		item.height = item.height or 100
		item.radius = item.radius or 50
		item.speed = item.speed or 300
		item.id = item.id or 0
		item.renderType = item.renderType or 'circle'
		table.insert(atk_All, item)
	end
end

function love.update(dt)
	pressing = {} -- Initialize key presses only once
	pressing.up = love.keyboard.isDown(config.up)
	pressing.down = love.keyboard.isDown(config.down)
	pressing.left = love.keyboard.isDown(config.left)
	pressing.right = love.keyboard.isDown(config.right)

	angleMod = 1
	if (not pressing.down or not pressing.up) and (not pressing.left or not pressing.right) then
		angleMod = math.sqrt(2)/2 --reduce speed at diagonal
	end

	for i, chr in pairs(chr_All) do --Move main character
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

	for i, atk in pairs(atk_All) do
		-- To do: Check for time increment before despawn

		-- Check if hitbox overlap
		for j, chr in pairs(chr_All) do
			if atk.radius + chr.radius > distTo(atk, chr) then
				print('hit')
				chr.hit = true
			else
				--print('not hit')
				chr.hit = false
			end
		end
	end
end

function love.keypressed(key, scancode, isrepeat)
	if key == 'o' then
		genChr{}
	elseif key == 'p' then
		genChr{id=1}
	elseif key == 'u' then
		genAtk{x=600,y=350}
	end
end

function love.draw()
	--love.graphics.print("Hello World!", 400, 300)
	for i, chr in pairs(chr_All) do
		if chr.id == 1 then
			if chr.hit == true then
				love.graphics.setColor(0.5, 0.1, 0.2)
			elseif chr.hit == false then
				love.graphics.setColor(1, 0.2, 0.3)
			end
		end
		renderCir(chr)	
		love.graphics.setColor(1, 1, 1)		
	end

	for i, atk in pairs(atk_All) do
		if atk.renderType == 'circle' then
			love.graphics.circle('fill', atk.x, atk.y, atk.radius)
		end
	end

end