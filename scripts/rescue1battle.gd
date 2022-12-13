extends "res://scripts/enemy.gd"

func _ready():
	add_to_group('rescue1battle')
	#player_wr = weakref(get_tree().get_nodes_in_group('player')[0])
	pass

func _process(delta):
	pass
	
	
func initialize(hlth):
	max_health = global.monsterlist['rescue1'][0]
	move_speed = global.monsterlist['rescue1'][1]
	rot_speed = global.monsterlist['rescue1'][2]
	stop_dist = global.monsterlist['rescue1'][3]
	if not hlth:
		health = global.monsterlist['rescue1'][0]
	else:
		health = hlth

func take_damage(damage):
	been_hit = true
	if monster_id in global.monsters:
		health -= damage
		global.monsters[monster_id]['health'] = health
		$"../../CanvasLayer/GUI".update_enemy_bar(monster_id)
		if health <= 0:
			var cls = global.monsters[monster_id]['class']
			if global.kill_list:
				if cls in global.kill_list.keys():
					global.kill_list[cls] += 1
				else:
					global.kill_list[cls] = 1
			else:
				global.kill_list[cls] = 1
			global.monsters.erase(monster_id)
			$rescue1_eye.hide()
			$rescue1_eye2.hide()
			$rescue1_eye3.hide()
			$rescue1_eye4.hide()
			$rescue1_eye5.hide()
			$eyeclosed1.show()
			$eyeclosed2.show()
			$eyeclosed3.show()
			$eyeclosed4.show()
			$eyeclosed5.show()
			global.rescue1_discovered = 2