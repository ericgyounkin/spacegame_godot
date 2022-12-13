extends "res://scripts/enemy.gd"

func _ready():
	add_to_group('gorgon')
	rotation = rotation - PI/2

func _process(delta):
	if (health < 0.25 * max_health) and been_hit:
		flee(delta)
	else:
		move_and_rotate(delta)
		if $weapon1/weapon1_timer.time_left == 0 and distance <= stop_dist:
			shoot('weapon1', 'gorgon')
		
func initialize(hlth):
	max_health = global.monsterlist['gorgon'][0]
	move_speed = global.monsterlist['gorgon'][1]
	rot_speed = global.monsterlist['gorgon'][2]
	stop_dist = global.monsterlist['gorgon'][3]
	if not hlth:
		health = global.monsterlist['gorgon'][0]
	else:
		health = hlth

func shoot(index, parent=null):
	if player_wr.get_ref():
		var wpn = wpn_dict[index][0]
		if wpn:
			wpn = wpn.instance()
			wpn.add_to_group('enemyprojectile')
			wpn_dict[index][3].start()
			wpn_dict[index][2].add_child(wpn)
			wpn.start_at(rotation, wpn_dict[index][1], parent)
	