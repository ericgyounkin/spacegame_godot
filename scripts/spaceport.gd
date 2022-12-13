extends Container


var transitioning = false

var turtleship_description_temp = """\n\nTurtleship

Constructed mainly from the hollowed out shell of a space turtle-monster-thing (no biologists on staff), this is what we of the late era of this war of wars call a 'vessel of opportunity'.  In that we 'commandeered' it from it's original 'owner' for war.  

Most of the original organism was put to use, the fins even work, after a sort.  Of course, we have plenty of propulsion tech available, so you shouldn't need those.  The carapace is nearly indestructible, so try to keep it between you and the enemy.  

The smell is unbearable inside, which we market as 'boarding defense'.  We'll give you a discount of course.

Base Values

Shield:%s
Hull:%s
Turn Rate:%s
Acceleration:%s"""
var turtleship_description = turtleship_description_temp % [global.turtleship_shield, global.turtleship_hull, global.turtleship_rot_speed, global.turtleship_thrust]
var turtleship_img = load('res://art/ships/turtleship2.png')

var constructo_description_temp = """\n\nConstructo

We had these fleet guys on board once, long time ago, doing some routine maintenance.  Panels, structural stuff.  Happened to leave behind a perfectly good loader.  Now if you haven't figured it out yet, we are kinda low on structural stuff.  Kinda at the improvising stage.

Well, one of our guys got the idea in their head from watching some old earth movie, 'Aliens' or something, that this thing could deck an alien right in the schnoz, if we powered it up enough.  Put some basic thrusters on it and all.  Does it work?  You be the judge.

One thing I will tell you, maneuverability is not its strong suit.

Base Values

Shield:%s
Hull:%s
Turn Rate:%s
Acceleration:%s"""
var constructo_description = constructo_description_temp % [global.constructo_shield, global.constructo_hull, global.constructo_rot_speed, global.constructo_thrust]
var constructo_img = load('res://art/ships/constructobot.png')

var pinnace_description_temp = """\n\nPinnace

Fleet lost the ability to mass produce the battleships of old a long time ago.  Hell, we couldn't even crew one if we had one available.  What they have done is built some really nice light scouts like your pinnace here.

You won't have the hardpoints of one of our larger ships, but it excels at 'engage bravely, but reserve the ability to run screaming'.  I've seen a lot of fresh cadets head starward and not come back.  You look like you might value survival more than most.

You came here on this beauty, so she's yours of course.  Let me know if you want to add some weapons, extra modules, or some flames or something.  I won't judge.

Base Values

Shield:%s
Hull:%s
Turn Rate:%s
Acceleration:%s"""
var pinnace_description = pinnace_description_temp % [global.pinnace_shield, global.pinnace_hull, global.pinnace_rot_speed, global.pinnace_thrust]
var pinnace_img = load('res://art/ships/pinnace.png')

var shiplist = [['turtleship', turtleship_description, turtleship_img, global.turtleship_price], 
				['constructo', constructo_description, constructo_img, global.constructo_price], 
				['pinnace', pinnace_description, pinnace_img, global.pinnace_price]]
var indx = 0
var mode = 'buy'
var equipped = []
var freeequip = []
var thrust_increment = 15
var thrust_price = 250
var rotspeed_increment = .01
var rotspeed_price = 200
var hull_increment = 100
var	hull_price = 250
var shield_increment = 50
var shield_price = 300
		

func load_from_shiplist(i):
	$HBoxContainer/menu/buy_screen/description.text = shiplist[i][1]
	$HBoxContainer/shipimg.texture = shiplist[i][2]

func _ready():
	$HBoxContainer/menu/depart_screen/credits.text = 'Credits: ' + str(global.player_credits)
	if global.gamestate == 2:
		_on_return_pressed()
	load_from_shiplist(indx)
	_on_loadout_pressed()

func return_ship_selected():
	var shipindx = $HBoxContainer/menu/loadout_screen/shipcont/shipbutton.selected
	var ship = $HBoxContainer/menu/loadout_screen/shipcont/shipbutton.get_item_text(shipindx)
	if global.owned_ships:
		for sh in global.owned_ships:
			if sh['name'] == ship:
				return sh
	return null

