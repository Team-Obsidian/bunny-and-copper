require("misc")

function atkBullet(param)
	param.num = param.num or 1
	param.spread = param.spread or 0
	tempExport = {}
	for i=0, param.num-1 do
		item = {}
		item.x = param.x or scrCenterX
		item.y = param.y or scrCenterY
		-- no default value for start and end time, must be specified
		item.startTime = param.startTime
		item.endTime = param.endTime
		item.radius = param.radius or 20
		item.angle = math.rad(param.angle + param.spread*i) or param.angle or 0
		item.speed = param.speed or 100
		item.id = param.id or 0
		item.renderType = 'circle'
		table.insert(atk_All, item)
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

function genAtk2(item)
	item.atkStart = item.atkStart or 3
	item.atkDur = item.atkDur or 5

	item.x = item.x or scrCenterX
	item.y = item.y or scrCenterY
	--mixing up atkStart and startTime, fix later.
	item.startTime = elapsedTime + item.atkStart or elapsedTime + 3
	item.endTime = elapsedTime + item.atkStart + item.atkDur or elapsedTime + 8
	item.radius = item.radius or 20
	item.angle = item.angle or 0
	--item.spreadSpeed = item.spreadSpeed or 0 --also needs appropriate telegraph
	item.speed = item.speed or 0
	item.id = item.id or 2
	item.renderType = 'beam'
	table.insert(atk_All, item)		
end

function genAtk2Tele(item)
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