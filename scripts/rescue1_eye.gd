extends "res://scripts/enemy.gd"

func _ready():
	add_to_group('rescue1_eye')
	player_wr = weakref(get_tree().get_nodes_in_group('player')[0])
	#rotation = rotation + PI/2
	rot_speed = 3

func move_and_rotate(delta, rotation_enabled=true):
	if player_wr.get_ref():
		player_pos = player_wr.get_ref().global_position
		distance = global_position.distance_to(player_pos)
		steering_angle = global_position.angle_to_point(player_pos) - PI/2
		if rotation_enabled:
			rotation = rotate_const_speed(rotation, steering_angle, rot_speed) + PI/2
		# 100 is a constant that is the pixel distance from center of player to cause the enemy to stop
		if distance > stop_dist:
			accel = Vector2(move_speed, 0).rotated(steering_angle - PI/2)
			move_and_slide(accel)

func shoot(index, parent=null):
	if player_wr.get_ref():
		var wpn = wpn_dict[index][0]
		if wpn:
			wpn = wpn.instance()
			wpn_dict[index][3].start()
			wpn_dict[index][2].add_child(wpn)
			wpn.start_at(rotation - PI/2, wpn_dict[index][1], parent)

func _process(delta):
	if get_owner().health > 0:
		move_and_rotate(delta)
		if $weapon1/weapon1_timer.time_left == 0:
			shoot('weapon1', 'rescue1_eye')

func take_damage(damage):
	pass