extends Node

var quant_indexes = []
var quant_sold = []
var intro = true

func _ready():
	if global.gamestate == 0:  #intro
		$engineer1.visible = true
		$engineer2.visible = true
		$scientist.visible = true
	$bground/buybutton.add_color_override('font_color', Color(67,70,103))
	$bground/buybutton.add_color_override('font_color_hover', Color(255,0,0))
	$bground2/addbutton.add_color_override('font_color', Color(67,70,103))
	$bground2/addbutton.add_color_override('font_color_hover', Color(255,0,0))
	$bground2/removebutton.add_color_override('font_color', Color(67,70,103))
	$bground2/removebutton.add_color_override('font_color_hover', Color(255,0,0))
	$bground2/confirmbutton.add_color_override('font_color', Color(67,70,103))
	$bground2/confirmbutton.add_color_override('font_color_hover', Color(255,0,0))
	#music_manager.playtrack('station')

func shopintro():
	intro = true
	if $bground.visible == false:
		$bground.visible = true
		$bground/shopbackground/shoptext.reset()
		$bground/shopbackground/shoptext.set_color(Color(0,0,0))
		$bground/shopbackground/shoptext.buff_text('Yeah, whaddya want?\n', 0.025)
		$bground/shopbackground/shoptext.buff_silence(.025)
		$bground/shopbackground/shoptext.set_state($bground/shopbackground/shoptext.STATE_OUTPUT)

func captainintro():
	if $bground3.visible == false:
		$bground3.visible = true
		$bground3/captainbackground/captaintext.reset()
		$bground3/captainbackground/captaintext.set_color(Color(0,0,0))
		$bground3/captainbackground/captaintext.buff_text("Hey there lieutenant, what's shaking?\n", 0.025)
		$bground3/captainbackground/captaintext.buff_silence(.025)
		$bground3/captainbackground/captaintext.set_state($bground/shopbackground/shoptext.STATE_OUTPUT)
		
func captaincutscene1():
	var sched = []
	if $bground3.visible == false:
		$bground3.visible = true
		$bground3/captainbackground/captaintext.reset()
		$bground3/captainbackground/captaintext.set_color(Color(0,0,0))
		$bground3/captainbackground/captaintext.buff_text("Hello there lieutenant.  Welcome to Manticore station.  Captain Davis, at your service.\n\n", 0.025)
		$bground3/captainbackground/captaintext.buff_silence(1)
		$bground3/captainbackground/captaintext.buff_text("I'm judging from your expression that maybe this wasn't your first choice of assignment?\n\n", 0.025)
		$bground3/captainbackground/captaintext.buff_silence(2)
		$bground3/captainbackground/captaintext.buff_clear()
		$bground3/captainbackground/captaintext.buff_text("Well, get used to it.  You're at the edge of the system, about as far from civilization as you can get.\n\n", 0.025)
		$bground3/captainbackground/captaintext.buff_silence(1)
		$bground3/captainbackground/captaintext.buff_text("And equally far from anything interesting.  Been years since we saw any action, it's like those damn things got bored with us.\n\n", 0.025)
		$bground3/captainbackground/captaintext.buff_silence(2)
		$bground3/captainbackground/captaintext.buff_clear()
		$bground3/captainbackground/captaintext.buff_text("You're going to have to figure out how to stay sane out here.  Take up a hobby.  Knitting maybe.\n\n", 0.025)
		$bground3/captainbackground/captaintext.buff_silence(1)
		$bground3/captainbackground/captaintext.buff_text("Otherwise you'll lose it.\n\n", 0.025)
		$bground3/captainbackground/captaintext.buff_silence(2)
		$bground3/captainbackground/captaintext.buff_clear()
		$bground3/captainbackground/captaintext.buff_text("Anyway, you'll get the usual admin tasks.  Drills on Tuesday, movie night on Thursday, blah blah blah.\n\n", 0.025)
		$bground3/captainbackground/captaintext.buff_silence(1)
		$bground3/captainbackground/captaintext.buff_text("Make your self at home.  You can take SR-1.  Just five of us total, skeleton crew.  Get squared away and we can talk more later.\n\n", 0.025)
		$bground3/captainbackground/captaintext.buff_silence(2)
		$bground3/captainbackground/captaintext.buff_clear()
		$bground3/captainbackground/captaintext.set_state($bground/shopbackground/shoptext.STATE_OUTPUT)

func captaincutscene2():
	if $bground3.visible == false:
		$bground3.visible = true
		$bground3/captainbackground/captaintext.reset()
		$bground3/captainbackground/captaintext.set_color(Color(0,0,0))
		$bground3/captainbackground/captaintext.buff_text("You hear that?\n\n", 0.025)
		$bground3/captainbackground/captaintext.buff_silence(3)
		$bground3/captainbackground/captaintext.buff_clear()
		$bground3/captainbackground/captaintext.set_state($bground/shopbackground/shoptext.STATE_OUTPUT)

