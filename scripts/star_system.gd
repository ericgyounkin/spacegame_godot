extends Container
export(NodePath) var planet1path



func _draw():
	var planet1_pts = get_node(planet1path).curve.tessellate()
	#draw_polyline(planet1_pts, Color(0,1,1,.5))
	
func draw_circle_arc(center, radius, angle_from, angle_to, color):
    var nb_points = 32
    var points_arc = PoolVector2Array()

    for i in range(nb_points+1):
        var angle_point = angle_from + i*(angle_to-angle_from)/nb_points - 90
        var point = center + Vector2( cos(deg2rad(angle_point)), sin(deg2rad(angle_point)) ) * radius
        points_arc.push_back( point )

    for indexPoint in range(nb_points):
        draw_line(points_arc[indexPoint], points_arc[indexPoint+1], color)
	
func return_enemydif(pos):
	if (pos.x > global.very_hard_boundaries[0].x) and (pos.x < global.very_hard_boundaries[1].x) and (pos.y > global.very_hard_boundaries[0].y) and (pos.y < global.very_hard_boundaries[1].y):
		return 'veryhard'
	elif (pos.x > global.hard_boundaries[0].x) and (pos.x < global.hard_boundaries[1].x) and (pos.y > global.hard_boundaries[0].y) and (pos.y < global.hard_boundaries[1].y):
		return 'hard'
	elif (pos.x > global.medium_boundaries[0].x) and (pos.x < global.medium_boundaries[1].x) and (pos.y > global.medium_boundaries[0].y) and (pos.y < global.medium_boundaries[1].y):
		return 'medium'
	elif (pos.x > global.easy_boundaries[0].x) and (pos.x < global.easy_boundaries[1].x) and (pos.y > global.easy_boundaries[0].y) and (pos.y < global.easy_boundaries[1].y):
		return 'easy'
	else:
		return 'veryeasy'