func initialize_loadout_gui():
	$HBoxContainer/menu/loadout_screen/shipcont/shipbutton.clear()
	if global.owned_ships:
		for sh in global.owned_ships:
			$HBoxContainer/menu/loadout_screen/shipcont/shipbutton.add_item(sh['name'])
		load_ship(global.owned_ships[0])
	
func load_ship(sh):
	equipped = {}
	freeequip = global.inventory
	var ks = sh.keys()
	for li in shiplist:
		if li[0] == sh['name']:
			$HBoxContainer/shipimg.texture = li[2]
	if 'lmb' in ks:
		$HBoxContainer/menu/loadout_screen/weaponlmb.visible = true
		$HBoxContainer/menu/loadout_screen/lmbcont.visible = true
		$HBoxContainer/menu/loadout_screen/lmbcont/lmbbutton.clear()
		if sh['lmb']:
			$HBoxContainer/menu/loadout_screen/lmbcont/lmbbutton.add_item(sh['lmb'])			
	else:
		$HBoxContainer/menu/loadout_screen/weaponlmb.visible = false
		$HBoxContainer/menu/loadout_screen/lmbcont.visible = false
	
	if 'rmb' in ks:
		$HBoxContainer/menu/loadout_screen/weaponrmb.visible = true
		$HBoxContainer/menu/loadout_screen/rmbcont.visible = true
		$HBoxContainer/menu/loadout_screen/rmbcont/rmbbutton.clear()
		if sh['rmb']:
			$HBoxContainer/menu/loadout_screen/rmbcont/rmbbutton.add_item(sh['rmb'])
	else:
		$HBoxContainer/menu/loadout_screen/weaponrmb.visible = false
		$HBoxContainer/menu/loadout_screen/rmbcont.visible = false
	
	if 'wpn1' in ks:
		$HBoxContainer/menu/loadout_screen/slot1.visible = true
		$HBoxContainer/menu/loadout_screen/slot1.text = sh['wpn1_opts'][0]
		$HBoxContainer/menu/loadout_screen/slot1cont.visible = true
		if sh['wpn1']:
			$HBoxContainer/menu/loadout_screen/slot1cont/slot1button.text = sh['wpn1']
		else:
			$HBoxContainer/menu/loadout_screen/slot1cont/slot1button.clear()
	else:
		$HBoxContainer/menu/loadout_screen/slot1.visible = false
		$HBoxContainer/menu/loadout_screen/slot1cont.visible = false
		
	if 'wpn2' in ks:
		$HBoxContainer/menu/loadout_screen/slot2.visible = true
		$HBoxContainer/menu/loadout_screen/slot2.text = sh['wpn2_opts'][0]
		$HBoxContainer/menu/loadout_screen/slot2cont.visible = true
		if sh['wpn2']:
			$HBoxContainer/menu/loadout_screen/slot2cont/slot2button.text = sh['wpn2']
		else:
			$HBoxContainer/menu/loadout_screen/slot2cont/slot2button.clear()
	else:
		$HBoxContainer/menu/loadout_screen/slot2.visible = false
		$HBoxContainer/menu/loadout_screen/slot2cont.visible = false
		
	if 'wpn3' in ks:
		$HBoxContainer/menu/loadout_screen/slot3.visible = true
		$HBoxContainer/menu/loadout_screen/slot3.text = sh['wpn3_opts'][0]
		$HBoxContainer/menu/loadout_screen/slot3cont.visible = true
		if sh['wpn3']:
			$HBoxContainer/menu/loadout_screen/slot3cont/slot3button.text = sh['wpn3']
		else:
			$HBoxContainer/menu/loadout_screen/slot3cont/slot3button.clear()
	else:
		$HBoxContainer/menu/loadout_screen/slot3.visible = false
		$HBoxContainer/menu/loadout_screen/slot3cont.visible = false
		
	if 'wpn4' in ks:
		$HBoxContainer/menu/loadout_screen/slot4.visible = true
		$HBoxContainer/menu/loadout_screen/slot4.text = sh['wpn4_opts'][0]
		$HBoxContainer/menu/loadout_screen/slot4cont.visible = true
		if sh['wpn4']:
			$HBoxContainer/menu/loadout_screen/slot4cont/slot4button.text = sh['wpn4']
		else:
			$HBoxContainer/menu/loadout_screen/slot4cont/slot4button.clear()
	else:
		$HBoxContainer/menu/loadout_screen/slot4.visible = false
		$HBoxContainer/menu/loadout_screen/slot4cont.visible = false
		
	if 'wpn5' in ks:
		$HBoxContainer/menu/loadout_screen/slot5.visible = true
		$HBoxContainer/menu/loadout_screen/slot5.text = sh['wpn5_opts'][0]
		$HBoxContainer/menu/loadout_screen/slot5cont.visible = true
		if sh['wpn5']:
			$HBoxContainer/menu/loadout_screen/slot5cont/slot5button.text = sh['wpn5']
		else:
			$HBoxContainer/menu/loadout_screen/slot5cont/slot5button.clear()
	else:
		$HBoxContainer/menu/loadout_screen/slot5.visible = false
		$HBoxContainer/menu/loadout_screen/slot5cont.visible = false
	update_ship_upgrades()
	
	
