extends Node

func _ready():
	$mainmenu.volume_db = -4
	$station.volume_db = 0
	$zoomedbattle.volume_db = -10
	$battle.volume_db = 8
	play_start()
	
func play_start():
	$mainmenu.volume_db = -4
	$mainmenu.play()
	
func playtrack(track):
	killmusic()
	$AnimationPlayer.play(track)

func killmusic():
	for playtrack in ['mainmenu', 'station', 'zoomedbattle', 'battle']:
		if get_node(playtrack).playing:
			$AnimationPlayer_fade.play(playtrack + '_fade')

func testing():
	print('test')