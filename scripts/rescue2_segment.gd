extends KinematicBody2D

var monster_id = 0


func _ready():
	add_to_group('rescue2_parts')

func assign_id(id):
	monster_id = id
	
func take_damage(damage):
	var resc2 = get_tree().get_nodes_in_group('rescue2')
	var gui = get_tree().get_nodes_in_group('gui')
	if resc2 and gui and (monster_id in global.monsters.keys()):
		gui = gui[0]
		resc2 = resc2[0]
		global.monsters[monster_id]['health'] -= damage
		gui.update_enemy_bar(monster_id)
		if global.monsters[monster_id]['health'] <= 0:
			var cls = global.monsters[monster_id]['class']
			if global.kill_list:
				if cls in global.kill_list.keys():
					global.kill_list[cls] += 1
				else:
					global.kill_list[cls] = 1
			else:
				global.kill_list[cls] = 1
			global.monsters.erase(monster_id)
			get_tree().get_nodes_in_group('rescue2_head')[0].eliminate_parts()