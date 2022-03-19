extends Area2D


#Orb
var nearestGrab = null
var typeGrab


func grab():
	if(nearestGrab != null):
		nearestGrab.OrbGrab()
		typeGrab = nearestGrab.typeGrab
		return nearestGrab
	return null

func highlight(positionPlayer):
	if nearestGrab != null:
		nearestGrab.removePlayer()
		nearestGrab = null
	var areas = get_overlapping_areas()
	var nearestArea = null
	for area in areas:
		if area.has_method('getPlayer') && nearestArea != null:
			if area.global_position.distance_to(positionPlayer) < nearestArea.global_position.distance_to(positionPlayer):
				nearestArea = area
		elif area.has_method('getPlayer') && area != null:
			nearestArea = area
	if nearestArea != null:
		nearestArea.removePlayer()
		nearestGrab = nearestArea
		nearestGrab.getPlayer(positionPlayer)

	return false
