extends Area2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_shopkeep_body_entered(body):
	if body.get_groups().has('character'):
		$'../'.shopintro()


func _on_shopkeep_body_exited(body):
	if body.get_groups().has('character'):
		$'../'.closeshop()
