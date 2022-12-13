extends "res://scripts/enemy.gd"

func _ready():
	add_to_group('wurm')
	rotation = rotation - PI/2

func _process(delta):
	if $pause_for_breath.time_left == 0:
		if (health < 0.25 * max_health) and been_hit:
			flee(delta)
		else:
			seek_and_rotate(delta)
	if $weapon1/weapon1_timer.time_left == 0 and distance <= stop_dist:
		shoot('weapon1')
		$pause_for_breath.start()
		
func initialize(hlth):
	max_health = global.monsterlist['wurm'][0]
	move_speed = global.monsterlist['wurm'][1]
	rot_speed = global.monsterlist['wurm'][2]
	stop_dist = global.monsterlist['wurm'][3]
	if not hlth:
		health = global.monsterlist['wurm'][0]
	else:
		health = hlth
	