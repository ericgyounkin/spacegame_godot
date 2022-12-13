extends Container
var newgame_pressed = false

func _ready():
	transition.layer = -1
	#var screen_size = OS.get_screen_size()
	#var window_size = OS.get_window_size()
	#OS.set_window_position(screen_size*0.5 - window_size*0.5)
	$HBoxContainer/VBoxContainer/HBoxContainer/menu_options/new_game_btn.add_color_override('font_color', Color(67,70,103))
	$HBoxContainer/VBoxContainer/HBoxContainer/menu_options/new_game_btn.add_color_override('font_color_hover', Color(255,0,0))
	$HBoxContainer/VBoxContainer/HBoxContainer/menu_options/load_game_btn.add_color_override('font_color', Color(67,70,103))
	$HBoxContainer/VBoxContainer/HBoxContainer/menu_options/load_game_btn.add_color_override('font_color_hover', Color(255,0,0))
	$HBoxContainer/VBoxContainer/HBoxContainer/menu_options/quit_game_btn.add_color_override('font_color', Color(67,70,103))
	$HBoxContainer/VBoxContainer/HBoxContainer/menu_options/quit_game_btn.add_color_override('font_color_hover', Color(255,0,0))

func _on_new_game_btn_pressed():
	if global.gamestate == 0:
		if newgame_pressed == false:
			newgame_pressed = true
			transition.intro_anim("res://scenes/station/station.tscn")
	else:
		transition.intro_music()
		global.goto_scene("res://scenes/station/station.tscn")
		

func _on_quit_game_btn_pressed():
	if newgame_pressed == false:
		get_tree().quit()


func _on_options_btn_pressed():
	global.menuscene = 'mainmenu'
	global.goto_scene("res://scenes/misc/optionsmenu.tscn")


func _on_load_game_btn_pressed():
	var splt = Array()
	var save_game = File.new()
	#var save_gamepth = self.get_script().get_path().get_base_dir() + '/savegame.save'
	var save_gamepth = 'user://savegame.save'
	if not save_game.file_exists(save_gamepth):
		return
	save_game.open(save_gamepth, File.READ)
	var current_line = parse_json(save_game.get_as_text())
	for x in current_line.keys():
		global[x] = current_line[x]
		# serializing doesn't support vector2, find them in dicts
		if typeof(global[x]) == TYPE_DICTIONARY:
			for y in global[x].keys():
				if typeof(global[x][y]) == TYPE_STRING:
					if global[x][y].substr(0,1) in [0,1,2,3,4,5,6,7,8,9]:
						global[x][y] = int(global[x][y])
					elif global[x][y].substr(0,1) == '(':
						splt = global[x][y].split(',')
						if splt.size() > 1:
							global[x][y] = Vector2(splt[0].substr(1, splt[0].length()-1), splt[1].substr(0,splt[0].length()-2))
				elif typeof(global[x][y]) == TYPE_DICTIONARY:
					for z in global[x][y].keys():
						if typeof(global[x][y][z]) == TYPE_STRING:
							if global[x][y][z].substr(0,1) in [0,1,2,3,4,5,6,7,8,9]:
								global[x][y][z] = int(global[x][y][z])
							elif global[x][y][z].substr(0,1) == '(':
								splt = global[x][y][z].split(',')
								if splt.size() > 1:
									global[x][y][z] = Vector2(splt[0].substr(1, splt[0].length()-1), splt[1].substr(0,splt[0].length()-2))
		# serializing data for save seems to screw up types, converts some things to string which blows
		elif typeof(global[x]) == TYPE_STRING:
			# Check if it is actually an int instead of string
			if global[x].substr(0,1) in [0,1,2,3,4,5,6,7,8,9]:
				global[x] = int(global[x])
			elif global[x].substr(0,1) == '(':
				splt = global[x].split(',')
				if splt.size() > 1:
					global[x] = Vector2(splt[0].substr(1, splt[0].length()-1), splt[1].substr(0,splt[0].length()-2))
	save_game.close()
	global.goto_scene(global['currentscenename'])
	