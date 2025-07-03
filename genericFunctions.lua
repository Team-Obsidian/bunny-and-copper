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