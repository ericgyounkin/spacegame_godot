extends "res://scripts/enemy.gd"

func _ready():
	add_to_group('jelly')

func _process(delta):
	move_and_rotate(delta, false)
	if $weapon1/weapon1_timer.time_left == 0 and distance <= stop_dist:
		shoot('weapon1', self)
		
func initialize(hlth):
	max_health = global.monsterlist['jelly'][0]
	move_speed = global.monsterlist['jelly'][1]
	rot_speed = global.monsterlist['jelly'][2]
	stop_dist = global.monsterlist['jelly'][3]
	if not hlth:
		health = global.monsterlist['jelly'][0]
	else:
		health = hlth