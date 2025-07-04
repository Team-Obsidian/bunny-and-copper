require("misc")

function atkBullet(param)
	param.num = param.num or 1
	--degrees
	param.spread = param.spread or 0
	for i=0, param.num do
		item = {}
		item.x = item.x or scrCenterX
		item.y = item.y or scrCenterY
		item.radius = param.radius or 20
		--angle in radians
		item.angle = param.degree or math.rad(param.angle + param.spread*i)
		item.speed = param.speed or 100
		item.id = param.id or 0
		item.renderType = 'circle'
		table.insert(atk_All, item)
	end
end