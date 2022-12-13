extends KinematicBody2D

var explosion = preload("res://scenes/animations/explosion.tscn")
export (PackedScene) var weapon1
export (PackedScene) var weapon2
export (PackedScene) var weapon3

onready var wpn_dict = {'weapon1': [weapon1, $weapon1_muzzle, $weapon1/weapon1_container, $weapon1/weapon1_timer],
						'weapon2': [weapon2, $weapon2_muzzle, $weapon2/weapon2_container, $weapon2/weapon2_timer],
						'weapon3': [weapon3, $weapon3_muzzle, $weapon3/weapon3_container, $weapon3/weapon3_timer]}

var rot = 0
var vel = Vector2()
var accel = Vector2()
var pos = Vector2()

var health = 0
var max_health = 0
var move_speed = 0
var rot_speed = 0
var stop_dist = 0
var rot_dif = 0
var been_hit = false

var screen_size = Vector2()
var player_wr
var player_pos = Vector2()
var player_vel = Vector2()
var distance = Vector2()
var steering_angle = 0
var monster_id = 0

func init(pos, id):
	add_to_group('enemy')
	monster_id = id
	player_wr = weakref(get_tree().get_nodes_in_group('player')[0])
	screen_size = get_viewport_rect().size
	position = pos

func move_and_strafe(delta):
	if player_wr.get_ref():
		player_pos = player_wr.get_ref().position
		distance = position.distance_to(player_pos)
		steering_angle = position.angle_to_point(player_pos) - PI/2
		rot_dif = rotate_const_speed(rotation, steering_angle, rot_speed)
		if rot_dif > rotation:
			accel = Vector2(move_speed, 0).rotated(steering_angle)
		elif rot_dif < rotation:
			accel = Vector2(move_speed, 0).rotated(steering_angle - PI)
		else:
			accel = Vector2(move_speed, 0).rotated(steering_angle - PI/2)
		rotation = rot_dif
		move_and_slide(accel)
	

func move_and_rotate(delta, rotation_enabled=true):
	if player_wr.get_ref():
		player_pos = player_wr.get_ref().position
		distance = position.distance_to(player_pos)
		steering_angle = position.angle_to_point(player_pos) - PI/2
		if rotation_enabled:
			rotation = rotate_const_speed(rotation, steering_angle, rot_speed)
		# 100 is a constant that is the pixel distance from center of player to cause the enemy to stop
		if distance > stop_dist:
			accel = Vector2(move_speed, 0).rotated(steering_angle - PI/2)
			move_and_slide(accel)
			#var collision = move_and_collide(accel * delta)
			#if collision:
				#vel = vel.bounce(collision.normal)
				#puff_of_dust(collision.position)

func seek_and_rotate(delta):
	var time_offset = 0.25
	if player_wr.get_ref():
		player_pos = player_wr.get_ref().position
		player_vel = player_wr.get_ref().vel
		distance = position.distance_to(player_pos)
		steering_angle = position.angle_to_point(player_pos + player_vel * time_offset) - PI/2
		rotation = rotate_const_speed(rotation, steering_angle, rot_speed)
		# 100 is a constant that is the pixel distance from center of player to cause the enemy to stop
		if distance > stop_dist:
			accel = Vector2(move_speed, 0).rotated(steering_angle - PI/2)
			move_and_slide(accel)

func seek_and_rotate_crawl_web(delta, move, randangle):
	var time_offset = 1
	if player_wr.get_ref():
		player_pos = player_wr.get_ref().position
		player_vel = player_wr.get_ref().vel
		distance = position.distance_to(player_pos)
		steering_angle = position.angle_to_point(player_pos + player_vel * time_offset) - PI/2
		rotation = rotate_const_speed(rotation, steering_angle, rot_speed)
		# 100 is a constant that is the pixel distance from center of player to cause the enemy to stop
		if move:
			accel = Vector2(move_speed, 0).rotated(randangle)
			move_and_slide(accel)

func flee(delta):
	if player_wr.get_ref():
		player_pos = player_wr.get_ref().position
		distance = position.distance_to(player_pos)
		steering_angle = position.angle_to_point(player_pos) - PI/2
		rotation = rotate_const_speed(rotation, -steering_angle, rot_speed)
		# 100 is a constant that is the pixel distance from center of player to cause the enemy to stop
		accel = Vector2(move_speed, 0).rotated(-steering_angle - PI/2)
		move_and_slide(accel)

func rotate_const_speed(a, b, d): #In radians
	if abs(a-b) >= PI: #only need to adjust for the long way round
		if a > b:
			b += 2 * PI
		else:
			a += 2 * PI
	if a > b:
		d = -d
	return move_towards_float(a, b, d)
	
func move_towards_float(x, target, step): #Moves towards t without passing it
	if abs(target - x) < abs(step):
		return target
	else: return x + step
	

func take_damage(damage):
	been_hit = true
	if monster_id in global.monsters:
		health -= damage
		global.monsters[monster_id]['health'] = health
		$"../../CanvasLayer/GUI".update_enemy_bar(monster_id)
		if health <= 0:
			var cls = global.monsters[monster_id]['class']
			if global.kill_list:
				if cls in global.kill_list.keys():
					global.kill_list[cls] += 1
				else:
					global.kill_list[cls] = 1
			else:
				global.kill_list[cls] = 1
			global.monsters.erase(monster_id)
			var expl = explosion.instance()
			get_tree().get_root().add_child(expl)
			expl.position = position
			expl.play()
			queue_free()
	
func shoot(index, parent=null):
	if player_wr.get_ref():
		var wpn = wpn_dict[index][0]
		if wpn:
			wpn = wpn.instance()
			wpn_dict[index][3].start()
			wpn_dict[index][2].add_child(wpn)
			wpn.start_at(rotation, wpn_dict[index][1], parent)
	
func turn_on_camera():
	$Camera2D.current = true