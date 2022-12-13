extends Node

var monstercls = ''
var rescuecls = ''
var weapon_inst = null
var player_inst = null
var inbattle = []
var ship_wpnname_lkup = {'wpnlmb': 'weapon_lmb', 'wpnrmb': 'weapon_rmb', 'wpn1': 'weapon1', 'wpn2': 'weapon2', 'wpn3': 'weapon3', 'wpn4': 'weapon4', 'wpn5': 'weapon5'}

var wurm_positions = [Vector2((global.left_screen_limit + global.right_screen_limit) / 1.2, (global.top_screen_limit + global.bottom_screen_limit) / 1.2),
					  Vector2((global.left_screen_limit + global.right_screen_limit) / 1.2, (global.top_screen_limit + global.bottom_screen_limit) / 2),
					  Vector2((global.left_screen_limit + global.right_screen_limit) / 1.2, (global.top_screen_limit + global.bottom_screen_limit) / 6)]

func _ready():
	global.current_scene = 'battle'
	$CanvasLayer/GUI.initialize_bars()
	# override help cursor with targeting
	#Input.set_custom_mouse_cursor(battle_cursor, 16, Vector2(16,16))
	#Input.set_default_cursor_shape(Input.CURSOR_HELP)
	spawn_player(global.playership)
	#for i in range(1):
	#	spawn_asteroid('big', Vector2((global.left_screen_limit + global.right_screen_limit) / 2, (global.top_screen_limit + global.bottom_screen_limit) / 2), Vector2(0, 0))
	for id in global.monsters.keys():
		if global.monsters[id]['in_battle']:
			monstercls = global.monsters[id]['class']
			if monstercls.length() >= 6:
				rescuecls = monstercls.substr(0,6)
			if monstercls == 'giant spider':
				spawn_giant_spider(id, global.monsters[id]['health'])
			elif rescuecls == 'rescue':
				spawn_rescue(id, global.monsters[id]['class'], global.monsters[id]['health'])
			else:
				spawn_monster(id, global.monsters[id]['class'], global.monsters[id]['health'])

func return_class():
	return rescuecls

func initialize_enemy_gui(id):
	$"CanvasLayer/GUI".show_enemy_bar(id)
	$"CanvasLayer/GUI".update_enemy_bar(id)
	
func spawn_monster(id, cls, hlth):
	var mon = load("res://scenes/enemies/" + cls + ".tscn").instance()
	$enemy_container.add_child(mon)
	mon.init(wurm_positions[1], id)
	mon.initialize(hlth)
	initialize_enemy_gui(id)

func spawn_rescue(id, cls, hlth):
	var resc = load("res://scenes/enemies/" + cls + "battle.tscn").instance()
	resc.initialize(hlth)
	$enemy_container.add_child(resc)
	if cls == 'rescue1':
		resc.init(Vector2(global.right_screen_limit - 2000, (global.top_screen_limit + global.bottom_screen_limit) / 1.2), id)
	elif cls == 'rescue2':
		resc.init(id)
		create_rescue2()
	initialize_enemy_gui(id)
	
func spawn_giant_spider(id, hlth):
	var webbattle = load("res://scenes/enemies/webbattle.tscn").instance()
	$enemy_container.add_child(webbattle)
	webbattle.global_position = Vector2(global.right_screen_limit - 2000, (global.top_screen_limit + global.bottom_screen_limit) / 1.2)
	var mon = load("res://scenes/enemies/giant spider.tscn").instance()
	$enemy_container.add_child(mon)
	mon.init(Vector2(global.right_screen_limit - 2000, (global.top_screen_limit + global.bottom_screen_limit) / 1.2), id)
	mon.initialize(hlth)
	initialize_enemy_gui(id)
	for i in range(40):
		var spider = load("res://scenes/enemies/small spider.tscn").instance()
		$enemy_container.add_child(spider)
		spider.init(Vector2(rand_range(global.right_screen_limit - 1500, global.right_screen_limit - 2100), rand_range((global.top_screen_limit + global.bottom_screen_limit) / 1.2 - 300, (global.top_screen_limit + global.bottom_screen_limit) / 1.2 + 300)), 0)
		spider.initialize(global.monsterlist['small spider'][0])

