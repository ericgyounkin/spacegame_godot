extends "res://scripts/enemy.gd"

func _ready():
	add_to_group('spacesnail')
	rotation = rotation - PI/2

func _process(delta):
	if (health < 0.25 * max_health) and been_hit:
		flee(delta)
	else:
		seek_and_rotate(delta)
		
	if $weapon1/weapon1_timer.time_left == 0 and $weapon2/weapon2_timer.time_left == 0 and distance <= stop_dist:
		swing()
		
func initialize(hlth):
	max_health = global.monsterlist['spacesnail'][0]
	move_speed = global.monsterlist['spacesnail'][1]
	rot_speed = global.monsterlist['spacesnail'][2]
	stop_dist = global.monsterlist['spacesnail'][3]
	if not hlth:
		health = global.monsterlist['spacesnail'][0]
	else:
		health = hlth
		
func swing():
	if player_wr.get_ref():
		print('------------------')
		print(position, ' ', global_position)
		var wpn = wpn_dict['weapon1'][0]
		var wpn2 = wpn_dict['weapon2'][0]
		if wpn:
			wpn = wpn.instance()
			wpn.set_left_right('left')
			wpn_dict['weapon1'][3].start()
			wpn_dict['weapon1'][2].add_child(wpn)
			wpn.start_at(rotation, wpn_dict['weapon1'][1])
		if wpn2:
			wpn = wpn2.instance()
			wpn.set_left_right('right')
			wpn_dict['weapon2'][3].start()
			wpn_dict['weapon2'][2].add_child(wpn)
			wpn.start_at(rotation, wpn_dict['weapon2'][1])

func _on_boosttimer_wait_timeout():
	move_speed = global.monsterlist['spacesnail'][1] * 5
	$boosttimer_boost.start()

func _on_boosttimer_boost_timeout():
	move_speed = global.monsterlist['spacesnail'][1]
