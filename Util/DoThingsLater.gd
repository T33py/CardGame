extends Node2D

class_name DoThingsLater

var things_to_do_each_frame: Array[Callable] = []
var things_to_do_on_a_timer: Array[Callable] = []
var thing_timers: Array[float] = []
var thing_timer_durations: Array[float] = []

# don't keep alocating these needlessly
var something_timed_out = false
var things_that_timed_out: Array[int] = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if len(things_to_do_each_frame) > 0:
		for thing in things_to_do_each_frame:
			thing.call()
			
	if len(things_to_do_on_a_timer) > 0:
		for i in range(len(things_to_do_on_a_timer)):
			thing_timers[i] -= delta
			if thing_timers[i] <= 0:
				things_that_timed_out.append(i)
				something_timed_out = true
		
		if something_timed_out:
			for i in things_that_timed_out:
				things_to_do_on_a_timer[i].call()
				thing_timers[i] += thing_timer_durations[i]
				
				
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
