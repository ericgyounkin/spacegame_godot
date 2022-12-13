extends Container

var enemy_ctr = 1
var itemtype = ''
var itemname = ''
var itemref = ''
var quantity = 0
var active_enemies = {0:-1,1:-1,2:-1,3:-1,4:-1,5:-1,6:-1,7:-1,8:-1,9:-1}
var redbuttonstyle = load('res://scenes/misc/redbutton.tres')
var greenbuttonstyle = load('res://scenes/misc/greenbutton.tres')

func _ready():
	add_to_group('gui')
	green_button('lmb')
	green_button('rmb')
	green_button('1')
	green_button('2')
	green_button('3')
	green_button('4')
	green_button('5')
	self.mouse_filter = MOUSE_FILTER_IGNORE
	
func update_gui_coordinates(pos):
	$modules/bottombars/coordinates.text = String(int(pos[0]/5)) + ',' + String(int(pos[1]/5))
	
func show_gui_coordinates():
	$modules/bottombars/coordinates.visible = true
	
func hide_gui_coordinates():
	$modules/bottombars/coordinates.visible = false

func initialize_bars():
	$modules/top_panel/status/Bars/Shield_Bar/Gauge.max_value = global.maxshield
	$modules/top_panel/status/Bars/Shield_Bar/Gauge.value = global.shield
	$modules/top_panel/status/Bars/Hull_Bar/Gauge.max_value = global.maxhull
	$modules/top_panel/status/Bars/Hull_Bar/Gauge.value = global.hull
	$modules/top_panel/status/Bars/Shield_Bar/Count/Background/Number.text = str(global.shield)
	$modules/top_panel/status/Bars/Hull_Bar/Count/Background/Number.text = str(global.hull)
	initialize_button('lmb')
	initialize_button('rmb')
	initialize_button('1')
	initialize_button('2')
	initialize_button('3')
	initialize_button('4')
	initialize_button('5')
	

func red_button(btn):
	var button = get_node("modules/bottombars/buttons/Button_" + btn)
	button.set('custom_styles/normal', redbuttonstyle)
	
func green_button(btn):
	var button = get_node("modules/bottombars/buttons/Button_" + btn)
	button.set('custom_styles/normal', greenbuttonstyle)
	
func show_minimap():
	$modules/top_panel/VBoxContainer/minimap.refresh_markers()
	$modules/top_panel/VBoxContainer/minimap.show()
	
func hide_minimap():
	$modules/top_panel/VBoxContainer/minimap.hide()

func initialize_button(btn):
	var button = get_node("modules/bottombars/buttons/Button_" + btn)
	if global.get('wpn' + btn) and global.get('wpn' + btn) != '-empty-':
		button.visible = true
		itemname = global.get('wpn' + btn)
		if !(itemname in ['left arm', 'right arm']):
			itemref = global.itemlist_lookup[itemname]
			itemtype = global.itemlist[itemref][5]
			if itemtype in ['missle', 'misslespecial']:
				quantity = global.inventory[itemname]
				button.text = btn + ': ' + itemname + '(' + str(quantity) + ')'
				if int(quantity) == 0:
					red_button(btn)
					button.disabled = true
			else:
				button.text = btn + ': ' + itemname
			if (global.current_scene == 'battle' and global.itemlist[itemref][6] == 'longrange') or (global.current_scene == 'zoomed_battle' and global.itemlist[itemref][6] == 'close'):
				red_button(btn)
				button.disabled = true
			else:
				button.disabled = false
		else:
			button.text = btn + ': ' + itemname
	else:
		red_button(btn)
		button.visible = false


func show_enemy_bar(id):
	if !(int(id) in active_enemies.values()):
		for i in active_enemies.keys():
			if int(active_enemies[i]) == -1:
				active_enemies[i] = int(id)
				get_node("modules/top_panel/enemy_status/enemy_bar" + str(i)).show()
				update_enemy_bar(id)
				#print('showbar')
				#print(i, id, active_enemies)
				break


func remove_enemy_bar(id):
	if int(id) in active_enemies.values():
		for i in active_enemies.keys():
			if int(active_enemies[i]) == int(id):
				active_enemies[i] = -1
				get_node("modules/top_panel/enemy_status/enemy_bar" + str(i)).hide()
				#print('hidebar')
				#print(i, id, active_enemies)
				break


