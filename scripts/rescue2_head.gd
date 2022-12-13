extends KinematicBody2D

var player_wr = null
var rot_speed = 3
var player_pos = Vector2()
var distance = 9999
var steering_angle = 0
var monster_id = 0

export (PackedScene) var spray

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
	
func shoot():
	var wpn = spray
	if wpn:
		wpn = spray.instance()
		$spray/spray_timer.start()
		$spray/spray_container.add_child(wpn)
		wpn.start_at(rotation + PI + PI/7, $spray_muzzle, null)

func assign_id(id):
	monster_id = id

func _ready():
	add_to_group('rescue2_head')
	if get_tree().get_nodes_in_group('player'):
		player_wr = weakref(get_tree().get_nodes_in_group('player')[0])

func _process(delta):
	if player_wr:
		if player_wr.get_ref():
			player_pos = player_wr.get_ref().global_position
			distance = global_position.distance_to(player_pos)
			#steering_angle = global_position.angle_to_point(player_pos) + PI/2
			if distance < 2000:
				#rotation = rotate_const_speed(rotation, steering_angle, rot_speed)
				rotation = global_position.angle_to_point(player_pos) - PI/7
			else:
				#rotation = rotate_const_speed(rotation, 0, rot_speed)
				rotation = 0
			if distance < 1000 and $spray/spray_timer.time_left == 0:
				shoot()
				
func take_damage(damage):
	var resc2 = get_tree().get_nodes_in_group('rescue2')
	var gui = get_tree().get_nodes_in_group('gui')
	if resc2 and gui and (monster_id in global.monsters.keys()):
		gui = gui[0]
		resc2 = resc2[0]
		global.monsters[monster_id]['health'] -= damage
		gui.update_enemy_bar(monster_id)
		if global.monsters[monster_id]['health'] <= 0:
			var cls = global.monsters[monster_id]['class']
			if global.kill_list:
				if cls in global.kill_list.keys():
					global.kill_list[cls] += 1
				else:
					global.kill_list[cls] = 1
			else:
				global.kill_list[cls] = 1
			global.monsters.erase(monster_id)
			eliminate_parts()
			
func eliminate_parts():
	var partnodes = get_tree().get_nodes_in_group('rescue2_parts')
	for nd in partnodes:
		nd.queue_free()
		queue_free()