func spawn_asteroid(size, pos, vel):
	var a = load("res://scenes/objects/asteroid.tscn").instance()
	$asteroid_container.add_child(a)
	a.connect('explode', self, 'explode_asteroid')
	a.init(size, pos, vel)
	
func explode_asteroid(size, pos, vel, hit_vel):
	var new_size = global.break_pattern[size]
	if new_size:
		for offset in [-1, 1]:
			var new_pos = pos + hit_vel.tangent().clamped(25) * offset
			var new_vel = vel + hit_vel.tangent() * offset
			spawn_asteroid(new_size, new_pos, new_vel)
	var expl = load("res://scenes/animations/explosion.tscn").instance()
	add_child(expl)
	expl.position = pos
	expl.play()

func attach_weapons():
	var ship = get_tree().get_nodes_in_group('player')[0]
	for wpn in ['wpnlmb', 'wpnrmb', 'wpn1', 'wpn2', 'wpn3', 'wpn4', 'wpn5']:
		var shipwpn = global.get(wpn)
		if shipwpn and (shipwpn != '-empty-') and (shipwpn in global.itemlist_lookup) and (global.itemlist[global.itemlist_lookup[shipwpn]][6] == 'close'):
			var weap = load("res://scenes/weapons/" + global.itemlist_lookup[shipwpn] + ".tscn")
			ship.set(ship_wpnname_lkup[wpn], weap)
			ship.configure_wpn(ship_wpnname_lkup[wpn], global.itemlist_lookup[shipwpn])

func spawn_player(shipname):
	if not has_node(shipname):
		var playr = load("res://scenes/ships/" + shipname + ".tscn").instance()
		add_child(playr)
		attach_weapons()
		
func create_rescue2():
	var beam1 = load("res://scenes/objects/rescue2_beam1.tscn")
	var beam2 = load("res://scenes/objects/rescue2_beam2.tscn")
	var beam3 = load("res://scenes/objects/rescue2_beam3.tscn")
	
	var beam1_1 = beam1.instance()
	beam1_1.global_position = Vector2(-2011.30835, -997.116455)
	beam1_1.rotation = PI/4
	$asteroid_container.add_child(beam1_1)
	
	var beam1_2 = beam1.instance()
	beam1_2.global_position = Vector2(1657.095947, 1022.133667)
	beam1_2.rotation = PI/4
	$asteroid_container.add_child(beam1_2)
	
	var beam1_3 = beam2.instance()
	beam1_3.global_position = Vector2(129.430435, -363.344452)
	beam1_3.rotation  = PI/5
	$asteroid_container.add_child(beam1_3)
	
	var beam1_4 = beam2.instance()
	beam1_4.global_position = Vector2(-1055.353027, 652.700317)
	beam1_4.rotation = -PI/2.25
	$asteroid_container.add_child(beam1_4)
	
	var beam1_5 = beam3.instance()
	beam1_5.global_position = Vector2(-2179.542969, 619.648193)
	beam1_5.rotation = PI/9
	$asteroid_container.add_child(beam1_5)
	
	var beam1_6 = beam3.instance()
	beam1_6.global_position = Vector2(-1826.315186, 736.116333)
	beam1_6.rotation = PI/36
	$asteroid_container.add_child(beam1_6)
	
	var beam1_7 = beam3.instance()
	beam1_7.global_position = Vector2(694.186035, 1164.741821)
	beam1_7.rotation = PI/9
	$asteroid_container.add_child(beam1_7)
	
	var beam1_8 = beam3.instance()
	beam1_8.global_position = Vector2(36.3479, -715.755249)
	beam1_8.rotation = PI/1.5
	$asteroid_container.add_child(beam1_8)
	
	var beam1_9 = beam2.instance()
	beam1_9.global_position = Vector2(-1388.390747, -1243.603027)
	beam1_9.rotation = PI/1.33
	$asteroid_container.add_child(beam1_9)
	
	var beam1_10 = beam2.instance()
	beam1_10.global_position = Vector2(2091.535156, 587.370972)
	beam1_10.rotation = PI/1.33
	$asteroid_container.add_child(beam1_10)
	
	var beam1_11 = beam2.instance()
	beam1_11.global_position = Vector2(1195.478027, -1544.397339)
	beam1_11.rotation = PI/6
	$asteroid_container.add_child(beam1_11)