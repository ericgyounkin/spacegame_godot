extends CanvasLayer

var path = ""

# PUBLIC FUNCTION. CALLED WHENEVER YOU WANT TO CHANGE SCENE
func fade_to(scn_path):
	self.path = scn_path # store the scene path
	get_node("transitionanimation").play("fade") # play the transition animation

func intro_anim(scn_path):
	self.path = scn_path
	get_node("transitionanimation").play("introfade")
	
func is_transitioning():
	return $transitionanimation.is_playing()

func intro_music():
	#music_manager.playtrack('station')
	music_manager.killmusic()


# PRIVATE FUNCTION. CALLED AT THE MIDDLE OF THE TRANSITION ANIMATION
func change_scene():
	if path != "":
		get_tree().change_scene(path)
		
func intro_text():
	$introtext.reset()
	$introtext.set_color(Color(255,255,255))
	$introtext.buff_text('Manticore Station\n', 0.06)
	$introtext.buff_silence(.6)
	$introtext.buff_text('Sector A1689-zD1\n', 0.06)
	$introtext.buff_silence(.6)
	$introtext.buff_text('20 years since the first invasion\n', 0.06)
	$introtext.buff_silence(.6)
	$introtext.set_state($introtext.STATE_OUTPUT)
	
func save_game():
	pass
	
	