func update_enemy_bar(id):
	if int(id) in active_enemies.values():
		for i in active_enemies.keys():
			if int(active_enemies[i]) == int(id):
				get_node("modules/top_panel/enemy_status/enemy_bar" + str(i) + '/Gauge').max_value = global.monsters[id]['maxhealth']
				get_node("modules/top_panel/enemy_status/enemy_bar" + str(i) + '/Gauge').value = global.monsters[id]['health']
				get_node("modules/top_panel/enemy_status/enemy_bar" + str(i) + '/Count/Background/Number').text = str(global.monsters[id]['health'])
				get_node("modules/top_panel/enemy_status/enemy_bar" + str(i) + '/Count/Background/Label').text = str(global.monsters[id]['class'])
				if int(global.monsters[id]['health']) <= 0:
					active_enemies[i] = -1
					get_node("modules/top_panel/enemy_status/enemy_bar" + str(i)).hide()
				#print('updatebar')
				#print(i, id, active_enemies)
				break


func start_message(type):
	if type == 'state2':
		$modules/bottombars/TextInterfaceEngine.reset()
		$modules/bottombars/TextInterfaceEngine.set_color(Color(255,255,255))
		$modules/bottombars/TextInterfaceEngine.buff_silence(3)
		$modules/bottombars/TextInterfaceEngine.buff_text("Not bad Lieutenant!  ", 0.025)
		$modules/bottombars/TextInterfaceEngine.buff_silence(2)
		$modules/bottombars/TextInterfaceEngine.buff_text("Your tour here might be more exciting than you thought!\n\n", 0.025)
		$modules/bottombars/TextInterfaceEngine.buff_silence(2)
		$modules/bottombars/TextInterfaceEngine.buff_text("Where did these bastards come from...", 0.025)
		$modules/bottombars/TextInterfaceEngine.buff_silence(2)
		$modules/bottombars/TextInterfaceEngine.buff_text("head on back, we need to discuss a few things.", 0.025)
		$modules/bottombars/TextInterfaceEngine.buff_silence(3)
		$modules/bottombars/TextInterfaceEngine.buff_clear()
		$modules/bottombars/TextInterfaceEngine.set_state($modules/bottombars/TextInterfaceEngine.STATE_OUTPUT)
		
func rescue1_message():
	$modules/bottombars/TextInterfaceEngine.reset()
	$modules/bottombars/TextInterfaceEngine.set_color(Color(255,255,255))
	$modules/bottombars/TextInterfaceEngine.buff_text("We got a distress message from a vessel nearby!  ", 0.025)
	$modules/bottombars/TextInterfaceEngine.buff_silence(2)
	$modules/bottombars/TextInterfaceEngine.buff_text("Praetorian, looks like a freighter, 'course every one of their ships is armed to the teeth.\n\n", 0.025)
	$modules/bottombars/TextInterfaceEngine.buff_silence(2)
	$modules/bottombars/TextInterfaceEngine.buff_text("They must be hurt bad to ask for our help.  Why not check it out.  ", 0.025)
	$modules/bottombars/TextInterfaceEngine.buff_silence(2)
	$modules/bottombars/TextInterfaceEngine.buff_text("Find them at (" + String(int(global.rescue1[0]/5)) + ',' + String(int(global.rescue1[1]/5)) + ')', 0.025)
	$modules/bottombars/TextInterfaceEngine.buff_silence(5)
	$modules/bottombars/TextInterfaceEngine.buff_clear()
	$modules/bottombars/TextInterfaceEngine.set_state($modules/bottombars/TextInterfaceEngine.STATE_OUTPUT)
	

func rescue1_complete():
	$modules/bottombars/TextInterfaceEngine.reset()
	$modules/bottombars/TextInterfaceEngine.set_color(Color(255,255,255))
	$modules/bottombars/TextInterfaceEngine.buff_silence(1)
	$modules/bottombars/TextInterfaceEngine.buff_text("What in the hell was that thing!?!  ", 0.025)
	$modules/bottombars/TextInterfaceEngine.buff_silence(2)
	$modules/bottombars/TextInterfaceEngine.buff_text("Looked almost like it was eating its way through that ship!\n\n", 0.025)
	$modules/bottombars/TextInterfaceEngine.buff_silence(2)
	$modules/bottombars/TextInterfaceEngine.buff_text("Praetorians were watching your battle, they said they must repay this debt.  ", 0.025)
	$modules/bottombars/TextInterfaceEngine.buff_silence(2)
	$modules/bottombars/TextInterfaceEngine.buff_text("Head on back when you can, I got a surprise for you.", 0.025)
	$modules/bottombars/TextInterfaceEngine.buff_silence(5)
	$modules/bottombars/TextInterfaceEngine.buff_clear()
	$modules/bottombars/TextInterfaceEngine.set_state($modules/bottombars/TextInterfaceEngine.STATE_OUTPUT)

	
