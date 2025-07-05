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

function atkTeleBullet(atk)

end