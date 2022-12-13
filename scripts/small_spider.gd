extends "res://scripts/enemy.gd"

var randangle = 0
var move = true
var jump = false

func _ready():
	$jump.wait_time = rand_range(15, 30)
	$jump.start()
	add_to_group('small spider')

func _process(delta):
	if player_wr.get_ref():
		if jump and distance <= 1500:
			jump_from_web(delta)
		else:
			seek_and_rotate_crawl_web(delta, move, randangle)
		
func initialize(hlth):
	max_health = global.monsterlist['small spider'][0]
	move_speed = global.monsterlist['small spider'][1]
	rot_speed = global.monsterlist['small spider'][2]
	stop_dist = global.monsterlist['small spider'][3]
	if not hlth:
		health = global.monsterlist['small spider'][0]
	else:
		health = hlth

func reverse_course():
	randangle = randangle + PI
	
func jump_from_web(delta):
	accel = Vector2(1200, 0).rotated(steering_angle - PI/2)
	var collision = move_and_collide(accel * delta)
	if collision and collision.collider.get_groups().has('player'):
		collision.collider.take_damage(global.damagelist['small spider'])
		queue_free()

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
