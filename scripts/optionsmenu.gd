extends Control


func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_HSlider_value_changed(value):
	#working audio levels are between -40 and 0 db
	$HBoxContainer/VBoxContainer/spacer2/HBoxContainer/menuitems/volume/vol.text = str(value)
	
	var lvl = (40 - ((value/100) * 40)) * -1
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), lvl)


func _on_returnbutton_pressed():
	if global.menuscene == 'mainmenu':
		global.goto_scene('res://scenes/mainmenu.tscn')
	elif global.menuscene == 'ingamemenu':
		self.hide()