func rescue2_message():
	$modules/bottombars/TextInterfaceEngine.reset()
	$modules/bottombars/TextInterfaceEngine.set_color(Color(255,255,255))
	$modules/bottombars/TextInterfaceEngine.buff_text("Picking up on a nearby signal!  ", 0.025)
	$modules/bottombars/TextInterfaceEngine.buff_silence(2)
	$modules/bottombars/TextInterfaceEngine.buff_text("Some kind of outdated mil-spec technology.  Probably scavengers.\n\n", 0.025)
	$modules/bottombars/TextInterfaceEngine.buff_silence(2)
	$modules/bottombars/TextInterfaceEngine.buff_text("Careful, these guys would sell their own mothers for credits.  ", 0.025)
	$modules/bottombars/TextInterfaceEngine.buff_silence(2)
	$modules/bottombars/TextInterfaceEngine.buff_text("Find them at (" + String(int(global.rescue2[0]/5)) + ',' + String(int(global.rescue2[1]/5)) + ')', 0.025)
	$modules/bottombars/TextInterfaceEngine.buff_silence(5)
	$modules/bottombars/TextInterfaceEngine.buff_clear()
	$modules/bottombars/TextInterfaceEngine.set_state($modules/bottombars/TextInterfaceEngine.STATE_OUTPUT)


func rescue2_complete():
	$modules/bottombars/TextInterfaceEngine.reset()
	$modules/bottombars/TextInterfaceEngine.set_color(Color(255,255,255))
	$modules/bottombars/TextInterfaceEngine.buff_silence(1)
	$modules/bottombars/TextInterfaceEngine.buff_text("That giant serpent could have swallowed you whole!  ", 0.025)
	$modules/bottombars/TextInterfaceEngine.buff_silence(2)
	$modules/bottombars/TextInterfaceEngine.buff_text("Didn't look like there were any survivors, scans show no signs of life.\n\n", 0.025)
	$modules/bottombars/TextInterfaceEngine.buff_silence(2)
	$modules/bottombars/TextInterfaceEngine.buff_text("We did find some interesting tech that I think we can make work for you.  ", 0.025)
	$modules/bottombars/TextInterfaceEngine.buff_silence(2)
	$modules/bottombars/TextInterfaceEngine.buff_text("Give us some time, we'll have something working for you next time you pull in.", 0.025)
	$modules/bottombars/TextInterfaceEngine.buff_silence(5)
	$modules/bottombars/TextInterfaceEngine.buff_clear()
	$modules/bottombars/TextInterfaceEngine.set_state($modules/bottombars/TextInterfaceEngine.STATE_OUTPUT)


func rescue3_message():
	$modules/bottombars/TextInterfaceEngine.reset()
	$modules/bottombars/TextInterfaceEngine.set_color(Color(255,255,255))
	$modules/bottombars/TextInterfaceEngine.buff_text("Lieutenant, you'll want to check this out I think!  ", 0.025)
	$modules/bottombars/TextInterfaceEngine.buff_silence(2)
	$modules/bottombars/TextInterfaceEngine.buff_text("We are picking up on an energy source well beyond our means.\n\n", 0.025)
	$modules/bottombars/TextInterfaceEngine.buff_silence(2)
	$modules/bottombars/TextInterfaceEngine.buff_text("I hope they are friendly...If we could make them our allies in this fight...", 0.025)
	$modules/bottombars/TextInterfaceEngine.buff_silence(2)
	$modules/bottombars/TextInterfaceEngine.buff_text("Find them at (" + String(int(global.rescue3[0]/5)) + ',' + String(int(global.rescue3[1]/5)) + ')', 0.025)
	$modules/bottombars/TextInterfaceEngine.buff_silence(5)
	$modules/bottombars/TextInterfaceEngine.buff_clear()
	$modules/bottombars/TextInterfaceEngine.set_state($modules/bottombars/TextInterfaceEngine.STATE_OUTPUT)

func rescue3_compete():
	pass


func rescue4_message():
	$modules/bottombars/TextInterfaceEngine.reset()
	$modules/bottombars/TextInterfaceEngine.set_color(Color(255,255,255))
	$modules/bottombars/TextInterfaceEngine.buff_text("Oh great.  The Cluster.  Makes sense they'd be out here too.  ", 0.025)
	$modules/bottombars/TextInterfaceEngine.buff_silence(2)
	$modules/bottombars/TextInterfaceEngine.buff_text("Probably harvesting some poor species for organics.  Those bastards.\n\n", 0.025)
	$modules/bottombars/TextInterfaceEngine.buff_silence(2)
	$modules/bottombars/TextInterfaceEngine.buff_text("I'd steer clear.  Unless you want to become hatchling food", 0.025)
	$modules/bottombars/TextInterfaceEngine.buff_silence(5)
	$modules/bottombars/TextInterfaceEngine.buff_text("...OK, OK, fine.  Find them at (" + String(int(global.rescue4[0]/5)) + ',' + String(int(global.rescue4[1]/5)) + ')', 0.025)
	$modules/bottombars/TextInterfaceEngine.buff_silence(5)
	$modules/bottombars/TextInterfaceEngine.buff_clear()
	$modules/bottombars/TextInterfaceEngine.set_state($modules/bottombars/TextInterfaceEngine.STATE_OUTPUT)
	
