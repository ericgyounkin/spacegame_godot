extends "res://scripts/enemy.gd"

var randangle = 0
var move = true

func _ready():
	add_to_group('giant spider')

func _process(delta):
	if player_wr.get_ref():
		seek_and_rotate_crawl_web(delta, move, randangle)
		if $weapon1/weapon1_timer.time_left == 0 and distance <= stop_dist:
			shoot('weapon1', self)
		
func initialize(hlth):
	max_health = global.monsterlist['giant spider'][0]
	move_speed = global.monsterlist['giant spider'][1]
	rot_speed = global.monsterlist['giant spider'][2]
	stop_dist = global.monsterlist['giant spider'][3]
	if not hlth:
		health = global.monsterlist['giant spider'][0]
	else:
		health = hlth

func reverse_course():
	randangle = randangle + PI

func _on_startcrawling_timeout():
	randangle = rand_range(-PI, PI)
	if move:
		move = false
	else:
		move = true