extends 'player.gd'

var weapon_lmb = ''
var weapon_rmb = ''
var weapon1 = ''
var weapon2 = ''
var weapon3 = ''
var weapon4 = ''
var weapon5 = ''

var weapon_lmb_options = ['weapon_lmb/weapon_container', 'weapon_lmb/weapon_lmb_timer', '', 'weapon_lmb', 'linear']
var weapon_rmb_options = ['weapon_rmb/weapon_container', 'weapon_rmb/weapon_rmb_timer', '', 'weapon_rmb', 'linear']
var weapon1_options = ['weapon1/weapon_container', 'weapon1/weapon_1_timer', '', 'weapon1', 'linear']
var weapon2_options = ['weapon2/weapon_container', 'weapon2/weapon_2_timer', '', 'weapon2', 'linear']
var weapon3_options = ['weapon3/weapon_container', 'weapon3/weapon_3_timer', '', 'weapon3', 'linear']
var weapon4_options = ['weapon4/weapon_container', 'weapon4/weapon_4_timer', '', 'weapon4', 'linear']
var weapon5_options = ['$weapon5/weapon_container', 'weapon5/weapon_5_timer', '', 'weapon5', 'linear']

var steering_angle = 0
var ammo = 0
var lastchar = ''
var firerate = 0
onready var toplvl_canvas = get_node('../background')

func _ready():
	ready_player()
	rotation = PI/2
	max_vel = global.max_vel
	thrust = global.thrust
	rot_speed = global.rot_speed
	
func _process(delta):
	get_input(delta)
	handle_movement(delta, max_vel)

