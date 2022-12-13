extends Area2D

var id = 0
onready var player_wr = weakref($"../../zoomed_out_player")

func _ready():
	add_to_group('zoomed_enemy')

func _process(delta):
	$smallenemypath1/PathFollow2D.offset = $smallenemypath1/PathFollow2D.offset + 10 * delta
	$smallenemypath2/PathFollow2D.offset = $smallenemypath2/PathFollow2D.offset + 10 * delta
	$smallenemypath3/PathFollow2D.offset = $smallenemypath3/PathFollow2D.offset + 10 * delta
	$smallenemypath4/PathFollow2D.offset = $smallenemypath4/PathFollow2D.offset + 10 * delta
	
func assign_id(new_id):
	id = new_id

func use_last_pos():
	var ps = global.monsters[id]['last_pos']
	if ps:
		position = ps
		
func get_id():
	return id

func take_damage(damage):
	global.monsters[id]['health'] -= damage
	if global.monsters[id]['health'] <= 0:
		var cls = global.monsters[id]['class']
		if global.kill_list:
			if cls in global.kill_list.keys():
				global.kill_list[cls] += 1
			else:
				global.kill_list[cls] = 1
		else:
			global.kill_list[cls] = 1
		$"../../CanvasLayer/GUI".remove_enemy_bar(id)
		global.monsters.erase(id)
		queue_free()
	else:
		$"../../CanvasLayer/GUI".update_enemy_bar(id)
	
func _on_update_pos_timeout():
	global.monsters[id]['last_pos'] = position

func entered_radar():
	visible = true
	$"../../CanvasLayer/GUI".show_enemy_bar(id)

func left_radar():
	visible = false
	$"../../CanvasLayer/GUI".remove_enemy_bar(id)