extends Area2D

var rot = 0
var rot_speed = 3
var move_speed = 300
var accel = Vector2()
var collision
var skip_extra_wheel = true
export(NodePath) var station1pth

var weapon1 = ''
var weapon2 = ''
var weapon3 = ''
var weapon4 = ''
var weapon5 = ''

var weapon1_options = ['weapon1/weapon_container', 'weapon1/weapon_timer', '', 'weapon1']
var weapon2_options = ['weapon2/weapon_container', 'weapon2/weapon_timer', '', 'weapon2']
var weapon3_options = ['weapon3/weapon_container', 'weapon3/weapon_timer', '', 'weapon3']
var weapon4_options = ['weapon4/weapon_container', 'weapon4/weapon_timer', '', 'weapon4']
var weapon5_options = ['$weapon5/weapon_container', 'weapon5/weapon_timer', '', 'weapon5']

var ammo = 0
var pts = PoolVector2Array()
onready var toplvl_canvas = get_node('../star_system')

func _ready():
	add_to_group('zoomed_player')
	$'../CanvasLayer/GUI'.show_gui_coordinates()
	if global.transition_dir and global.transition_pos:
		if global.transition_dir == 'TOP':
			position = global.transition_pos + Vector2(0,-60)
			rot = -PI/2
		elif global.transition_dir == 'TOPRESC':
			position = global.transition_pos + Vector2(0,-200)
			rot = -PI/2
		elif global.transition_dir == 'DOWN':
			position = global.transition_pos + Vector2(0,60)
			rot = PI/2
		elif global.transition_dir == 'DOWNRESC':
			position = global.transition_pos + Vector2(0,200)
			rot = PI/2
		elif global.transition_dir == 'LEFT':
			position = global.transition_pos + Vector2(-60,0)
			rot = PI
		elif global.transition_dir == 'LEFTRESC':
			position = global.transition_pos + Vector2(-200,0)
			rot = PI
		elif global.transition_dir == 'RIGHT':
			position = global.transition_pos + Vector2(60,0)
			rot = 0
		elif global.transition_dir == 'RIGHTRESC':
			position = global.transition_pos + Vector2(200,0)
			rot = 0
	else:
		position = get_node(station1pth).global_position + Vector2(300,300)
	
func _process(delta):
	get_input(delta)
	if accel:
		position += accel * delta
	handle_position()
	run_radar()
	$'../CanvasLayer/GUI'.update_gui_coordinates(global_position)
		
func handle_position():
	if position.x >= 60000:
		position.x = 60000
	elif position.x <= 0:
		position.x = 0
	if position.y >= 40000:
		position.y = 40000
	elif position.y <= 0:
		position.y = 0

func rotate_const_speed(a, b, d): #In radians
	if abs(a-b) >= PI: #only need to adjust for the long way round
		if a > b:
			b += 2 * PI
		else:
			a += 2 * PI
	if a > b:
		d = -d
	return move_towards_float(a, b, d)
	
func move_towards_float (x, target, step): #Moves towards t without passing it
	if abs(target - x) < abs(step):
		return target
	else: return x + step

