extends "res://scripts/enemy.gd"

var randangle = 0
var move = true

func _ready():
	add_to_group('giant_spider')

func _process(delta):
	if player_wr.get_ref():
		crawl_web(delta)
		if $weapon1/weapon1_timer.time_left == 0 and distance <= stop_dist:
			shoot('weapon1', self)
		
func initialize(hlth):
	max_health = global.monsterlist['giant_spider'][0]
	move_speed = global.monsterlist['giant_spider'][1]
	rot_speed = global.monsterlist['giant_spider'][2]
	stop_dist = global.monsterlist['giant_spider'][3]
	if not hlth:
		health = global.monsterlist['giant_spider'][0]
	else:
		health = hlth

func reverse_course():
	randangle = randangle + PI
		
func crawl_web(delta):
	player_pos = player_wr.get_ref().position
	distance = position.distance_to(player_pos)
	steering_angle = position.angle_to_point(player_pos) - PI/2
	# crossing 0 or 2PI causes the enemy to rotate around the wrong direction a full 2PI.  Add/subtract 2PI to prevent this
	angle_dif = rotation - steering_angle
	if angle_dif < 6.5 and angle_dif > 6.0:
		rotation -= 2 * PI
	elif -angle_dif < 6.5 and -angle_dif > 6.0:
		rotation += 2 * PI
	# .1 is a tolerance that eliminates jitter in the sprite
	if abs(rotation - steering_angle) > .01:
		if rotation < steering_angle:
			rotation += rot_speed
		else:
			rotation -= rot_speed
	if move:
		accel = Vector2(move_speed, 0).rotated(randangle)
		move_and_slide(accel)

func _on_startcrawling_timeout():
	randangle = rand_range(-PI, PI)
	if move:
		move = false
	else:
		move = true