func update_ship_upgrades():
	var sh = return_ship_selected()
	$CanvasLayer/upgrades/thrustupgrade/curvalue.text = 'thrust: ' + str(sh['thrust'])
	$CanvasLayer/upgrades/thrustupgrade/cost.text = 'cost: ' + str(calculate_upgrade_cost('thrust', sh['thrust']))
	$CanvasLayer/upgrades/rotationupgrade/curvalue.text = 'rotation: ' + str(sh['rot_speed'])
	$CanvasLayer/upgrades/rotationupgrade/cost.text = 'cost: ' + str(calculate_upgrade_cost('rot_speed', sh['rot_speed']))
	$CanvasLayer/upgrades/hullupgrade/curvalue.text = 'hull: ' + str(sh['maxhull'])
	$CanvasLayer/upgrades/hullupgrade/cost.text = 'cost: ' + str(calculate_upgrade_cost('hull', sh['maxhull']))
	$CanvasLayer/upgrades/shieldupgrade/curvalue.text = 'shield: ' + str(sh['maxshield'])
	$CanvasLayer/upgrades/shieldupgrade/cost.text = 'cost: ' + str(calculate_upgrade_cost('shield', sh['maxshield']))
	

func calculate_upgrade_cost(mode, curval):
	var classval = 0
	var cost = 0
	var increment
	var price
	if mode == 'thrust':
		increment = thrust_increment
		price = thrust_price
	elif mode == 'rot_speed':
		increment = rotspeed_increment
		price = rotspeed_price
	elif mode == 'hull':
		increment = hull_increment
		price = hull_price
	elif mode == 'shield':
		increment = shield_increment
		price = shield_price
	classval = global.get(global.playership + '_' + mode)
	cost = ((curval - classval) / increment) * price
	if cost == 0:
		return price
	else:
		return cost
		
	
func handle_screen_changes(mode):
	if mode == 'buy' or mode == 'sell':
		$CanvasLayer/upgrades.hide()
		$HBoxContainer/menu/loadout_screen.visible = false
		$HBoxContainer/menu/buy_screen.visible = true
	elif mode == 'loadout':
		$CanvasLayer/upgrades.show()
		$HBoxContainer/menu/buy_screen.visible = false
		$HBoxContainer/menu/loadout_screen.visible = true
		
		