func rescue4_complete():
	pass
	
	
func rescue5_message():
	$modules/bottombars/TextInterfaceEngine.reset()
	$modules/bottombars/TextInterfaceEngine.set_color(Color(255,255,255))
	$modules/bottombars/TextInterfaceEngine.buff_text("Uh, LT?  We are getting some crazy readings from your sensor array...", 0.025)
	$modules/bottombars/TextInterfaceEngine.buff_silence(2)
	$modules/bottombars/TextInterfaceEngine.buff_text("Actually more like the absence of readings...everything working alright?\n\n", 0.025)
	$modules/bottombars/TextInterfaceEngine.buff_silence(2)
	$modules/bottombars/TextInterfaceEngine.buff_text("There's something nearby that isn't like anything we've ever seen.  Be careful.  ", 0.025)
	$modules/bottombars/TextInterfaceEngine.buff_silence(2)
	$modules/bottombars/TextInterfaceEngine.buff_text("Find them at (" + String(int(global.rescue5[0]/5)) + ',' + String(int(global.rescue5[1]/5)) + ')', 0.025)
	$modules/bottombars/TextInterfaceEngine.buff_silence(5)
	$modules/bottombars/TextInterfaceEngine.buff_clear()
	$modules/bottombars/TextInterfaceEngine.set_state($modules/bottombars/TextInterfaceEngine.STATE_OUTPUT)
	
func rescue5_complete():
	pass
	
func portal_message():
	$modules/bottombars/TextInterfaceEngine.reset()
	$modules/bottombars/TextInterfaceEngine.set_color(Color(255,255,255))
	$modules/bottombars/TextInterfaceEngine.buff_text("You did it LT!  Gravimetric readings show a tear in space-time up ahead!  ", 0.025)
	$modules/bottombars/TextInterfaceEngine.buff_silence(2)
	$modules/bottombars/TextInterfaceEngine.buff_text("Of course we never planned on what to do next...what kind of power are we facing?\n\n", 0.025)
	$modules/bottombars/TextInterfaceEngine.buff_silence(2)
	$modules/bottombars/TextInterfaceEngine.buff_text("There's only one thing left to do.  You are going to have to go in and stop this madness.  ", 0.025)
	$modules/bottombars/TextInterfaceEngine.buff_silence(2)
	$modules/bottombars/TextInterfaceEngine.buff_text("Good luck lieutenant.  Portal is located at (" + String(int(global.enemy_gate[0]/5)) + ',' + String(int(global.enemy_gate[1]/5)) + ')', 0.025)
	$modules/bottombars/TextInterfaceEngine.buff_silence(5)
	$modules/bottombars/TextInterfaceEngine.buff_clear()
	$modules/bottombars/TextInterfaceEngine.set_state($modules/bottombars/TextInterfaceEngine.STATE_OUTPUT)
	
func cluster_message():
	$modules/bottombars/TextInterfaceEngine.reset()
	$modules/bottombars/TextInterfaceEngine.set_color(Color(255,255,255))
	$modules/bottombars/TextInterfaceEngine.buff_text("I was afraid of this.  Looks like the kind of energy signature only a cluster devourer puts out.  ", 0.025)
	$modules/bottombars/TextInterfaceEngine.buff_silence(2)
	$modules/bottombars/TextInterfaceEngine.buff_text("Strange, there is some large body out there as well that isn't on the charts.\n\n", 0.025)
	$modules/bottombars/TextInterfaceEngine.buff_silence(2)
	$modules/bottombars/TextInterfaceEngine.buff_text("I can't see how a whole planet could suddenly show up in this sector.  ", 0.025)
	$modules/bottombars/TextInterfaceEngine.buff_silence(2)
	$modules/bottombars/TextInterfaceEngine.buff_text("Might be worth checking out.  Go to (" + String(int(global.twinplanet[0]/5)) + ',' + String(int(global.twinplanet[1]/5)) + ')', 0.025)
	$modules/bottombars/TextInterfaceEngine.buff_silence(5)
	$modules/bottombars/TextInterfaceEngine.buff_clear()
	$modules/bottombars/TextInterfaceEngine.set_state($modules/bottombars/TextInterfaceEngine.STATE_OUTPUT)