func get_input(delta):
	steering_angle = position.angle_to_point(toplvl_canvas.get_local_mouse_position()) - PI/2
	rotation = rotate_const_speed(rotation, steering_angle, rot_speed)
			
	if Input.is_action_pressed('player_thrust'):
		accel = Vector2(thrust, 0).rotated(rotation - PI/2)
		$exhaust.show()
	else:
		accel = Vector2(0, 0)
		$exhaust.hide()
		
	if Input.is_action_pressed('player_lmb'):
		if weapon_lmb:
			if $weapon_lmb/weapon_lmb_timer.time_left == 0:
				ammo = update_gui_ammo('lmb')
				if ammo:
					get_node('../CanvasLayer/GUI').red_button('lmb')
					shoot(weapon_lmb_options, $weapon1_muzzle)
		if weapon_rmb and global.wpnrmb_grouped:
			if $weapon_rmb/weapon_rmb_timer.time_left == 0:
				ammo = update_gui_ammo('rmb')
				if ammo:
					get_node('../CanvasLayer/GUI').red_button('rmb')
					shoot(weapon_rmb_options, $weapon1_muzzle)
		if weapon1 and global.wpn1_grouped:
			if $weapon1/weapon_1_timer.time_left == 0:
				ammo = update_gui_ammo('1')
				if ammo:
					get_node('../CanvasLayer/GUI').red_button('1')
					shoot(weapon1_options, $weapon3_muzzle)
		if weapon2 and global.wpn2_grouped:
			if $weapon2/weapon_2_timer.time_left == 0:
				ammo = update_gui_ammo('2')
				if ammo:
					get_node('../CanvasLayer/GUI').red_button('2')
					shoot(weapon2_options, $weapon2_muzzle)
		if weapon3 and global.wpn3_grouped:
			if $weapon3/weapon_3_timer.time_left == 0:
				ammo = update_gui_ammo('3')
				if ammo:
					get_node('../CanvasLayer/GUI').red_button('3')
					shoot(weapon3_options, $weapon3_muzzle)
		if weapon4 and global.wpn4_grouped:
			if $weapon4/weapon_4_timer.time_left == 0:
				ammo = update_gui_ammo('4')
				if ammo:
					get_node('../CanvasLayer/GUI').red_button('4')
					shoot(weapon4_options, $weapon4_muzzle)
		if weapon5 and global.wpn5_grouped:
			if $weapon5/weapon_5_timer.time_left == 0:
				ammo = update_gui_ammo('5')
				if ammo:
					get_node('../CanvasLayer/GUI').red_button('5')
					shoot(weapon5_options, $weapon5_muzzle)
	if Input.is_action_pressed('player_rmb'):
		if weapon_rmb:
			if $weapon_rmb/weapon_rmb_timer.time_left == 0:
				ammo = update_gui_ammo('rmb')
				if ammo:
					get_node('../CanvasLayer/GUI').red_button('rmb')
					shoot(weapon_rmb_options, $weapon1_muzzle)
	if Input.is_action_pressed('player_num1'):
		if weapon1:
			if $weapon1/weapon_1_timer.time_left == 0:
				ammo = update_gui_ammo('1')
				if ammo:
					get_node('../CanvasLayer/GUI').red_button('1')
					shoot(weapon1_options, $weapon3_muzzle)
	if Input.is_action_pressed('player_num2'):
		if weapon2:
			if $weapon2/weapon_2_timer.time_left == 0:
				ammo = update_gui_ammo('2')
				if ammo:
					get_node('../CanvasLayer/GUI').red_button('2')
					shoot(weapon2_options, $weapon2_muzzle)
	if Input.is_action_pressed('player_num3'):
		if weapon3:
			if $weapon3/weapon_3_timer.time_left == 0:
				ammo = update_gui_ammo('3')
				if ammo:
					get_node('../CanvasLayer/GUI').red_button('3')
					shoot(weapon3_options, $weapon3_muzzle)
	if Input.is_action_pressed('player_num4'):
		if weapon4:
			if $weapon4/weapon_4_timer.time_left == 0:
				ammo = update_gui_ammo('4')
				if ammo:
					get_node('../CanvasLayer/GUI').red_button('4')
					shoot(weapon4_options, $weapon4_muzzle)
	if Input.is_action_pressed('player_num5'):
		if weapon5:
			if $weapon5/weapon_5_timer.time_left == 0:
				ammo = update_gui_ammo('5')
				if ammo:
					get_node('../CanvasLayer/GUI').red_button('5')
					shoot(weapon5_options, $weapon5_muzzle)
					
	if Input.is_action_just_released('player_lmb'):
		if weapon_lmb_options[4] == 'expincrease':
			# reset firerate if you've been changing it over time (chaingun)
			firerate = global.itemlist[weapon_lmb_options[2]][2]
			firerate = float(firerate.substr(0,len(firerate)-1))
			$weapon_lmb/weapon_lmb_timer.wait_time = firerate
		if global.wpnrmb_grouped and weapon_rmb_options[4] == 'expincrease':
			firerate = global.itemlist[weapon_rmb_options[2]][2]
			firerate = float(firerate.substr(0,len(firerate)-1))
			$weapon_rmb/weapon_rmb_timer.wait_time = firerate
		if global.wpn1_grouped and weapon1_options[4] == 'expincrease':
			firerate = global.itemlist[weapon1_options[2]][2]
			firerate = float(firerate.substr(0,len(firerate)-1))
			$weapon1/weapon_1_timer.wait_time = firerate
		if global.wpn2_grouped and weapon2_options[4] == 'expincrease':
			firerate = global.itemlist[weapon2_options[2]][2]
			firerate = float(firerate.substr(0,len(firerate)-1))
			$weapon2/weapon_2_timer.wait_time = firerate
		if global.wpn3_grouped and weapon3_options[4] == 'expincrease':
			firerate = global.itemlist[weapon3_options[2]][2]
			firerate = float(firerate.substr(0,len(firerate)-1))
			$weapon3/weapon_3_timer.wait_time = firerate
		if global.wpn4_grouped and weapon4_options[4] == 'expincrease':
			firerate = global.itemlist[weapon4_options[2]][2]
			firerate = float(firerate.substr(0,len(firerate)-1))
			$weapon4/weapon_4_timer.wait_time = firerate
		if global.wpn5_grouped and weapon5_options[4] == 'expincrease':
			firerate = global.itemlist[weapon5_options[2]][2]
			firerate = float(firerate.substr(0,len(firerate)-1))
			$weapon5/weapon_5_timer.wait_time = firerate
	if Input.is_action_just_released('player_rmb'):
		if weapon_rmb_options[4] == 'expincrease':
			firerate = global.itemlist[weapon_rmb_options[2]][2]
			firerate = float(firerate.substr(0,len(firerate)-1))
			$weapon_rmb/weapon_rmb_timer.wait_time = firerate
	if Input.is_action_just_released('player_num1'):
		if weapon1_options[4] == 'expincrease':
			firerate = global.itemlist[weapon1_options[2]][2]
			firerate = float(firerate.substr(0,len(firerate)-1))
			$weapon1/weapon_1_timer.wait_time = firerate
	if Input.is_action_just_released('player_num2'):
		if weapon2_options[4] == 'expincrease':
			firerate = global.itemlist[weapon2_options[2]][2]
			firerate = float(firerate.substr(0,len(firerate)-1))
			$weapon2/weapon_2_timer.wait_time = firerate
	if Input.is_action_just_released('player_num3'):
		if weapon3_options[4] == 'expincrease':
			firerate = global.itemlist[weapon3_options[2]][2]
			firerate = float(firerate.substr(0,len(firerate)-1))
			$weapon3/weapon_3_timer.wait_time = firerate
	if Input.is_action_just_released('player_num4'):
		if weapon4_options[4] == 'expincrease':
			firerate = global.itemlist[weapon4_options[2]][2]
			firerate = float(firerate.substr(0,len(firerate)-1))
			$weapon4/weapon_4_timer.wait_time = firerate
	if Input.is_action_just_released('player_num5'):
		if weapon5_options[4] == 'expincrease':
			firerate = global.itemlist[weapon5_options[2]][2]
			firerate = float(firerate.substr(0,len(firerate)-1))
			$weapon5/weapon_5_timer.wait_time = firerate
					
	if Input.is_action_just_pressed('ui_cancel'):
		$'../CanvasLayer2/ingamemenu'.show()
		get_tree().paused = true
		