func save_loadout():
	var sh = return_ship_selected()
	global.playership = $HBoxContainer/menu/loadout_screen/shipcont/shipbutton.text
	global.maxhull = sh['maxhull']
	global.hull = sh['maxhull']
	global.maxshield = sh['maxshield']
	global.shield = sh['maxshield']
	global.rot_speed = sh['rot_speed']
	global.thrust = sh['thrust']
	global.max_vel = sh['thrust'] * 1.5
	global.max_sight = global.get(global.playership + '_max_sight')
	
	if $HBoxContainer/menu/loadout_screen/lmbcont.visible:
		global.wpnlmb = $HBoxContainer/menu/loadout_screen/lmbcont/lmbbutton.text
		global.wpnlmb_grouped = $HBoxContainer/menu/loadout_screen/lmbcont/grouplmb.is_pressed()
	else:
		global.wpnlmb = ''
		global.wpnlmb_grouped = false
	if $HBoxContainer/menu/loadout_screen/rmbcont.visible:
		global.wpnrmb = $HBoxContainer/menu/loadout_screen/rmbcont/rmbbutton.text
		global.wpnrmb_grouped = $HBoxContainer/menu/loadout_screen/rmbcont/grouprmb.is_pressed()
	else:
		global.wpnrmb = ''
		global.wpnrmb_grouped = false
	if $HBoxContainer/menu/loadout_screen/slot1cont.visible and $HBoxContainer/menu/loadout_screen/slot1cont/slot1button.text != '-empty':
		global.wpn1 = $HBoxContainer/menu/loadout_screen/slot1cont/slot1button.text
		global.wpn1_grouped = $HBoxContainer/menu/loadout_screen/slot1cont/groupslot1.is_pressed()
		sh['wpn1'] = global.wpn1
	else:
		global.wpn1 = ''
		global.wpn1_grouped = false
	if $HBoxContainer/menu/loadout_screen/slot2cont.visible and $HBoxContainer/menu/loadout_screen/slot2cont/slot2button.text != '-empty':
		global.wpn2 = $HBoxContainer/menu/loadout_screen/slot2cont/slot2button.text
		global.wpn2_grouped = $HBoxContainer/menu/loadout_screen/slot2cont/groupslot2.is_pressed()
		sh['wpn2'] = global.wpn2
	else:
		global.wpn2 = ''
		global.wpn2_grouped = false
	if $HBoxContainer/menu/loadout_screen/slot3cont.visible and $HBoxContainer/menu/loadout_screen/slot3cont/slot3button.text != '-empty':
		global.wpn3 = $HBoxContainer/menu/loadout_screen/slot3cont/slot3button.text
		global.wpn3_grouped = $HBoxContainer/menu/loadout_screen/slot3cont/groupslot3.is_pressed()
		sh['wpn3'] = global.wpn3
	else:
		global.wpn3 = ''
		global.wpn3_grouped = false
	if $HBoxContainer/menu/loadout_screen/slot4cont.visible and $HBoxContainer/menu/loadout_screen/slot4cont/slot4button.text != '-empty':
		global.wpn4 = $HBoxContainer/menu/loadout_screen/slot4cont/slot4button.text
		global.wpn4_grouped = $HBoxContainer/menu/loadout_screen/slot4cont/groupslot4.is_pressed()
		sh['wpn4'] = global.wpn4
	else:	
		global.wpn4 = ''
		global.wpn4_grouped = false
	if $HBoxContainer/menu/loadout_screen/slot5cont.visible and $HBoxContainer/menu/loadout_screen/slot5cont/slot5button.text != '-empty':
		global.wpn5 = $HBoxContainer/menu/loadout_screen/slot5cont/slot5button.text
		global.wpn5_grouped = $HBoxContainer/menu/loadout_screen/slot5cont/groupslot5.is_pressed()
		sh['wpn5'] = global.wpn5
	else:
		global.wpn5 = ''
		global.wpn5_grouped = false
	
	if global.owned_ships:
		for ship in global.owned_ships:
			if ship['name'] == sh['name']:
				ship = sh
	
	print($HBoxContainer/menu/loadout_screen/slot2cont.visible)
	print($HBoxContainer/menu/loadout_screen/slot2cont/slot2button.text != '-empty')
	
	print(global.wpnlmb, global.wpnlmb_grouped)
	print(global.wpnrmb, global.wpnrmb_grouped)
	print(global.wpn1, global.wpn1_grouped)
	print(global.wpn2, global.wpn2_grouped)
	print(global.wpn3, global.wpn3_grouped)
	print(global.wpn4, global.wpn4_grouped)
	print(global.wpn5, global.wpn5_grouped)
	

func purchase_ship(shipname):
	var cost = shiplist[indx][3]
	if cost <= global.player_credits:
		global.player_credits -= cost
		var new_ship = {'name': shipname, 'maxhull': global.get(shipname + '_maxhull'), 'maxshield': global.get(shipname + '_maxshield'),
					 'rot_speed': global.get(shipname + '_rot_speed'), 'thrust': global.get(shipname + '_thrust'),
					 'max_vel': global.get(shipname + '_max_vel'),  'max_sight': global.get(shipname + '_max_sight'), 
					 'lmb': global.get(shipname + '_lmb')}
		if global.get(shipname + '_rmb'):
			new_ship['rmb'] = global.get(shipname + '_rmb')
		if global.get(shipname + '_wpn1'):
			new_ship['wpn1'] = ''
			new_ship['wpn1_opts'] = global.get(shipname + '_wpn1')
		if global.get(shipname + '_wpn2'):
			new_ship['wpn2'] = ''
			new_ship['wpn2_opts'] = global.get(shipname + '_wpn2')
		if global.get(shipname + '_wpn3'):
			new_ship['wpn3'] = ''
			new_ship['wpn3_opts'] = global.get(shipname + '_wpn3')
		if global.get(shipname + '_wpn4'):
			new_ship['wpn4'] = ''
			new_ship['wpn4_opts'] = global.get(shipname + '_wpn4')
		if global.get(shipname + '_wpn5'):
			new_ship['wpn5'] = ''
			new_ship['wpn5_opts'] = global.get(shipname + '_wpn5')
		global.owned_ships.append(new_ship)
		$HBoxContainer/menu/depart_screen/credits.text = 'Credits: ' + str(global.player_credits)

