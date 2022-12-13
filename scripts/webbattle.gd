extends Area2D

func _ready():
	pass

func _on_webbattle_body_exited(body):
	var grps = body.get_groups()
	if grps.has('giant spider') or grps.has('small spider'):
		body.reverse_course()
	elif grps.has('player'):
		body.webbed(false)

func _on_webbattle_body_entered(body):
	var grps = body.get_groups()
	if grps.has('player'):
		body.webbed(true)
