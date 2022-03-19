extends Area2D


#Orb
var nearestOrb = null

func attack():
	if nearestOrb != null:
		nearestOrb.OrbDelete()
		return true
	return false


func highlight():
	var areas = get_overlapping_areas()
	for area in areas:
		if(area.has_method('OrbHighlight')) and !area.isDead:
			area.OrbHighlight()
			nearestOrb = area
			return true
	if nearestOrb != null:
		nearestOrb.OrbUnHighlight()
		nearestOrb = null
	return false