func sell_ship(shipname):
	var cost = shiplist[indx][3]
	for sh in global.owned_ships:
		if sh['name'] == shipname:
			global.owned_ships.remove(sh)
			global.player_credits -= cost
			$HBoxContainer/menu/depart_screen/credits.text = 'Credits: ' + str(global.player_credits)

func transition_zoomed():
	if not transitioning:
		transitioning = true
		$transition_timer.start()
		transition.fade_to("res://scenes/zoomed_out_battle.tscn")
		music_manager.playtrack('zoomedbattle')
		get_tree().paused = true

func btnpress(btn, lbl):
	var currselect = btn.text
	var select_label = lbl.text
	if currselect != '-empty-' and currselect != '' and (currselect in freeequip.keys()):
		var itemref = global.itemlist_lookup[currselect]
		if !(global.itemlist[itemref][5] in ['missle', 'misslespecial']):
			freeequip[currselect] += 1
			if currselect in equipped.keys():
				equipped[currselect] -= 1
			else:
				equipped[currselect] = 0
	btn.clear()
	btn.add_item('-empty-')
	for item in freeequip:
		if item:
			if select_label == 'Auxiliary':
				if global.itemlist[global.itemlist_lookup[item]][5] == 'auxiliary':
					btn.add_item(item)
			else:
				if global.itemlist[global.itemlist_lookup[item]][5] != 'auxiliary':
					btn.add_item(item)

func btnselect(btn, ID):
	var selected = btn.text
	if selected != '-empty-' and selected != '':
		var itemref = global.itemlist_lookup[selected]
		if !(global.itemlist[itemref][5] in ['missle', 'misslespecial']):
			freeequip[selected] -= 1
			if selected in equipped.keys():
				equipped[selected] += 1
			else:
				equipped[selected] = 1

func _on_buy_pressed():
	mode = 'buy'
	handle_screen_changes(mode)
	load_from_shiplist(indx)
	$HBoxContainer/menu/buy_screen/arrows/buysell.text = 'Purchase for ' + str(shiplist[indx][3])

func _on_sell_pressed():
	mode = 'sell'
	handle_screen_changes(mode)
	for ship in shiplist:
		for ownedship in global.owned_ships:
			if ship[0] in ownedship.values():
				load_from_shiplist(shiplist.find(ship))
				$HBoxContainer/menu/buy_screen/arrows/buysell.text = 'Sell for ' + str(ship[3])

func _on_loadout_pressed():
	mode = 'loadout'
	handle_screen_changes(mode)
	initialize_loadout_gui()

func _on_left_arrow_pressed():
	if mode == 'buy':
		if indx > 0:
			indx -= 1
			load_from_shiplist(indx)
			$HBoxContainer/menu/buy_screen/arrows/buysell.text = 'Purchase for ' + str(shiplist[indx][3])
	elif mode == 'sell':
		if indx > 0:
			indx -= 1
			for ownedship in global.owned_ships:
				if shiplist[indx][0] in ownedship.values():
					load_from_shiplist(indx)
					$HBoxContainer/menu/buy_screen/arrows/buysell.text = 'Sell for ' + str(shiplist[indx][3])
		
func _on_right_arrow_pressed():
	if mode == 'buy':
		if indx < len(shiplist)-1:
			indx += 1
			load_from_shiplist(indx)
			$HBoxContainer/menu/buy_screen/arrows/buysell.text = 'Purchase for ' + str(shiplist[indx][3])
	elif mode == 'sell':
		if indx < len(shiplist)-1:
			indx += 1
			for ownedship in global.owned_ships:
				if shiplist[indx][0] in ownedship.values():
					load_from_shiplist(indx)
					$HBoxContainer/menu/buy_screen/arrows/buysell.text = 'Sell for ' + str(shiplist[indx][3])

