extends Node2D

# this class handles the event queue for ordering things that should happen in an orderly fasion one at a time
class_name EventQueue

var event_queue: Array[Event]
var currently_executing_event: Event = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# if the currently executing event has finished - we don't care about it here any more
	if currently_executing_event != null:
		if currently_executing_event.finished:
			currently_executing_event = null
	
	if len(event_queue) > 0:
		currently_executing_event = event_queue[0]
		event_queue.remove_at(0)
		currently_executing_event.started = true
	pass


func prepend_event(event: Event):
	if event == null:
		return
	if len(event_queue) == 0:
		event_queue.append(event)
	else:
		event_queue.insert(0, event)
	return
	
func append_event(event: Event):
	event_queue.append(event)
	return
