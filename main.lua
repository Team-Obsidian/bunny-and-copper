io.stdout:setvbuf('no')

function love.load()
	require "config"
	require "genericFunctions"
	require "genAttacks"
	require "misc"

	--hello!
	love.window.setMode(scrWidth, scrHeight)
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
		item.radius = item.radius or 30
		item.speed = item.speed or 300
		item.move = false
		item.angle = item.angle or 0
		item.control = true
		item.id = item.id or 0
		item.hit = item.hit or false
		item.hitTimer = item.hitTimer or 0
		item.hitTimerMax = item.hitTimerMax or 3
		table.insert(chr_All, item)
	end

	function genAtk(item)
		item.x = item.x or 0
		item.y = item.y or 0
		item.velX = item.velX or 0
		item.velY = item.velY or 0
		item.width = item.width or 100
		item.height = item.height or 100
		item.radius = item.radius or 50
		item.speed = item.speed or 300
		item.angle = item.angle or 0
		item.id = item.id or 0
		item.renderType = item.renderType or 'circle'
		-- despawns after some condition or specified time
		item.timeOut = item.timeOut or nil
		item.clear = item.clear or false
		table.insert(atk_All, item)
	end
end


function love.update(dt)
	pressing = {} -- Initialize key presses only once
	pressing.up = love.keyboard.isDown(config.up)
	pressing.down = love.keyboard.isDown(config.down)
	pressing.left = love.keyboard.isDown(config.left)
	pressing.right = love.keyboard.isDown(config.right)

	for i, chr in pairs(chr_All) do --Move main character
		if chr.id == 1 and chr.control then
			tempX,tempY = 0, 0
			--hardcoded to pressing var, fix to generalize later
			if pressing.up then tempY = tempY - 1 end
			if pressing.down then tempY = tempY + 1 end
			if pressing.left then tempX = tempX - 1 end
			if pressing.right then tempX = tempX + 1 end
			-- set angle of movement, in radians
			chr.angle = math.atan2(tempY,tempX)
			-- set movement flag based on controls
			if tempX == 0 and tempY == 0 then chr.move = false else chr.move = true end
			
			-- To do: set wall detection, create future path for knockback
			-- chr.move must be true for character to move, even when chr.control==false
			if chr.move then
				chr.x = chr.x + chr.speed*math.cos(chr.angle)*dt
				chr.y = chr.y + chr.speed*math.sin(chr.angle)*dt
			end
		end
	end

	for i, atk in pairs(atk_All) do
		-- Check if hitbox overlap, (note: comes before time & clear command)
		for j, chr in pairs(chr_All) do

			if atk.radius + chr.radius > distTo(atk, chr) and chr.hit == false then
				--print('hit')
				chr.hit = true
				chr.hitTimer = chr.hitTimerMax
			else
				--print('not hit')
				--chr.hit = false
			end
		end

		atk.x = atk.x + atk.speed*math.cos(atk.angle)*dt
		atk.y = atk.y + atk.speed*math.sin(atk.angle)*dt


		if atk.timeOut ~= nil then
			if atk.timeOut < 0 then 
				atk.clear = true
			else
				atk.timeOut = atk.timeOut - dt
			end 
		end
		--To do: provide edge case for non-bullet like attacks
		--clear bullets that move past the screen margin
		if atk.x < (-atkMargin) or atk.x > scrWidth + atkMargin then atk.clear = true end
		if atk.y < (-atkMargin) or atk.y > scrHeight+ atkMargin then atk.clear = true end

		if atk.clear == true then
			atk_All[i] = nil
		end
	end

	for i, chr in pairs(chr_All) do
		if chr.hitTimer < 0 then
			chr.hit = false
			chr.hitTimer = 0
		elseif chr.hit == true then
			chr.hitTimer = chr.hitTimer - dt
		end
	end


end

function love.keypressed(key, scancode, isrepeat)
	if key == 'o' then
		genAtk{x=love.math.random(0, 1200),y=love.math.random(0,720),timeOut=3}
	elseif key == 'p' then
		genChr{id=1}
	elseif key == 'u' then
		genAtk{x=600,y=350}
	elseif key == 'backspace' then
		chr_All = {}
		atk_All = {}
	elseif key=='y' then
		atkBullet{num=6,spread=360/6,angle=0}
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
		else
			love.graphics.setColor(0.1, 0.7, 0.2)	
		end
		renderCir(chr)	
		love.graphics.setColor(1, 1, 1)		
		love.graphics.print('chr_id: ' .. chr.id, chr.x, chr.y)
	end

	atkCount = 0
	for i, atk in pairs(atk_All) do
		atkCount = atkCount + 1
		if atk.renderType == 'circle' then
			love.graphics.setColor(0, 0.4, 0.7)
			love.graphics.circle('fill', atk.x, atk.y, atk.radius)

		end

		love.graphics.setColor(1, 1, 1)		
		love.graphics.print('atk_id: ' .. atk.id, atk.x, atk.y)
	end
	--print('atkCount: '.. atkCount)


	for i, chr in pairs(chr_All) do
		if chr.id == 1 then
			temp = 0
			for j, value in pairs(chr) do
				love.graphics.print(tostring(j) .. ': ' .. tostring(value), 1200, 20+20*temp)
				temp = temp + 1
			end
		end 
	end
end