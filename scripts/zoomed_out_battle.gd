extends Node
var enemy = null
var enemy_piece = preload("res://scenes/enemies/zoomed_out_enemy.tscn")
var nest_piece = preload("res://scenes/enemies/zoomed_out_nest.tscn")
var rescue1 = preload("res://scenes/objects/rescue1.tscn")
var rescue2 = preload("res://scenes/objects/rescue2.tscn")
var rescue3 = preload("res://scenes/objects/rescue3.tscn")
var rescue4 = preload("res://scenes/objects/rescue4.tscn")
var rescue5 = preload("res://scenes/objects/rescue5.tscn")
var planet_speed = 10
var ship_wpnname_lkup = {'wpnlmb': 'weapon_lmb', 'wpnrmb': 'weapon_rmb', 'wpn1': 'weapon1', 'wpn2': 'weapon2', 'wpn3': 'weapon3', 'wpn4': 'weapon4', 'wpn5': 'weapon5'}
#var veryeasy_list = ['jelly', 'wurm', 'spawner', 'spacesnail']
var veryeasy_list = ['axial']
var veryeasy_nest_list = ['giant spider']
var easy_list = ['gorgon', 'axial']

func _ready():
	randomize()
	add_to_group('zoomed_out_battle')
	global.current_scene = 'zoomed_battle'
	#Input.set_custom_mouse_cursor(null, 0)
	initialize_objects()
	if global.gamestate in [1, 1.5]:
		initialize_intro_monsters()
	else:
		initialize_monsters()
	initialize_pieces()
	configure_ship()
	attach_weapons()
	$CanvasLayer/GUI/modules.rect_scale = Vector2(0.5,0.5)
	$CanvasLayer/GUI.initialize_bars()
	if !(music_manager.get_node('zoomedbattle').playing):
		music_manager.playtrack('zoomedbattle')

func _process(delta):
	#$planet1path/planet1follow.offset = $planet1path/planet1follow.offset + planet_speed * delta
	pass

func initialize_pieces():
	$zoomed_out_player/Sprite.texture = load(global.piece_dict[global.playership])

func initialize_monsters():
	var screensize = $star_system/CanvasLayer2/background.rect_size
	if global.monsters:
		for m in global.monsters.keys():
			if int(m) >= global.monster_count:
				enemy = nest_piece.instance()
			else:
				enemy = enemy_piece.instance()
			if not global.monsters[m]['last_pos']:
				enemy.position = Vector2(rand_range(0,60000), rand_range(0,40000))
			else:
				enemy.position = global.monsters[m]['last_pos']
			enemy.visible = false
			$enemy_container.add_child(enemy)
			enemy.assign_id(m)
			#enemy.initialize_gui()
	else:
		for cnt in range(global.monster_count):
			var enemy = enemy_piece.instance()
			enemy.visible = false
			new_monster(enemy, cnt)
		for cnt in range(global.monster_count, global.monster_count + global.nest_count):
			var enemy = nest_piece.instance()
			enemy.visible = false
			new_nest(enemy, cnt)
	new_rescue_instance('rescue1', 10000)
	new_rescue_instance('rescue2', 10001)
	new_rescue_instance('rescue3', 10002)
	new_rescue_instance('rescue4', 10003)
	new_rescue_instance('rescue5', 10004)
	
func initialize_intro_monsters():
	if not global.monsters:
		#first time through build monsters
		if global.gamestate == 1:
			#$CanvasLayer/GUI.start_message('controls')
			global.gamestate = 1.5
			var monster_locs = [$planet1path/planet1follow/station1.global_position + Vector2(500, 200),
								$planet1path/planet1follow/station1.global_position + Vector2(400, 200),
								$planet1path/planet1follow/station1.global_position + Vector2(450, 150),
								$planet1path/planet1follow/station1.global_position + Vector2(450, 250)]
			var cnt = 0
			for loc in monster_locs:
				var enemy = enemy_piece.instance()
				enemy.visible = false
				new_monster(enemy, cnt, loc)
				cnt += 1
		#get here if there arent any monsters because you got through the test
		elif global.gamestate == 1.5:
			global.gamestate = 2
			$CanvasLayer/GUI.start_message('state2')
	else:
		for m in global.monsters.keys():
			enemy = enemy_piece.instance()
			enemy.position = global.monsters[m]['last_pos']
			enemy.visible = false
			$enemy_container.add_child(enemy)
			enemy.assign_id(m)


func initialize_objects():
	$portal.global_position = global.enemy_gate
	#$planet1path/planet1follow/planet1.global_position = $planet1path.curve.get_closest_point($planet1path/planet1follow/planet1.global_position)
	pass
	
func configure_ship():
	var ship = get_tree().get_nodes_in_group('zoomed_player')[0]
	ship.move_speed = global.thrust / 2
	
func attach_weapons():
	var ship = get_tree().get_nodes_in_group('zoomed_player')[0]
	for wpn in ['wpn1', 'wpn2', 'wpn3', 'wpn4', 'wpn5']:
		var shipwpn = global.get(wpn)
		if shipwpn and (shipwpn != '-empty-') and (shipwpn in global.itemlist_lookup) and (global.itemlist[global.itemlist_lookup[shipwpn]][6] == 'longrange'):
			var weap = load("res://scenes/weapons/" + global.itemlist_lookup[shipwpn] + ".tscn")
			ship.set(ship_wpnname_lkup[wpn], weap)
			ship.configure_wpn(ship_wpnname_lkup[wpn], global.itemlist_lookup[shipwpn])

