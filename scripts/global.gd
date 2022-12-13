extends Node

# game settings
var player_name = 'Eric'
var player_credits= 9999999
var current_scene = ''
var currentscenename = ''
var menuscene = ''
var left_screen_limit = -2999
var top_screen_limit = -1999
var right_screen_limit = 2999
var bottom_screen_limit = 1999
var controls = 'keyboard'

#game state: 0 = intro, 1 = outside intro, 2 = after first battle, 3 = start explore
var gamestate = 3
var clusterintro = false

# map settings
var piece_dict = {'constructo': "res://art/ships/player_piece_yellow.png", 'turtleship': "res://art/ships/player_piece_blue.png", 'pinnace': "res://art/ships/player_piece_white.png"}
var enemy_gate = Vector2(45000,30000)
var enemy_gate_discovered = 0  # 0=undiscovered, 1=discovered, 2=defeated, 3=defeat message complete
var twinplanet = Vector2(33000,12000)
var twinplanet_discovered = 0
var rescue1 = Vector2(15000, 9000)
var rescue1_discovered = 0
var rescue2 = Vector2(12000, 25000)
var rescue2_discovered = 0
var rescue3 = Vector2(40000, 12000)
var rescue3_discovered = 0
var rescue4 = Vector2(25000, 15000)
var rescue4_discovered = 0
var rescue5 = Vector2(37000, 28000)
var rescue5_discovered = 0
var very_easy_boundaries = [Vector2(0,0),Vector2(60000, 40000)]
var easy_boundaries = [Vector2(enemy_gate.x - 30000, enemy_gate.y - 20000), Vector2(enemy_gate.x + 30000, enemy_gate.y + 20000)]
var medium_boundaries = [Vector2(enemy_gate.x - 25000, enemy_gate.y - 15000), Vector2(enemy_gate.x + 25000, enemy_gate.y + 15000)]
var hard_boundaries = [Vector2(enemy_gate.x - 20000, enemy_gate.y - 10000), Vector2(enemy_gate.x + 20000, enemy_gate.y + 10000)]
var very_hard_boundaries = [Vector2(enemy_gate.x - 10000, enemy_gate.y - 5000), Vector2(enemy_gate.x + 10000, enemy_gate.y + 50000)]
var monster_count = 1200
var nest_count = 150
var monsters = {}
#var monsters = [{'id': 0, 'class': 'wurm', 'last_pos': Vector2(), 'maxhealth': 0, 'health': 0, 'in_battle': false}, 
#				{'id': 1, 'class': 'wurm', 'last_pos': Vector2(), 'maxhealth': 0, 'health': 0, 'in_battle': false}, 
#				{'id': 2, 'class': 'wurm', 'last_pos': Vector2(), 'maxhealth': 0, 'health': 0, 'in_battle': false}]

# player settings
var playership = 'pinnace'
var maxhull = 0
var hull = 0
var maxshield = 0
var shield = 0
var rot_speed = 0
var thrust = 0
var max_vel = 0
var max_sight = 0
var transition_pos = Vector2()
var transition_dir = ''
var wpnlmb = ''
var wpnlmb_grouped = false
var wpnrmb = ''
var wpnrmb_grouped = false
var wpn1 = ''
var wpn1_grouped = false
var wpn2 = ''
var wpn2_grouped = false
var wpn3 = ''
var wpn3_grouped = false
var wpn4 = ''
var wpn4_grouped = false
var wpn5 = ''
var wpn5_grouped = false

# pinnace settings
var pinnace_price = 500
var pinnace_maxhull = 500
var pinnace_hull = 500
var pinnace_maxshield = 100
var pinnace_shield = 100
var pinnace_rot_speed = .02
var pinnace_thrust = 300
var pinnace_max_vel = 400
var pinnace_max_sight = 1200
var pinnace_lmb = 'blue laser'
var pinnace_wpn1 = ['Left Weapon Mount', 'weapon2_muzzle']
var pinnace_wpn2 = ['Right Weapon Mount', 'weapon3_muzzle']
var pinnace_wpn3 = ['Auxiliary', '']

# constructo settings
var constructo_price = 1200
var constructo_maxhull = 1200
var constructo_hull = 1200
var constructo_maxshield = 200
var constructo_shield = 200
var constructo_rot_speed = .01
var constructo_thrust = 150
var constructo_max_vel = 300
var constructo_max_sight = 800
var constructo_lmb = 'left arm'
var constructo_rmb = 'right arm'
var constructo_wpn1 = ['Forward Weapon Mount', 'weapon2_muzzle']
var constructo_wpn2 = ['Rear Weapon Mount', 'weapon1_muzzle']
var constructo_wpn3 = ['Auxiliary', '']
var constructo_wpn4 = ['Auxiliary', '']

