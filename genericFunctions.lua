function distTo(item1,item2)
	if item1 ~= nil and item2 ~= nil then
		xDist = math.abs(item1.x - item2.x)
		yDist = math.abs(item1.y - item2.y)
		return math.sqrt(xDist^2 + yDist^2)
	else
		print('distTo of a nonexistent object')
		return 1 -- no divide by zeros I hope
	end
end

function posFromDist(item, dist)
	newPos = {
		x = item.x + math.cos(item.angle)*dist,
		y = item.y + math.sin(item.angle)*dist
	}
	print('newPosX is ' .. newPos.x)
	print('newPosY is ' .. newPos.y)
	return newPos
end