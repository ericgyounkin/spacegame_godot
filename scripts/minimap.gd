extends TextureRect

var player_wr = null
var drawpix = null
var bitpos = null
var mappos = null
var pcolor = Color(255,255,255)


func refresh_markers():
	if global.rescue1_discovered:
		$wreck1.show()
	if global.rescue2_discovered:
		$wreck2.show()
	if global.rescue3_discovered:
		$wreck3.show()
	if global.rescue4_discovered:
		$wreck4.show()
	if global.rescue5_discovered:
		$wreck5.show()
	if global.enemy_gate_discovered:
		$foundportal.show()
	if global.twinplanet_discovered:
		$foundcluster.show()

func _on_Timer_timeout():
	var plyr = get_tree().get_nodes_in_group('zoomed_player')
	if plyr:
		player_wr = weakref(plyr[0])
		if drawpix == null:
			bitpos = player_wr.get_ref().global_position
			mappos = bitpos / 46.15
			$cursor.position = mappos
		if $cursor.visible == true:
			$cursor.visible = false
		else:
			bitpos = player_wr.get_ref().global_position
			mappos = bitpos / 46.15
			$cursor.position = mappos
			$cursor.visible = true