extends "res://scripts/torpedo1.gd"

var enemy_wr = null
var enemy_pos = Vector2()

var steering_angle = 0
var angle_dif = 0
var rot_speed = 0.02

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	add_to_group('torpedo1')
	if get_tree().has_group('enemy'):
		enemy_wr = weakref(get_tree().get_nodes_in_group('enemy')[0])
	homing = true
		
func movement_behavior(delta):
	if get_tree().has_group('enemy'):
		if enemy_wr.get_ref():
			enemy_pos = enemy_wr.get_ref().position
			steering_angle = position.angle_to_point(enemy_pos) - PI/2
			# crossing 0 or 2PI causes the enemy to rotate around the wrong direction a full 2PI.  Add/subtract 2PI to prevent this
			rotation = rotate_const_speed(rotation, steering_angle, rot_speed)
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
	
func move_towards_float (x, target, step): #Moves towards t without passing it
	if abs(target - x) < abs(step):
		return target
	else: return x + step