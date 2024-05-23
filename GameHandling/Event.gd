# event that is passed to the EventQueue
class_name Event

# name of the event - in case you want to track it
var name = "unnamed event"

# this is set to true once it gets to the front of the queue, allowing your event script to run
var started = false

# you need to set this to true to signify that the event has traspired, and the next event in the queue can start
var finished = false

# reference to self, in case this event needs others to reference back to you for the event to finish
var performed_by = null

# if this event has a specific target, this should be the reference to the target
var targetting = null
