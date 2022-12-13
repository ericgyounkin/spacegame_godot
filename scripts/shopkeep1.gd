extends Container
var rownum = 0
var itemname = ''
var itemtype = ''
var displayname = ''
var cost = 0
var balance = 0
var purch_list = {}
var mode = ''

var item_descriptions = {'torpedo1': "Simple dumb-fire missle weapon.  Doesn't pack the biggest punch and hard to hit with, but we can crank these babies out pretty fast.",
						 'homing_torpedo1': "Same warhead as the basic torpedo, but this one can seek and destroy.  Or at least try to, we can only really afford the discounted guidance chips.",
						 'torpedo_swarm': "Why fire one when you can fire ten?  Just try not to turn and fire too quickly, the array has to be rear mounted...",
						 'blue_laser': "Your basic laser weapon, probably the same tech you used in the academy.  You break one of these, I got a hundred more to replace it with.",
						 'red_beam': "You know how hard it is to deal with overheating weapons in space?  Neither do I, hopefully the guys who built this overpowered beam weapon do.",
						 'acid_thrower': "This one is of my design!  We got so much acid just from the organics we harvested, and I thought they might like a taste of their own disgusting medicine.",
						 'lrm': "One of the standard tactical weapons available.  Pretty decent homing tech built in.  You do realize you'd have zero chance of hitting something without it, right?"}
						
func _ready():
	$HBoxContainer/items/ItemList.clear()
	initialize_player_stats()
	
func initialize_shop_inventory():
	purch_list = {}
	balance = 0
	$HBoxContainer/items/ItemList.clear()
	clear_purchase()
	if mode == 'buy':
		$HBoxContainer/items/ItemList.max_columns = 4
		var header = ['Cost', 'Name', 'Fire Rate', 'Damage']
		for h in header:
			$HBoxContainer/items/ItemList.add_item(h)
		for spacer in [' ',' ',' ',' ']:
			$HBoxContainer/items/ItemList.add_item(spacer)
		for it in global.itemlist:
			$HBoxContainer/items/ItemList.add_item(str(global.itemlist[it][0]))
			$HBoxContainer/items/ItemList.add_item(str(global.itemlist[it][4]))
			$HBoxContainer/items/ItemList.add_item(str(global.itemlist[it][2]))
			$HBoxContainer/items/ItemList.add_item(str(global.itemlist[it][1]))
	elif mode == 'sell':
		$HBoxContainer/items/ItemList.max_columns = 2
		var header = ['Name', 'Quantity']
		for h in header:
			$HBoxContainer/items/ItemList.add_item(h)
		for spacer in [' ',' ']:
			$HBoxContainer/items/ItemList.add_item(spacer)
		for it in global.inventory.keys():
			$HBoxContainer/items/ItemList.add_item(it)
			$HBoxContainer/items/ItemList.add_item(str(global.inventory[it]))

func initialize_player_stats():
	$HBoxContainer/leftbar/playerstats/name.text = 'Account = ' + global.player_name
	$HBoxContainer/leftbar/playerstats/credit.text = str(global.player_credits) + ' credits'

func _on_ItemList_multi_selected(index, selected):
	if index > $HBoxContainer/items/ItemList.max_columns * 2 - 1:
		rownum = int(index / $HBoxContainer/items/ItemList.max_columns)
		itemname = global.itemlist.keys()[rownum - 2]
		if mode == 'buy':
			$HBoxContainer/rightbar/rightbarcontainer/messages/message.text = item_descriptions[itemname]
			$HBoxContainer/items/ItemList.select(rownum * $HBoxContainer/items/ItemList.max_columns + 1)
		elif mode == 'sell':
			$HBoxContainer/rightbar/rightbarcontainer/messages/message.text = ''
			$HBoxContainer/items/ItemList.select(rownum * $HBoxContainer/items/ItemList.max_columns)
	else:
		$HBoxContainer/rightbar/rightbarcontainer/messages/message.text = ''

func _on_leave_pressed():
	global.goto_scene("res://scenes/station/station.tscn")

