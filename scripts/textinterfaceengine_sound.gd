extends Node

var sched = []
var indx = 0
var evt = 0
var notplaying = false

func _ready():
	pass

func _process():
	if sched and notplaying:
		if indx < len(sched):
			evt = sched[indx]
			handle_event(evt)
		else:
			sched = []
			indx = 0

func playTIEsounds(schedule):
	sched = schedule
	
func handle_event(evt):
	$duration.wait_time = abs(evt)
	$duration.start()
	if evt > 0:
		$click.play()

func _on_duration_timeout():
	$click.stop()
	indx += 1