func _on_return_pressed():
	if global.gamestate != 1:
		global.goto_scene("res://scenes/station/station.tscn")

func _on_leave_pressed():
	save_loadout()
	transition_zoomed()
		
func _on_transition_timer_timeout():
	get_tree().paused = false

func _on_shipbutton_item_selected(ID):
	load_ship(global.owned_ships[ID])

func _on_slot1button_pressed():
	btnpress($HBoxContainer/menu/loadout_screen/slot1cont/slot1button, $HBoxContainer/menu/loadout_screen/slot1)

func _on_slot1button_item_selected(ID):
	btnselect($HBoxContainer/menu/loadout_screen/slot1cont/slot1button, ID)

func _on_slot2button_pressed():
	btnpress($HBoxContainer/menu/loadout_screen/slot2cont/slot2button, $HBoxContainer/menu/loadout_screen/slot2)

func _on_slot2button_item_selected(ID):
	btnselect($HBoxContainer/menu/loadout_screen/slot2cont/slot2button, ID)

func _on_slot3button_pressed():
	btnpress($HBoxContainer/menu/loadout_screen/slot3cont/slot3button, $HBoxContainer/menu/loadout_screen/slot3)

func _on_slot3button_item_selected(ID):
	btnselect($HBoxContainer/menu/loadout_screen/slot3cont/slot3button, ID)

func _on_slot4button_pressed():
	btnpress($HBoxContainer/menu/loadout_screen/slot4cont/slot4button, $HBoxContainer/menu/loadout_screen/slot4)

func _on_slot4button_item_selected(ID):
	btnselect($HBoxContainer/menu/loadout_screen/slot4cont/slot4button, ID)

func _on_slot5button_pressed():
	btnpress($HBoxContainer/menu/loadout_screen/slot5cont/slot5button, $HBoxContainer/menu/loadout_screen/slot5)

func _on_slot5button_item_selected(ID):
	btnselect($HBoxContainer/menu/loadout_screen/slot5cont/slot5button, ID)

func _on_buysell_pressed():
	var shipname = shiplist[indx][0]
	if mode == 'buy':
		# check to see if you have it already
		for sh in global.owned_ships:
			if sh['name'] == shipname:
				return
		# otherwise buy it
		purchase_ship(shipname)
	elif mode == 'sell':
		if shipname in global.owned_ships:
			sell_ship(shipname)
			
func _on_thrustbutton_pressed():
	var sh = return_ship_selected()
	var price = calculate_upgrade_cost('thrust', sh['thrust'])
	if global.player_credits >= price:
		sh['thrust'] = sh['thrust'] + thrust_increment
		global.player_credits = global.player_credits - price
		update_ship_upgrades()
		$HBoxContainer/menu/depart_screen/credits.text = 'Credits: ' + str(global.player_credits)
	
func _on_rotationbutton_pressed():
	var sh = return_ship_selected()
	var price = calculate_upgrade_cost('rot_speed', sh['rot_speed'])
	if global.player_credits >= price:
		sh['rot_speed'] = sh['rot_speed'] + rotspeed_increment
		global.player_credits = global.player_credits - price
		update_ship_upgrades()
		$HBoxContainer/menu/depart_screen/credits.text = 'Credits: ' + str(global.player_credits)


func _on_hullbutton_pressed():
	var sh = return_ship_selected()
	var price = calculate_upgrade_cost('hull', sh['maxhull'])
	if global.player_credits >= price:
		sh['maxhull'] = sh['maxhull'] + hull_increment
		global.player_credits = global.player_credits - price
		update_ship_upgrades()
		$HBoxContainer/menu/depart_screen/credits.text = 'Credits: ' + str(global.player_credits)


func _on_shieldbutton_pressed():
	var sh = return_ship_selected()
	var price = calculate_upgrade_cost('shield', sh['maxshield'])
	if global.player_credits >= price:
		sh['maxshield'] = sh['maxshield'] + shield_increment
		global.player_credits = global.player_credits - price
		update_ship_upgrades()
		$HBoxContainer/menu/depart_screen/credits.text = 'Credits: ' + str(global.player_credits)
