extends Node2D

class_name DoThingsLater

var things_to_do_each_frame: Array[Callable] = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if len(things_to_do_each_frame) > 0:
		for thing in things_to_do_each_frame:
			thing.call()
	return


func add_thing_to_do_each_frame(thing: Callable):
	if thing != null:
		things_to_do_each_frame.append(thing)
	return

func remove_thing_to_do_each_frame(thing: Callable):
	remove_from_list(thing, things_to_do_each_frame)
	return

func remove_from_list(item, list: Array):
	for i in range(len(list)):
		if list[i] == item:
			list.remove_at(i)
			print("removed a thing " + str(item))
			break
	return