func get_input(delta):
	if global.controls == 'keyboard':
		if Input.is_action_pressed('player_left'):
			rotation -= rot_speed * delta
		if Input.is_action_pressed('player_right'):
			rotation += rot_speed * delta
		if Input.is_action_pressed('player_thrust'):
			accel = Vector2(move_speed, 0).rotated(rotation)
		else:
			accel = Vector2(0, 0)
	elif global.controls == 'mouse':
		var steering_angle = global_position.angle_to_point(toplvl_canvas.get_global_mouse_position()) + PI
		rotation = rotate_const_speed(rotation, steering_angle, .06)
		if Input.is_action_pressed('player_thrust'):
			accel = Vector2(move_speed, 0).rotated(rot + PI)
		else:
			accel = Vector2(0, 0)

	if Input.is_action_pressed('player_lmb'):
		pass
	elif Input.is_action_pressed('player_rmb'):
		pass
	if Input.is_action_pressed('player_num1'):
		if weapon1:
			if $weapon1/weapon_timer.time_left == 0:
				ammo = update_gui_ammo('1')
				if ammo:
					shoot(weapon1_options, $weapon1_muzzle)
	if Input.is_action_pressed('player_num2'):
		if weapon2:
			if $weapon2/weapon_timer.time_left == 0:
				ammo = update_gui_ammo('2')
				if ammo:
					shoot(weapon2_options, $weapon1_muzzle)
	if Input.is_action_pressed('player_num3'):
		if weapon3:
			if $weapon3/weapon_timer.time_left == 0:
				ammo = update_gui_ammo('3')
				if ammo:
					shoot(weapon3_options, $weapon1_muzzle)
	if Input.is_action_pressed('player_num4'):
		if weapon4:
			if $weapon4/weapon_timer.time_left == 0:
				ammo = update_gui_ammo('4')
				if ammo:
					shoot(weapon4_options, $weapon1_muzzle)
	if Input.is_action_pressed('player_num5'):
		if weapon5:
			if $weapon5/weapon_timer.time_left == 0:
				ammo = update_gui_ammo('5')
				if ammo:
					shoot(weapon5_options, $weapon1_muzzle)
	
	if Input.is_action_pressed('press_q'):
		$radar.show()
	elif Input.is_action_just_released('press_q'):
		$radar.hide()
	if Input.is_action_pressed('press_e'):
		get_node('../CanvasLayer/GUI').show_minimap()
	elif Input.is_action_just_released('press_e'):
		get_node('../CanvasLayer/GUI').hide_minimap()
	
	# possible problems with pausing during transition
	if Input.is_action_just_pressed('ui_cancel') and !(transition.is_transitioning()):
		$'../CanvasLayer/ingamemenu'.pause_mode = Node.PAUSE_MODE_PROCESS
		$'../CanvasLayer/GUI'.hide()
		$'../CanvasLayer/ingamemenu'.show()
		get_tree().paused = true
		
func shoot(wpn_options, muzzle):
	get_node(wpn_options[1]).start()
	var wpn_proj = get(wpn_options[3]).instance()
	get_node(wpn_options[0]).add_child(wpn_proj)
	wpn_proj.start_at(get_rotation() + (PI/2), muzzle)
	
func update_gui_ammo(btn):
	var itemname = global.get('wpn' + btn)
	var itemref = global.itemlist_lookup[itemname]
	var currammo = global.inventory[itemname]
	if global.itemlist[itemref][5] in ['missle', 'misslespecial']:
		if global.inventory[itemname]:
			global.inventory[itemname] -= 1
		get_node('../CanvasLayer/GUI').initialize_button(btn)
	return currammo
		
func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_WHEEL_UP:
			if skip_extra_wheel and $customcamera.target_zoom >= 1:
				$customcamera.target_zoom -= 0.1
				#$camera.zoom -= Vector2(0.5,0.5)
			else:
				skip_extra_wheel = true
		if event.button_index == BUTTON_WHEEL_DOWN and skip_extra_wheel:
			if skip_extra_wheel and $customcamera.target_zoom <= 4:
				$customcamera.target_zoom += 0.1
			else:
				skip_extra_wheel = true

func _on_zoomed_out_player_area_entered(area):
	if area.get_groups().has('zoomed_enemy'):
		global.monsters[area.get_id()]['in_battle'] = true
		global.transition_pos = position
		$transition_timer.start()
		transition.fade_to("res://scenes/battle.tscn")
		music_manager.playtrack('battle')
		get_tree().paused = true

func _on_transition_timer_timeout():
	get_tree().paused = false
	
func configure_wpn(wpnname, weap):
	if global.itemlist.has(weap):
		var firerate = global.itemlist[weap][2]
		get_node(get(wpnname + '_options')[1]).wait_time = firerate

func return_circle_arc(center, radius, angle_from, angle_to, mode='relative'):
	var point = Vector2()
	var nb_points = 64
	var points_arc = PoolVector2Array()
	for i in range(nb_points+1):
		var angle_point = angle_from + i*(angle_to-angle_from)/nb_points - 95
		if mode == 'relative':
			point = Vector2(cos(deg2rad(angle_point)), sin(deg2rad(angle_point))) * radius
		elif mode == 'global':
			point = center + Vector2(cos(deg2rad(angle_point)), sin(deg2rad(angle_point))) * radius
		points_arc.push_back(point)
	return points_arc

func run_radar():
	pts = return_circle_arc(position, global.max_sight, 0, 360)
	$radar.update_settings(pts, global.max_sight)

func _on_shieldtimer_timeout():
	if global.shield < global.maxshield:
		global.shield += 2
		$'../CanvasLayer/GUI'.initialize_bars()