func shoot(wpn_options, muzzle):
	get_node(wpn_options[1]).start()
	if wpn_options[4] == 'expincrease':
		if get_node(wpn_options[1]).wait_time > 0.1:
			get_node(wpn_options[1]).wait_time = get_node(wpn_options[1]).wait_time - (get_node(wpn_options[1]).wait_time / 6)
	var wpn_proj = get(wpn_options[3]).instance()
	get_node(wpn_options[0]).add_child(wpn_proj)
	wpn_proj.start_at(get_rotation(), muzzle)

func update_gui_ammo(btn):
	var itemname = global.get('wpn' + btn)
	var itemref = global.itemlist_lookup[itemname]
	var currammo = global.inventory[itemname]
	if global.itemlist[itemref][5] in ['missle', 'misslespecial']:
		if global.inventory[itemname]:
			global.inventory[itemname] -= 1
		get_node('../CanvasLayer/GUI').initialize_button(btn)
	return currammo

func configure_wpn(wpnname, weap):
	if global.itemlist.has(weap):
		firerate = global.itemlist[weap][2]
		lastchar = str(firerate).right(len(str(firerate))-1)
		if lastchar == 'e':
			firerate = float(firerate.substr(0,len(firerate)-1))
			get(wpnname + '_options')[4] = 'expincrease'
		get_node(get(wpnname + '_options')[1]).wait_time = firerate
		get(wpnname + '_options')[2] = weap

func _on_transition_timer_timeout():
	get_tree().paused = false


func _on_weapon_lmb_timer_timeout():
	get_node('../CanvasLayer/GUI').green_button('lmb')


func _on_weapon_rmb_timer_timeout():
	get_node('../CanvasLayer/GUI').green_button('rmb')
	

func _on_weapon_1_timer_timeout():
	get_node('../CanvasLayer/GUI').green_button('1')
	

func _on_weapon_2_timer_timeout():
	get_node('../CanvasLayer/GUI').green_button('2')


func _on_weapon_3_timer_timeout():
	get_node('../CanvasLayer/GUI').green_button('3')


func _on_weapon_4_timer_timeout():
	get_node('../CanvasLayer/GUI').green_button('4')


func _on_weapon_5_timer_timeout():
	get_node('../CanvasLayer/GUI').green_button('5')
