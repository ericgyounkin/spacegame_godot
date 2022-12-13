extends Area2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass


func _on_captain_body_entered(body):
	if body.get_groups().has('character'):
		if global.gamestate == 2:
			$'../'.captaincutscene4()
			global.gamestate = 3
		else:
			$'../'.captainintro()

func _on_captain_body_exited(body):
	if body.get_groups().has('character'):
		$'../'.closecaptaintext()