func new_monster(enemy, cnt, position=Vector2()):
	if position:
		enemy.position = position
	else:
		enemy.position = Vector2(rand_range(0,60000), rand_range(0,40000))
	var category = $star_system.return_enemydif(enemy.position)
	var monst = get('veryeasy_list')[randi() % len(get('veryeasy_list'))]
	global.monsters[cnt] = {'class': monst, 'last_pos': Vector2(), 'maxhealth': global.monsterlist[monst][0], 'health': global.monsterlist[monst][0], 'in_battle': false, 'dispindx': 0}
	$enemy_container.add_child(enemy)
	enemy.assign_id(cnt)
	#enemy.initialize_gui()
	
func new_nest(enemy, cnt):
	enemy.position = Vector2(rand_range(0,60000), rand_range(0,40000))
	var category = $star_system.return_enemydif(enemy.position)
	var monst = get('veryeasy_nest_list')[randi() % len(get('veryeasy_nest_list'))]
	global.monsters[cnt] = {'class': monst, 'last_pos': Vector2(), 'maxhealth': global.monsterlist[monst][0], 'health': global.monsterlist[monst][0], 'in_battle': false, 'dispindx': 0}
	$enemy_container.add_child(enemy)
	enemy.assign_id(cnt)

func new_rescue_instance(type, id):
	if global.get(type + '_discovered') < 2:
		var resc = get(type).instance()
		resc.global_position = global.get(type)
		if id in global.monsters.keys():
			global.monsters[id] = {'class': type,  'last_pos': Vector2(), 'maxhealth': global.monsterlist[type][0], 'health': global.monsters[id]['health'], 'in_battle': false, 'dispindx': 0}
		else:
			global.monsters[id] = {'class': type,  'last_pos': Vector2(), 'maxhealth': global.monsterlist[type][0], 'health': global.monsterlist[type][0], 'in_battle': false, 'dispindx': 0}
		$enemy_container.add_child(resc)
		resc.assign_id(id)
	
func goto_station(area):
	if area.get_groups().has('zoomed_player'):
		global.transition_pos = Vector2()
		global.transition_dir = ''
		#music_manager.playtrack('station')
		#global.goto_scene("res://scenes/station/spaceport.tscn")
		global.goto_scene("res://scenes/misc/bountyscreen.tscn")
		
func goto_cluster(area):
	if area.get_groups().has('zoomed_player'):
		global.transition_pos = Vector2(33900, 11260)
		global.transition_dir = 'TOP'
		global.goto_scene("res://scenes/misc/bountyscreen.tscn")


func _on_transition_timer_timeout():
	pass
	

func _on_rescue1_msgzone_area_entered(area):
	if area.get_groups().has('zoomed_player') and global.rescue1_discovered == 0:
		global.rescue1_discovered = 1
		$CanvasLayer/GUI.rescue1_message()
	elif area.get_groups().has('zoomed_player') and global.rescue1_discovered == 2:
		global.rescue1_discovered = 3
		$CanvasLayer/GUI.rescue1_complete()


func _on_rescue2_msgzone_area_entered(area):
	if area.get_groups().has('zoomed_player') and global.rescue2_discovered == 0:
		global.rescue2_discovered = 1
		$CanvasLayer/GUI.rescue2_message()
	if area.get_groups().has('zoomed_player') and global.rescue2_discovered == 2:
		global.rescue2_discovered = 3
		$CanvasLayer/GUI.rescue2_complete()


func _on_rescue3_msgzone_area_entered(area):
	if area.get_groups().has('zoomed_player') and global.rescue3_discovered == 0:
		global.rescue3_discovered = 1
		$CanvasLayer/GUI.rescue3_message()
	elif area.get_groups().has('zoomed_player') and global.rescue3_discovered == 2:
		global.rescue3_discovered = 3
		$CanvasLayer/GUI.rescue3_complete()


func _on_rescue4_msgzone_area_entered(area):
	if area.get_groups().has('zoomed_player') and global.rescue4_discovered == 0:
		global.rescue4_discovered = 1
		$CanvasLayer/GUI.rescue4_message()
	elif area.get_groups().has('zoomed_player') and global.rescue4_discovered == 2:
		global.rescue4_discovered = 3
		$CanvasLayer/GUI.rescue4_complete()


func _on_rescue5_msgzone_area_entered(area):
	if area.get_groups().has('zoomed_player') and global.rescue5_discovered == 0:
		global.rescue5_discovered = 1
		$CanvasLayer/GUI.rescue5_message()
	elif area.get_groups().has('zoomed_player') and global.rescue5_discovered == 2:
		global.rescue5_discovered = 3
		$CanvasLayer/GUI.rescue5_complete()


func _on_portal_msgzone_area_entered(area):
	if area.get_groups().has('zoomed_player') and global.portal_discovered == 0:
		global.portal_discovered = 1
		$CanvasLayer/GUI.portal_message()


func _on_twinplanets_msgzone_area_entered(area):
	if area.get_groups().has('zoomed_player') and global.twinplanet_discovered == 0:
		global.twinplanet_discovered = 1
		$CanvasLayer/GUI.cluster_message()