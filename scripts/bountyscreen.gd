extends Control
var state = 0

func _ready():
	pass

func _on_synctimer_timeout():
	state += 1
	if state == 1:
		$Tween.interpolate_property($ColorRect/VBoxContainer/HBoxContainer/ProgressBar, 'value', 0, 100, .4, $Tween.TRANS_LINEAR, $Tween.EASE_IN)
		$Tween.start()
	if state == 2:
		$Tween.interpolate_property($ColorRect/VBoxContainer/HBoxContainer2/ProgressBar, 'value', 0, 100, .4, $Tween.TRANS_LINEAR, $Tween.EASE_IN)
		$Tween.start()
	if state == 3:
		$Tween.stop_all()
		var totalkills = 0
		$ColorRect/VBoxContainer/HBoxContainer3.visible = true
		for kills in global.kill_list:
			totalkills += global.kill_list[kills]
		$Tween.interpolate_property(self, 'totalkills', 0, totalkills, .4, $Tween.TRANS_LINEAR, $Tween.EASE_IN)
		$Tween.start()
	if state == 4:
		$Tween.stop_all()
		var earnedcredits = 0
		$ColorRect/VBoxContainer/HBoxContainer4.visible = true
		for kills in global.kill_list:
			earnedcredits += (global.monsterlist[kills][4] * global.kill_list[kills])
		$Tween.interpolate_property(self, 'earnedcredits', 0, earnedcredits, .4, $Tween.TRANS_LINEAR, $Tween.EASE_IN)
		$Tween.start()
		global.kill_list = {}
		global.player_credits += earnedcredits
	if state == 5:
		$ColorRect/VBoxContainer/HBoxContainer5.visible = true
		$ColorRect/VBoxContainer/HBoxContainer5/Label.text = 'Entering Station'
	if state == 6:
		$ColorRect/VBoxContainer/HBoxContainer5/Label.text = 'Entering Station.'
	if state == 7:
		$ColorRect/VBoxContainer/HBoxContainer5/Label.text = 'Entering Station..'
	if state == 8:
		if global.transition_pos == Vector2():
			music_manager.playtrack('station')
			global.goto_scene("res://scenes/station/spaceport.tscn")
		else:
			#music_manager.playtrack('cluster')
			global.goto_scene("res://scenes/station/clusterstation.tscn")

func _on_Tween_tween_step(object, key, elapsed, value):
	if state == 3:
		$ColorRect/VBoxContainer/HBoxContainer3/totalkills.text = String(value)
	if state == 4:
		$ColorRect/VBoxContainer/HBoxContainer4/earnedcredits.text = String(value)
