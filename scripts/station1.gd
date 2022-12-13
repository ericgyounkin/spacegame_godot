extends Area2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _process(delta):
	rotation += .0015
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_station1_area_entered(area):
	$'../../../'.goto_station(area)
	