func captaincutscene3():
	if $bground3.visible == false:
		$bground3.visible = true
		$bground3/captainbackground/captaintext.reset()
		$bground3/captainbackground/captaintext.set_color(Color(0,0,0))
		$bground3/captainbackground/captaintext.buff_text("Shit!\n\n", 0.025)
		$bground3/captainbackground/captaintext.buff_silence(1)
		$bground3/captainbackground/captaintext.buff_text("Engineering!  Status report!\n\n", 0.025)
		$bground3/captainbackground/captaintext.buff_silence(1)
		$bground3/captainbackground/captaintext.buff_text("Section 8...gone? Impossible!  ...How many?\n\n", 0.025)
		$bground3/captainbackground/captaintext.buff_silence(3)
		$bground3/captainbackground/captaintext.buff_clear()
		$bground3/captainbackground/captaintext.buff_text("How'd they get past LRS?  ...disabled for power...christmas lights?!  Are you out of your mind?!\n\n", 0.025)
		$bground3/captainbackground/captaintext.buff_silence(1)
		$bground3/captainbackground/captaintext.buff_text("Bridge ready launch bay 1.  OK LT, you are up.  Let's see how that shuttle you showed up in does in combat.\n\n", 0.025)
		$bground3/captainbackground/captaintext.buff_silence(1)
		$bground3/captainbackground/captaintext.buff_text("Head straight up to the spaceport, now!\n\n", 0.025)
		$bground3/captainbackground/captaintext.buff_silence(3)
		$bground3/captainbackground/captaintext.set_state($bground/shopbackground/shoptext.STATE_OUTPUT)

func captaincutscene4():
	if $bground3.visible == false:
		$bground3.visible = true
		$bground3/captainbackground/captaintext.reset()
		$bground3/captainbackground/captaintext.set_color(Color(0,0,0))
		$bground3/captainbackground/captaintext.buff_text("So. They are back.  After all this time.\n\n", 0.025)
		$bground3/captainbackground/captaintext.buff_silence(2)
		$bground3/captainbackground/captaintext.buff_text("We've got work to do lieutenant.  And precious little time.\n\n", 0.025)
		$bground3/captainbackground/captaintext.buff_silence(1)
		$bground3/captainbackground/captaintext.buff_text("I've got one hell of a report to file.  We've got damage to patch up in some berthing areas.  And you...\n\n", 0.025)
		$bground3/captainbackground/captaintext.buff_silence(3)
		$bground3/captainbackground/captaintext.buff_clear()
		$bground3/captainbackground/captaintext.buff_text("The original purpose of this station was to serve as an outpost, to determine the origin of these strange beings.\n\n", 0.025)
		$bground3/captainbackground/captaintext.buff_silence(1)
		$bground3/captainbackground/captaintext.buff_text("That's now your mission.  How are they getting here?  Why this sector?  I need you to go out there and find the source.\n\n", 0.025)
		$bground3/captainbackground/captaintext.buff_silence(1)
		$bground3/captainbackground/captaintext.buff_text("Dismissed.  Good luck out there.", 0.025)
		$bground3/captainbackground/captaintext.buff_silence(3)
		$bground3/captainbackground/captaintext.set_state($bground/shopbackground/shoptext.STATE_OUTPUT)

func explosion():
	$redalert.visible = true
	$AnimationPlayer.play('stationexplosion')

func flavortext(msg1, msg2):
	$bground/shopbackground/shoptext.reset()
	$bground/shopbackground/shoptext.set_color(Color(0,0,0))
	$bground/shopbackground/shoptext.buff_text(msg1, 0.025)
	$bground/shopbackground/shoptext.buff_silence(0.25)
	$bground/shopbackground/shoptext.buff_text(msg2, 0.025)
	$bground/shopbackground/shoptext.buff_silence(0.25)
	$bground/shopbackground/shoptext.set_state($bground/shopbackground/shoptext.STATE_OUTPUT)

func closeshop(endmode=''):
	$bground2.visible = false
	$bground2/addbutton.visible = false
	$bground2/removebutton.visible = false
	$bground2/confirmbutton.visible = false
	if endmode == 'bought':
		$bground.visible = true
		$bground/buybutton.visible = false
		$bground/shopbackground/shoptext.reset()
		$bground/shopbackground/shoptext.set_color(Color(0,0,0))
		$bground/shopbackground/shoptext.buff_text('Have fun with your new toys.\n', 0.025)
		$bground/shopbackground/shoptext.buff_silence(.025)
		$bground/shopbackground/shoptext.set_state($bground/shopbackground/shoptext.STATE_OUTPUT)
	else:
		$bground.visible = false
		$bground/buybutton.visible = false

