extends Area2D

var id = 0

var distance = Vector2()
var player_pos = Vector2()
var steering_angle = 0
var angle_dif = 0
var accel = Vector2()
var collision

var rot_speed = 1
var move_speed = 20

onready var player_wr = weakref($"../../zoomed_out_player")

func _ready():
	add_to_group('zoomed_enemy')

func _process(delta):
	if player_wr.get_ref() and visible:
		player_pos = player_wr.get_ref().position
		distance = position.distance_to(player_pos)
		steering_angle = position.angle_to_point(player_pos) - PI/2
		accel = Vector2(move_speed, 0).rotated(steering_angle - PI/2)
		position += accel * delta

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