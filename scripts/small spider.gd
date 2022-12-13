extends "res://scripts/enemy.gd"

var randangle = 0
var move = true
var jump = false

func _ready():
	$jump.wait_time = rand_range(20, 60)
	$jump.start()
	add_to_group('small_spider')

func _process(delta):
	if jump and distance <= 1500:
		jump_from_web(delta)
	else:
		crawl_web(delta)
		
func initialize(hlth):
	max_health = global.monsterlist['small_spider'][0]
	move_speed = global.monsterlist['small_spider'][1]
	rot_speed = global.monsterlist['small_spider'][2]
	stop_dist = global.monsterlist['small_spider'][3]
	if not hlth:
		health = global.monsterlist['small_spider'][0]
	else:
		health = hlth

func reverse_course():
	randangle = randangle + PI
	
func jump_from_web(delta):
	if player_wr.get_ref():
		#player_pos = player_wr.get_ref().position
		#distance = position.distance_to(player_pos)
		#steering_angle = position.angle_to_point(player_pos) - PI/2
		accel = Vector2(1200, 0).rotated(steering_angle - PI/2)
		var collision = move_and_collide(accel * delta)
		if collision and collision.collider.get_groups().has('player'):
			collision.collider.take_damage(global.damagelist['small_spider'])
			queue_free()

func crawl_web(delta):
	if player_wr.get_ref():
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
		if abs(rotation - steering_angle) > .001:
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

func take_damage(damage):
	queue_free()

func _on_jump_timeout():
	jump = true