# turtleship settings
var turtleship_price = 1000
var turtleship_maxhull = 1400
var turtleship_hull = 1400
var turtleship_maxshield = 500
var turtleship_shield = 500
var turtleship_rot_speed = .01
var turtleship_thrust = 100
var turtleship_max_vel = 200
var turtleship_max_sight = 600
var turtleship_lmb = 'blue laser'
var turtleship_rmb = 'chaingun'
var turtleship_wpn1 = ['Left Weapon Mount', 'weapon3_muzzle']
var turtleship_wpn2 = ['Right Weapon Mount', 'weapon2_muzzle']
var turtleship_wpn3 = ['Auxiliary', '']
var turtleship_wpn4 = ['Auxiliary', '']
var turtleship_wpn5 = ['Auxiliary', '']

var owned_ships = [{'name': 'pinnace', 'maxhull': pinnace_maxhull, 'maxshield': pinnace_maxshield, 'rot_speed': pinnace_rot_speed, 'thrust': 3000, 'max_vel': pinnace_max_vel,
					'max_sight': pinnace_max_sight, 'lmb': pinnace_lmb, 'wpn1': '', 'wpn1_opts': pinnace_wpn1, 'wpn2': '', 'wpn2_opts': pinnace_wpn2, 'wpn3': '', 'wpn3_opts': pinnace_wpn3}]

# monster list - health, movespeed, rotationspeed, stopdistance, worth
var monsterlist = {'wurm': [200,250,.04,160, 50],
				   'jelly': [500, 150, .02, 500, 75],
				   'giant spider': [4000, 200, .03, 3000, 500],
				   'small spider': [100, 200, .03, 0, 10],
				   'gorgon': [2000, 100, .01, 1500, 150],
				   'spawner': [1800, 80, .01, 2000, 100],
				   'spacesnail': [3000, 50, .01, 300, 100],
				   'axial': [2000, 100, .03, 1000, 300],
				   'rescue1': [1000, 0, 0, 9999, 1000],
				   'rescue2': [1000, 1200, 0, 9999, 1000],
				   'rescue3': [10000, 0, 0, 9999, 1000],
				   'rescue4': [10000, 0, 0, 9999, 1000],
				   'rescue5': [10000, 0, 0, 9999, 1000]}

# asteroid settings
var ast_health = {'big': 400, 'med': 200, 'small': 150, 'tiny': 100}
var break_pattern = {'big': 'med', 'med': 'small', 'small': 'tiny', 'tiny': null}

# station settings
var last_player_pos = Vector2()

# weapon settings
var damagelist = {'asteroid': 20, 'blue_laser': 50, 'red_beam': 5, 'wurm': 10, 'acid_breath': 100, 'spacesnailstrike': 100,
				  'torpedo1': 100, 'constructo_arm': 5, 'acidball': 20, 'lrm': 50, 'lightning_strike': 20, 'web': 80, 'small spider': 50,
				  'chaingun': 5, 'spawner_fly': 30, 'rescue1_eyeblast': 50, 'purple_breath': 100, 'axial_blade': 50}

# item settings
#item list is in [cost, damage, fire rate, rarity, displayname, type, mode]
var itemlist = {'torpedo1': [50, damagelist['torpedo1'], 1, 1, 'standard torpedo', 'missle', 'close'],
				'homing_torpedo1': [100, damagelist['torpedo1'], 1, 2, 'homing torpedo', 'missle', 'close'],
				'torpedo_swarm': [1000, damagelist['torpedo1'] * 10, 3, 5, 'torpedo swarm', 'auxiliary', 'close'],
				'blue_laser': [40, damagelist['blue_laser'], .4, 1, 'blue laser', 'weapon', 'close'],
				'red_beam': [200, damagelist['red_beam'], 3.5, 1, 'red beam', 'weapon', 'close'],
				'acid_thrower': [100, damagelist['acidball']*3, .3, 2, 'acid thrower', 'weapon', 'close'],
				'chaingun': [200, damagelist['chaingun'], '.5e', 3, 'chaingun', 'weapon', 'close'],
				'lrm': [500, damagelist['lrm'], 1, 3, 'LRM', 'missle', 'longrange'],
				'fwd_deflector': [200, 0, 12, 1, 'deflector', 'auxiliary', 'close']}
				
var itemlist_lookup = {'standard torpedo': 'torpedo1', 'homing torpedo': 'homing_torpedo1', 'torpedo swarm': 'torpedo_swarm', 'blue laser': 'blue_laser',
					   'red beam': 'red_beam', 'acid thrower': 'acid_thrower', 'LRM': 'lrm', 'chaingun': 'chaingun', 'deflector': 'fwd_deflector'}
var inventory = {}
var kill_list = {}


func add_to_inventory(item):
	if item in inventory.keys():
		inventory[item] += 1
	else:
		inventory[item] = 1


func take_from_inventory(item):
	if item in inventory.keys():
		if inventory[item] == 1:
			inventory.erase(item)
		else:
			inventory[item] -= 1


func _ready():
	pass
	
func goto_scene(path):
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)
	current_scene.queue_free()
	get_tree().change_scene(path)
	#var s = ResourceLoader.load(path)
	#new_scene = s.instance()
	#get_tree().get_root().add_child(new_scene)
	#get_tree().set_current_scene(new_scene)
	#current_scene.queue_free()
	#current_scene = new_scene