extends Node

var quant_indexes = []
var quant_sold = []
var intro = true

func _ready():
	$character.global_position = Vector2(765, 726)
	$bground/buybutton.add_color_override('font_color', Color(67,70,103))
	$bground/buybutton.add_color_override('font_color_hover', Color(255,0,0))
	$bground2/addbutton.add_color_override('font_color', Color(67,70,103))
	$bground2/addbutton.add_color_override('font_color_hover', Color(255,0,0))
	$bground2/removebutton.add_color_override('font_color', Color(67,70,103))
	$bground2/removebutton.add_color_override('font_color_hover', Color(255,0,0))
	$bground2/confirmbutton.add_color_override('font_color', Color(67,70,103))
	$bground2/confirmbutton.add_color_override('font_color_hover', Color(255,0,0))

func shopintro():
	intro = true
	if $bground.visible == false:
		$bground.visible = true
		$bground/shopbackground/shoptext.reset()
		$bground/shopbackground/shoptext.set_color(Color(0,0,0))
		$bground/shopbackground/shoptext.buff_text('You may trade with us, but do not disappoint.\n', 0.025)
		$bground/shopbackground/shoptext.buff_silence(.025)
		$bground/shopbackground/shoptext.set_state($bground/shopbackground/shoptext.STATE_OUTPUT)

func clusterintro():
	if $bground3.visible == false:
		$bground3.visible = true
		$bground3/clusterbground/clustertext.reset()
		$bground3/clusterbground/clustertext.set_color(Color(0,0,0))
		$bground3/clusterbground/clustertext.buff_text("We have no time for deals, pilot.\n", 0.025)
		$bground3/clusterbground/clustertext.buff_silence(.025)
		$bground3/clusterbground/clustertext.set_state($bground3/clusterbground/clustertext.STATE_OUTPUT)
		
func clustermainintro():
	if $bground4.visible == false:
		$bground4.visible = true
		$bground4/mainclusterbground/mainclustertext.reset()
		$bground4/mainclusterbground/mainclustertext.set_color(Color(0,0,0))
		$bground4/mainclusterbground/mainclustertext.buff_text('We have been watching you pilot...\n\n', 0.050)
		$bground4/mainclusterbground/mainclustertext.buff_silence(1)
		$bground4/mainclusterbground/mainclustertext.buff_text('These are dark times for all of us...\n\n', 0.050)
		$bground4/mainclusterbground/mainclustertext.buff_silence(2)
		$bground4/mainclusterbground/mainclustertext.buff_clear()
		$bground4/mainclusterbground/mainclustertext.buff_text('I feel the deaths of my children to the ravagers...\n\n', 0.050)
		$bground4/mainclusterbground/mainclustertext.buff_silence(1)
		$bground4/mainclusterbground/mainclustertext.buff_text('Each one cries out...and each silence cuts deep.\n\n', 0.050)
		$bground4/mainclusterbground/mainclustertext.buff_silence(2)
		$bground4/mainclusterbground/mainclustertext.buff_clear()
		$bground4/mainclusterbground/mainclustertext.buff_text('We are not warriors, we are simply survivors, doing what must be done.\n\n', 0.050)
		$bground4/mainclusterbground/mainclustertext.buff_silence(1)
		$bground4/mainclusterbground/mainclustertext.buff_text('You fear us and rightly so, for you are the nourishment for future generations of my children!\n\n', 0.050)
		$bground4/mainclusterbground/mainclustertext.buff_silence(3)
		$bground4/mainclusterbground/mainclustertext.buff_clear()
		$bground4/mainclusterbground/mainclustertext.buff_silence(1)
		$bground4/mainclusterbground/mainclustertext.buff_text('But the ravagers are not a part of life.  They know only death.\n\n', 0.050)
		$bground4/mainclusterbground/mainclustertext.buff_silence(1)
		$bground4/mainclusterbground/mainclustertext.buff_text('They must be stopped.  Nearby you will find a portal to their home.\n\n', 0.050)
		$bground4/mainclusterbground/mainclustertext.buff_silence(2)
		$bground4/mainclusterbground/mainclustertext.buff_clear()
		$bground4/mainclusterbground/mainclustertext.buff_text('You must enter this portal and stop them.  You are the warrior who must see this done.\n\n', 0.050)
		$bground4/mainclusterbground/mainclustertext.buff_silence(1)
		$bground4/mainclusterbground/mainclustertext.buff_text('We will assist as we can.  I have instructed my children to not harm you and provide you with supplies.\n\n', 0.050)
		$bground4/mainclusterbground/mainclustertext.buff_silence(2)
		$bground4/mainclusterbground/mainclustertext.buff_clear()
		$bground4/mainclusterbground/mainclustertext.buff_text('Go now, and hurry.\n\n', 0.050)
		$bground4/mainclusterbground/mainclustertext.buff_silence(2)
		$bground4/mainclusterbground/mainclustertext.set_state($bground/shopbackground/shoptext.STATE_OUTPUT)


func clustermainconvo():
	if $bground4.visible == false:
		$bground4.visible = true
		$bground4/mainclusterbground/mainclustertext.reset()
		$bground4/mainclusterbground/mainclustertext.set_color(Color(0,0,0))
		$bground4/mainclusterbground/mainclustertext.buff_text('Why are you still here?\n\n', 0.050)
		$bground4/mainclusterbground/mainclustertext.buff_silence(1)
		$bground4/mainclusterbground/mainclustertext.buff_text('You must hurry!\n\n', 0.050)
		$bground4/mainclusterbground/mainclustertext.buff_silence(2)
		$bground4/mainclusterbground/mainclustertext.set_state($bground/shopbackground/shoptext.STATE_OUTPUT)


func closemainclustertext():
	$bground4.visible = false
		
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
		$bground/shopbackground/shoptext.buff_text('Leave us.\n', 0.025)
		$bground/shopbackground/shoptext.buff_silence(.025)
		$bground/shopbackground/shoptext.set_state($bground/shopbackground/shoptext.STATE_OUTPUT)
	else:
		$bground.visible = false
		$bground/buybutton.visible = false

func closeclustertext():
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
				flavortext('Ha!\n', 'You should be grateful i do not render you into feeding paste!\n') 
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
					flavortext('Pilot.\n', 'You cannot sell what you do not have.\n') 
			else:
				flavortext('Pilot.\n', 'You cannot sell what you do not have.\n') 
		
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


func _on_computercluster_body_entered(body):
	if body.get_groups().has('character'):
		shopintro()


func _on_computercluster_body_exited(body):
	if body.get_groups().has('character'):
		closeshop()


func _on_computercluster2_body_entered(body):
	if body.get_groups().has('character'):
		clusterintro()


func _on_computercluster2_body_exited(body):
	if body.get_groups().has('character'):
		closeclustertext()


func _on_speakingplatform_body_entered(body):
	if body.get_groups().has('character'):
		if global.clusterintro == false:
			global.clusterintro = true
			clustermainintro()
		else:
			clustermainconvo()


func _on_speakingplatform_body_exited(body):
	if body.get_groups().has('character'):
		closemainclustertext()
