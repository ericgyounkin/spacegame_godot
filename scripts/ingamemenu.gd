extends Control
var save_game = null
var save_gamepth = ''

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	add_to_group('ingamemenu')
	pass

func _on_resume_pressed():
	get_tree().paused = false
	self.hide()
	if get_tree().has_group('zoomed_out_battle'):
		$'../../CanvasLayer/GUI'.show()


func _on_quit_main_menu_pressed():
	get_tree().paused = false
	global.transition_pos = Vector2()
	global.transition_dir = ''
	music_manager.play_start()
	global.goto_scene('res://scenes/mainmenu.tscn')

func _on_quit_desktop_pressed():
	get_tree().quit()


func _on_options_pressed():
	global.menuscene = 'ingamemenu'
	$"../optionsmenu".show()
	

func _on_save_pressed():
	save_game = File.new()
	#save_gamepth = self.get_script().get_path().get_base_dir() + '/savegame.save'
	save_gamepth = 'user://savegame.save'
	if save_game.file_exists(save_gamepth):
		$AcceptDialog.popup()
	else:
		
		completesave()


func _on_AcceptDialog_confirmed():
	completesave()


func completesave():
	var savegame = {}
	savegame['currentscenename'] = get_tree().get_current_scene().get_filename()
	var x = global.get_property_list()
	for i in x:
		if !(i['name'] in ['enemy_gate', 'currentscenename', 'Node', '_import_path', 'Pause', 'pause_mode', 
							'editor/display_folded', 'name', 'filename', 'owner', 'Script Variables', 'script', 
							'twinplanet', 'rescue1', 'rescue2', 'rescue3', 'rescue4', 'rescue5', 'very_easy_boundaries',
							'easy_boundaries', 'medium_boundaries', 'hard_boundaries', 'very_hard_boundaries', 'transition_pos', 'last_player_pos']):
			savegame[i['name']] = global.get(i['name'])
	save_game.open(save_gamepth, File.WRITE)
	save_game.store_line(to_json(savegame))
	save_game.close()
