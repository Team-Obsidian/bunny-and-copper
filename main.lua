io.stdout:setvbuf('no')

function love.load()
	require "config"
	require "genericFunctions"
	require "genAttacks"
	require "misc"
	require "initSpr"
	--hello!
	love.window.setMode(scrWidth, scrHeight)
	print('test')
	testVar='a'
	print(type(1.0))

	--tracks player attributes
	chr_All = {}
	--tracks hitboxes and movement
	atk_All = {}
	--tracks enemy health and attributes
	ene_All = {}
	--telegraphed info?
	gfx_All = {} 
	--counts down events
	eve_All = {} 

	function renderRect(item)
		if item~= nil then
			love.graphics.rectangle('fill', item.x, item.y, 100, 100)
		end
	end

	function renderCir(item, fill)
		if item~= nil then
			love.graphics.circle(fill, item.x, item.y, item.radius)
		end
	end

	function genChr(item)
		item.x = item.x or 0
		item.y = item.y or 0
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
		item.width = item.width or 100
		item.height = item.height or 100
		item.radius = item.radius or 50
		item.speed = item.speed or 300
		item.angle = item.angle or 0
		item.id = item.id or 0
		item.renderType = item.renderType or 'circle'
		-- despawns after some condition or specified time
		item.startTime = item.startTime or elapsedTime
		item.endTime = item.endTime or nil
		item.clear = item.clear or false
		table.insert(atk_All, item)
	end

	function genEne(item)
		item.x = item.x or 0
		item.y = item.y or 0
		--item.width = item.width or 100
		--item.height = item.height or 100
		item.radius = item.radius or 150
		item.speed = item.speed or 100
		item.angle = item.angle or 0
		item.id = item.id or 0
		item.renderType = item.renderType or 'circle'
		-- despawns after some condition or specified time
		item.clear = item.clear or false
		table.insert(ene_All, item)
	end

	function cleanCategory(tag) --make one for tags?
		for i, event in pairs(eve_All) do
			if event.category == tag then
				eve_All[i] = nil --ALT: set event.clear to true, may cause future problem 
			end
		end
	end


	--[[
	Conditions:
	- Number of Bullets
	- Spread
	- Duration and End
	--]]
	function genAtk1Tele(item)
		item.startTime = item.startTime or elapsedTime
		item.endTime = item.endTime or elapsedTime + 3
		item.x = item.x or scrCenterX
		item.y = item.y or scrCenterY
		item.width = item.width or 20 --arbitrary
		item.angle = item.angle or 0
		item.render = item.render or 'beam'
		item.clear = item.clear or false
		table.insert(gfx_All, item)
	end

	function genAtk1Tot(param)
		print('genAtk1Tot is executed')
		param.x = param.x or scrCenterX
		param.y = param.y or scrCenterY
		param.num = param.num or 6
		param.atkStart = param.atkStart or 3
		param.atkDur = param.atkDur or atkTimeOut
		param.radius = param.radius or 10
		param.spread = 360/param.num
		param.angle = param.angle or 0
		atkBullet{
			x = param.x,
			y = param.y,
			num=param.num,
			spread=param.spread,
			radius = param.radius,
			angle=param.angle,
			startTime = elapsedTime + param.atkStart,
			endTime = elapsedTime + param.atkStart + param.atkDur
		}
		param.teleStart = param.teleStart or 0
		param.teleDur = param.teleDur or param.atkStart
		--telegraph begins as soon as function is run
		for i=0, param.num-1 do
			genAtk1Tele{
				x = param.x,
				y = param.y,
				startTime = elapsedTime + param.teleStart,
				endTime = elapsedTime + param.teleStart + param.teleDur,
				width = param.radius*2,
				angle = math.rad(param.angle + param.spread*i) or param.angle or 0
			}
		end
	end
end


