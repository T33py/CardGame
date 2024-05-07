extends Node2D

class_name DoThingsLater

var things_to_do_each_frame: Array[Callable] = []
var things_to_do_on_a_timer: Array[Callable] = []
var thing_timers: Array[float] = []
var thing_timer_durations: Array[float] = []

# don't keep alocating these needlessly
var things_to_do_this_frame: Array[Callable] = []
var things_that_timed_out: Array[Callable] = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# calling a thing may remove that thing from the list of things to do later
	# DON'T try to optimize
	if len(things_to_do_each_frame) > 0:
		for thing in things_to_do_each_frame:
			things_to_do_this_frame.append(thing)
		for thing in things_to_do_this_frame:
			thing.call()
		things_to_do_this_frame.clear()
		
			
	if len(things_to_do_on_a_timer) > 0:
		for i in range(len(things_to_do_on_a_timer)):
			thing_timers[i] -= delta
			if thing_timers[i] <= 0:
				things_that_timed_out.append(things_to_do_on_a_timer[i])
		for thing in things_that_timed_out:
			var idx = things_to_do_on_a_timer.find(thing, 0)
			thing_timers[idx] += thing_timer_durations[idx]
			thing.call()
		things_that_timed_out.clear()
	return


func add_thing_to_do_each_frame(thing: Callable):
	if thing != null:
		things_to_do_each_frame.append(thing)
	return

func remove_thing_to_do_each_frame(thing: Callable):
	remove_from_list(thing, things_to_do_each_frame)
	return

func add_thing_to_do_on_a_timer(thing: Callable, time: float):
	things_to_do_on_a_timer.append(thing)
	thing_timers.append(time)
	thing_timer_durations.append(time)
	return
	
func remove_thing_to_do_on_a_timer(thing: Callable):
	remove_from_synched_lists(thing, things_to_do_on_a_timer, [thing_timers, thing_timer_durations])
	return


func remove_from_list(item, list: Array):
	for i in range(len(list)):
		if list[i] == item:
			list.remove_at(i)
			print("removed a thing " + str(item))
			break
	return

func remove_from_synched_lists(item, list_with_item: Array, other_lists: Array):
	for i in range(len(list_with_item)):
		if list_with_item[i] == item:
			list_with_item.remove_at(i)
			for list in other_lists:
				list.remove_at(i)
			print("removed a thing " + str(item))
			break
	return