func _on_ItemList_item_activated(index):
	$HBoxContainer/leftbar/playerstats/balance.show()
	$HBoxContainer/leftbar/playerstats/purchase_list.show()
	$HBoxContainer/leftbar/playerstats/confirm.show()
	$HBoxContainer/leftbar/playerstats/clear.show()
	if index > $HBoxContainer/items/ItemList.max_columns * 2 - 1:
		rownum = int(index / $HBoxContainer/items/ItemList.max_columns)
		if mode == 'buy':
			itemname = global.itemlist.keys()[rownum - 2]
			displayname = global.itemlist[itemname][4]
			itemtype = global.itemlist[itemname][5]
			cost = global.itemlist[itemname][0]
			var quantity = 0
			if itemtype == 'missle':
				quantity = 10
			else:
				quantity = 1
			if displayname in purch_list.keys():
				purch_list[displayname] += quantity
			else:
				purch_list[displayname] = quantity
			update_purchase_list()
			update_balance(cost)
		elif mode == 'sell':
			itemname = $HBoxContainer/items/ItemList.get_item_text(rownum * $HBoxContainer/items/ItemList.max_columns)
			for ky in global.itemlist.keys():
				if global.itemlist[ky][4] == itemname:
					cost = global.itemlist[ky][0]
			if itemname in purch_list.keys():
				if global.inventory[itemname] == purch_list[itemname]:
					return
				purch_list[itemname] += 1
			else:
				purch_list[itemname] = 1
			update_purchase_list()
			update_balance(-cost)
			
func update_purchase_list():
	$HBoxContainer/leftbar/playerstats/purchase_list.clear()
	for item in purch_list.keys():
		$HBoxContainer/leftbar/playerstats/purchase_list.add_item(item)
		$HBoxContainer/leftbar/playerstats/purchase_list.add_item(str(purch_list[item]))

func update_balance(cost):
	balance += cost
	if balance:
		if balance >= 0:
			$HBoxContainer/leftbar/playerstats/balance.modulate = Color(255,1,1,1)
			$HBoxContainer/leftbar/playerstats/balance.text = '  - ' + str(balance) + ' credits'
		else:
			$HBoxContainer/leftbar/playerstats/balance.modulate = Color(1,255,1,1)
			$HBoxContainer/leftbar/playerstats/balance.text = '  + ' + str(balance) + ' credits'
	else:
		$HBoxContainer/leftbar/playerstats/balance.text = ''

func clear_purchase():
	purch_list = {}
	balance = 0
	update_purchase_list()
	update_balance(0)
	initialize_player_stats()
	$HBoxContainer/leftbar/playerstats/balance.hide()
	$HBoxContainer/leftbar/playerstats/purchase_list.hide()
	$HBoxContainer/leftbar/playerstats/confirm.hide()
	$HBoxContainer/leftbar/playerstats/clear.hide()

func _on_ItemList_item_rmb_selected(index, at_position):
	pass # replace with function body

func _on_buy_pressed():
	mode = 'buy'
	$HBoxContainer/items/ItemList.clear()
	initialize_shop_inventory()

func _on_oflload_organics_pressed():
	$HBoxContainer/items/ItemList.clear()

func _on_sell_pressed():
	mode = 'sell'
	$HBoxContainer/items/ItemList.clear()
	initialize_shop_inventory()

func _on_confirm_pressed():
	$HBoxContainer/leftbar/playerstats/purchase_message.text = ''
	if purch_list: 
		if mode == 'buy':
			if balance <= global.player_credits:
				for key in purch_list.keys():
					if key in global.inventory.keys():
						global.inventory[key] = global.inventory[key] + purch_list[key]
					else:
						global.inventory[key] = purch_list[key]
				global.player_credits -= balance
				initialize_shop_inventory()
			else:
				$HBoxContainer/leftbar/playerstats/purchase_message.text = 'INSUFFICIENT FUNDS'
		
		if mode == 'sell':
			for key in purch_list.keys():
				if key in global.inventory.keys():
					var dif = global.inventory[key] - purch_list[key]
					if dif == 0:
						global.inventory.erase(key)
					else:
						global.inventory[key] = dif
			global.player_credits -= balance
			initialize_shop_inventory()

func _on_clear_pressed():
	$HBoxContainer/leftbar/playerstats/purchase_message.text = ''
	clear_purchase()