function love.update(dt)
	elapsedTime = love.timer.getTime()

	for i, event in pairs(eve_All) do
		if event.startTime > elapsedTime then
			--call a specific function based on event.name == 'XYZ'
			--then clear immediately... or use for misc functions.
		end
		if event.endTime < elapsedTime then
			--clear event, since it's over.
		end
	end

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
		--if you get an error around here, you're probably missing a atk.startTime
		if atk.startTime < elapsedTime then -- pass time behavior
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
		end


		if atk.endTime ~= nil then
			if atk.endTime < elapsedTime then 
				atk.clear = true
			end 
		end
		--To do: provide edge case for non-bullet like attacks

		--clear bullets that move past the screen margin
		if atk.x < (-atkMargin) or atk.x > scrWidth + atkMargin then atk.clear = true end
		if atk.y < (-atkMargin) or atk.y > scrHeight+ atkMargin then atk.clear = true end

		if atk.clear == true then
			print('atk cleared')
			atk_All[i] = nil
		end
	end

	for i, graphic in pairs(gfx_All) do
		--beginning "behavior" is rendering, check love.draw() for behavior 
		if graphic.endTime < elapsedTime then graphic.clear = true end

		if graphic.clear == true then
			--print('graphic cleared')
			gfx_All[i] = nil
		end
	end

	--revise whole section with global time
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
		genAtk{x=love.math.random(0, 1200),y=love.math.random(0,720),duration=3}
	elseif key == 'p' then
		genChr{id=1}
	elseif key == 'u' then
		genAtk{x=600,y=350}
	elseif key == 'backspace' then
		chr_All = {}
		atk_All = {}
	elseif key=='y' then
		atkBullet{num=6,spread=360/6,angle=0}
	elseif key == 't' then
		genEne{id=1,x=scrCenterX,y=scrCenterY}
	elseif key == 'h' then
		genAtk1Tot{
			x=love.math.random(0, scrWidth),
			y=love.math.random(0,scrHeight),
			num = love.math.random(3,12)
		}
	end
end

function love.draw()
	for i, graphic in pairs(gfx_All) do
		if graphic.startTime < elapsedTime then
			if graphic.render == 'beam' then
				--hardcoded max distance, limit later
				newPos = posFromDist(graphic, scrWidth)
				love.graphics.setLineWidth(graphic.width)
				love.graphics.setColor(0.2, 0.3, 0.9, 0.5)
				love.graphics.line(graphic.x, graphic.y, newPos.x, newPos.y)
			end
		end
		love.graphics.setColor(1,1,1,1)
	end

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
		renderCir(chr,'fill')	
		love.graphics.setColor(1, 1, 1)		
		love.graphics.print('chr_id: ' .. chr.id, chr.x, chr.y)
	end

	atkCount = 0
	for i, atk in pairs(atk_All) do
		atkCount = atkCount + 1
		if atk.startTime < elapsedTime then
			if atk.renderType == 'circle' then
				love.graphics.setColor(0, 0.4, 0.7)
				love.graphics.circle('fill', atk.x, atk.y, atk.radius)

			end

			love.graphics.setColor(1, 1, 1)		
			love.graphics.print('atk_id: ' .. atk.id, atk.x, atk.y)
		end
	end
	love.graphics.print('atkCount: '.. atkCount, 100, 100)

	--debug values for player character
	for i, chr in pairs(chr_All) do
		if chr.id == 1 then
			temp = 0
			for j, value in pairs(chr) do
				love.graphics.print(tostring(j) .. ': ' .. tostring(value), 1200, 20+20*temp)
				temp = temp + 1
			end
		end 
	end

	for i, ene in pairs(ene_All) do
		if ene.id == 1 then
			love.graphics.setColor(0.3, 0.2, 0.9, 0.3)
			renderCir(ene, 'fill')
			love.graphics.setColor(0.3, 0.2, 0.9, 0.8)
			renderCir(ene, 'line')
			love.graphics.setColor(1, 1, 1, 1)
			love.graphics.draw(ene_spr1, ene.x, ene.y, 0, 1, 1, ene_spr1:getWidth()/2, ene_spr1:getHeight()/2)
		end
	end
end