func closecaptaintext():
	$bground3.visible = false

func _on_shoptext_buff_end():
	if intro:
		$bground/buybutton.visible = true
		intro = false

func _on_buybutton_pressed():
	$bground2.visible = true
	$bground/buybutton.visible = false
	$bground2/addbutton.visible = true
	$bground2/removebutton.visible = true
	$bground2/confirmbutton.visible = true
	initialize_credits()
	initialize_shop_inventory()

func initialize_credits():
	$bground2/shopmenubground/cash.text = 'Credits: ' + str(global.player_credits)

func initialize_shop_inventory():
	$bground2/shopmenubground/ScrollContainer/VBoxContainer/ItemList.clear()
	for h in ['name', 'cost', 'owned']:
		$bground2/shopmenubground/ScrollContainer/VBoxContainer/ItemList.add_item(h)
	for h in ['---------------', '', '']:
		$bground2/shopmenubground/ScrollContainer/VBoxContainer/ItemList.add_item(h)
	for h in ['short range', '', '']:
		$bground2/shopmenubground/ScrollContainer/VBoxContainer/ItemList.add_item(h)
	for h in ['---------------', '', '']:
		$bground2/shopmenubground/ScrollContainer/VBoxContainer/ItemList.add_item(h)
	for it in global.itemlist:
		if str(global.itemlist[it][6]) == 'close':
			$bground2/shopmenubground/ScrollContainer/VBoxContainer/ItemList.add_item(str(global.itemlist[it][4]))
			$bground2/shopmenubground/ScrollContainer/VBoxContainer/ItemList.add_item(str(global.itemlist[it][0]))
			if str(global.itemlist[it][4]) in global.inventory.keys():
				$bground2/shopmenubground/ScrollContainer/VBoxContainer/ItemList.add_item(str(global.inventory[global.itemlist[it][4]]))
			else:
				$bground2/shopmenubground/ScrollContainer/VBoxContainer/ItemList.add_item('0')
	for h in ['---------------', '', '']:
		$bground2/shopmenubground/ScrollContainer/VBoxContainer/ItemList.add_item(h)
	for h in ['long range', '', '']:
		$bground2/shopmenubground/ScrollContainer/VBoxContainer/ItemList.add_item(h)
	for h in ['---------------', '', '']:
		$bground2/shopmenubground/ScrollContainer/VBoxContainer/ItemList.add_item(h)
	for it in global.itemlist:
		if str(global.itemlist[it][6]) == 'longrange':
			$bground2/shopmenubground/ScrollContainer/VBoxContainer/ItemList.add_item(str(global.itemlist[it][4]))
			$bground2/shopmenubground/ScrollContainer/VBoxContainer/ItemList.add_item(str(global.itemlist[it][0]))
			if str(global.itemlist[it][4]) in global.inventory.keys():
				$bground2/shopmenubground/ScrollContainer/VBoxContainer/ItemList.add_item(str(global.inventory[it]))
			else:
				$bground2/shopmenubground/ScrollContainer/VBoxContainer/ItemList.add_item('0')

func _on_ItemList_item_selected(index):
	var itm = $bground2/shopmenubground/ScrollContainer/VBoxContainer/ItemList.get_item_text(index)
	if itm == 'standard torpedo':
		flavortext('Simple dumb-fire missle weapon.\n', "Doesn't pack the biggest punch and hard to hit with, but we can crank these babies out pretty fast.\n")
	elif itm == 'homing torpedo':
		flavortext("Same warhead as the basic torpedo, but this one can seek and destroy.\n", "Or at least try to, we can only really afford the discounted guidance chips.\n")
	elif itm == 'torpedo swarm':
		flavortext("Why fire one when you can fire ten?\n", "Just try not to turn and fire too quickly, the array has to be rear mounted...\n")
	elif itm == 'blue laser':
		flavortext("Your basic laser weapon, probably the same tech you used in the academy.\n", "You break one of these, I got a hundred more to replace it with.\n")
	elif itm == 'red beam':
		flavortext("You know how hard it is to deal with overheating weapons in space?\n", "Neither do I, hopefully the guys who built this overpowered beam weapon do.\n")
	elif itm == 'acid thrower':
		flavortext("This one is of my design!\n", "We got so much acid just from the organics we harvested, and I thought they might like a taste of their own disgusting medicine.\n")
	elif itm == 'LRM':
		flavortext("One of the standard tactical weapons available.\n", "Pretty decent homing tech built in.  You do realize you'd have zero chance of hitting something without it, right?\n")
	elif itm == 'chaingun':
		flavortext("So many rounds, so little time.  Just hold it down and point it in their general direction.\n", "You don't need to buy any ammo for this, we just use the leftover rock bits from mining asteroids.\n")	
	elif itm == 'deflector':
		flavortext("Get a little forward protection against whatever nastiness they can throw at you.\n", "You'll have to wait a while to use it again, so make it count.")

