extends Node

func get_lanes(padding: Vector2, lane_count: int):
	var vp = get_viewport().size 
	var playable_width: int
	
	if (padding.x*2) > vp.x:
		print("Padding is larger than the width of the screen. Removing padding.
		") 
		playable_width = vp.x 
	else:
		playable_width = vp.x - padding.x*2
	
	# Segments are the sections between lanes. 
	# There will always be one more segment than there are lanes.
	var segments = lane_count + 1
	var distance_between_lanes: int = playable_width / (segments)
	
	var lanes: Array[int] = []

	
	for x in range(1, segments):
		lanes.append(distance_between_lanes*x)
	
	
	# Debugging.
	print("Width of screen: " + str(vp.x))
	print("Width of screen with padding: " + str(playable_width))
	print("Distance between lanes: " + str(distance_between_lanes))
	print("Lanes: ", str(lanes))
