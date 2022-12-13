extends Area2D

var vel = Vector2()
var start_dir = 0
export var speed = 120
var accel = Vector2(0,0)
var continuous = false
var homing = true
var exclusion = 'zoomed_player'

var enemy_wr = null
var enemy_pos = Vector2()

var steering_angle = 0
var angle_dif = 0
var rot_speed = 0.02

func _ready():
	add_to_group('LRM')
	
func closest_node_of_nodes(nodes):
	var dist = 0
	var min_dist = 9999
	var returnarr = null
	for n in nodes:
		if n.visible == true:
			dist = position.distance_to(n.position)
			if dist < min_dist:
				min_dist = dist
				returnarr = n
	return returnarr

func movement_behavior(delta):
	if get_tree().has_group('zoomed_enemy') and enemy_wr != null:
		if enemy_wr.get_ref():
			enemy_pos = enemy_wr.get_ref().position
			steering_angle = position.angle_to_point(enemy_pos) - PI/2
			# crossing 0 or 2PI causes the enemy to rotate around the wrong direction a full 2PI.  Add/subtract 2PI to prevent this
			rotation = rotate_const_speed(rotation, steering_angle, rot_speed)
			position += ((accel + vel) * delta).rotated(rotation - PI/2)
		else:
			position += ((accel + vel) * delta).rotated(rotation - PI/2)
	else:
		position += ((accel + vel) * delta).rotated(rotation - PI/2)
	
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
	
func _physics_process(delta):
	accel += Vector2(10,0)
	if start_dir:
		if homing:
			movement_behavior(delta)
		else:
			movement_behavior_std(delta)

func movement_behavior_std(delta):
	position += ((accel + vel) * delta).rotated(rotation - PI/2)

func start_at(dir, muzzle):
	start_dir = dir
	set_rotation(dir)
	set_position(muzzle.global_position)
	vel = Vector2(speed, 0)
	if get_tree().has_group('zoomed_enemy'):
		var enemy_nodes = get_tree().get_nodes_in_group('zoomed_enemy')
		enemy_wr = weakref(closest_node_of_nodes(enemy_nodes))
	
func take_damage(damage):
	queue_free()
	
func _on_lifetime_timeout():
	queue_free()

func _on_lrm_area_entered(area):
	if area.get_groups().has('zoomed_enemy'):
		queue_free()
		area.take_damage(global.damagelist['lrm']) # replace with function body