func update_quantity(index, itm, mode='add'):
	var old_quantity = $bground2/shopmenubground/ScrollContainer/VBoxContainer/ItemList.get_item_text(index + 2)
	if itm in global.itemlist_lookup:
		var itemtype = global.itemlist[global.itemlist_lookup[itm]][5]
		var old_credits = int($bground2/shopmenubground/cash.text.substr(9, len($bground2/shopmenubground/cash.text) - 9))
		var cost = global.itemlist[global.itemlist_lookup[itm]][0]
		var quantity = 0
		if itemtype == 'missle':
			quantity = 10
		else:
			quantity = 1
		if mode == 'add':
			if cost <= old_credits:
				$bground2/shopmenubground/ScrollContainer/VBoxContainer/ItemList.set_item_text(index + 2, str(quantity + int(old_quantity)))
				var amount = quantity * int(cost)
				update_credits(old_credits, amount, mode)
				quant_indexes.append(itm)
			else:
				flavortext('Uh.\n', 'They not teach math at the academy anymore?\n') 
		elif mode == 'subtract':
			if itm in quant_indexes:
				$bground2/shopmenubground/ScrollContainer/VBoxContainer/ItemList.set_item_text(index + 2, str(int(old_quantity) - quantity))
				var amount = quantity * int(cost)
				update_credits(old_credits, amount, mode)
				quant_indexes.remove(itm)
			elif itm in global.inventory.keys():
				if (itemtype != 'missle' and quant_sold.count(itm) != global.inventory[itm]) or (itemtype == 'missle' and quant_sold.count(itm) * 10 != global.inventory[itm]):
					$bground2/shopmenubground/ScrollContainer/VBoxContainer/ItemList.set_item_text(index + 2, str(int(old_quantity) - quantity))
					var amount = quantity * int(cost)
					update_credits(old_credits, amount, mode)
					quant_sold.append(itm)
				else:
					flavortext('Uh.\n', 'You got nothing to sell there cowboy.\n') 
			else:
				flavortext('Uh.\n', 'You got nothing to sell there cowboy.\n') 
				
func update_credits(old_credits, amount, mode='add'):
	var new_credits = 0
	if mode == 'add':
		new_credits = old_credits - amount
	elif mode == 'subtract':
		new_credits = old_credits + amount
	$bground2/shopmenubground/cash.text = 'Credits: ' + str(new_credits)
		
func _on_ItemList_item_activated(index):
	var itm = $bground2/shopmenubground/ScrollContainer/VBoxContainer/ItemList.get_item_text(index)
	update_quantity(index, itm, 'add')

func _on_addbutton_pressed():
	if $bground2/shopmenubground/ScrollContainer/VBoxContainer/ItemList.get_selected_items():
		var index = $bground2/shopmenubground/ScrollContainer/VBoxContainer/ItemList.get_selected_items()[0]
		var itm = $bground2/shopmenubground/ScrollContainer/VBoxContainer/ItemList.get_item_text(index)
		update_quantity(index, itm, 'add')
		
func _on_removebutton_pressed():
	if $bground2/shopmenubground/ScrollContainer/VBoxContainer/ItemList.get_selected_items():
		var index = $bground2/shopmenubground/ScrollContainer/VBoxContainer/ItemList.get_selected_items()[0]
		var itm = $bground2/shopmenubground/ScrollContainer/VBoxContainer/ItemList.get_item_text(index)
		update_quantity(index, itm, 'subtract')

func _on_confirmbutton_pressed():
	global.player_credits = int($bground2/shopmenubground/cash.text.substr(9, len($bground2/shopmenubground/cash.text) - 9))
	var itemtype = ''
	var quant = 0
	for itm in quant_indexes:
		itemtype = global.itemlist[global.itemlist_lookup[itm]][5]
		if itemtype == 'missle':
			quant = 10
		else:
			quant = 1
		if itm in global.inventory.keys():
			global.inventory[itm] = global.inventory[itm] + quant
		else:
			global.inventory[itm] = quant
	if quant_sold:
		for itm in quant_sold:
			itemtype = global.itemlist[global.itemlist_lookup[itm]][5]
			if itemtype == 'missle':
				quant = 10
			else:
				quant = 1
			if itm in global.inventory.keys():
				global.inventory[itm] = global.inventory[itm] - quant
	closeshop('bought')
	quant_indexes = []
	quant_sold = []