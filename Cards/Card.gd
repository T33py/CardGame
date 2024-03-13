extends Node2D
class_name Card

enum Suits  { Hearts, Diamonds, Clubs, Spades, }
enum Values { Ace, One, Two, Three, Four, Five, Six, Seven, Eight, Nine, Ten, Jack, Queen, King, }
signal card_clicked(card: Card)
signal mouse_hovers(card: Card)
signal mouse_stopped_hovering(card: Card)

var colors = {
	Suits.Hearts: Color("ec0808"), 
	Suits.Diamonds: Color("ec9808"), 
	Suits.Spades: Color("05105d"), 
	Suits.Clubs: Color("000000"),
}
var patterns = {
	Values.Ace: "A",
	Values.One: "1",
	Values.Two: "2",
	Values.Three: "3",
	Values.Four: "4",
	Values.Five: "5",
	Values.Six: "6",
	Values.Seven: "7",
	Values.Eight: "8",
	Values.Nine: "9",
	Values.Ten: "10",
	Values.Jack: "J",
	Values.Queen: "Q",
	Values.King: "K",
}
var symbols = {
	Suits.Hearts: "Heart",
	Suits.Diamonds: "Diamond",
	Suits.Clubs: "Club",
	Suits.Spades: "Spade",
}

var in_focus = false
var focus_scale = 1.05
var scale_before_focused = 1

@export var my_suit : Suits = Suits.Hearts
@export var my_value: Values = Values.Ace

var current_center_pattern
var current_top_left_corner_value
var current_top_left_corner_suit
var current_bottom_right_corner_value
var current_bottom_right_corner_suit

var suit_or_value_changed = false
var content: Node2D
var top_left_corner: Node2D
var bottom_right_corner: Node2D
var center_pattern: Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	print("new card")
	content = find_child("Content", false)
	top_left_corner = content.find_child("TopLeftCorner", false)
	bottom_right_corner = content.find_child("BottomRightCorner", false)
	center_pattern = content.find_child("CenterPattern", false)
	
	current_center_pattern = center_pattern.find_child(patterns[my_value], false)
	current_top_left_corner_value = top_left_corner.find_child(patterns[my_value], false)
	current_top_left_corner_suit = top_left_corner.find_child(symbols[my_suit], false)
	current_bottom_right_corner_value = bottom_right_corner.find_child(patterns[my_value], false)
	current_bottom_right_corner_suit = bottom_right_corner.find_child(symbols[my_suit], false)
	
	redraw()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if suit_or_value_changed:
		redraw()
	pass

func set_suit(suit: Suits):
	my_suit = suit
	suit_or_value_changed = true
	pass
	
func set_value(value: Values):
	my_value = value
	suit_or_value_changed = true
	pass

func redraw():
	current_top_left_corner_suit.visible = false
	current_top_left_corner_value.visible = false
	current_bottom_right_corner_suit.visible = false
	current_bottom_right_corner_value.visible = false
	current_center_pattern.visible = false
	
	current_center_pattern = center_pattern.find_child(patterns[my_value])
	current_top_left_corner_value = top_left_corner.find_child(patterns[my_value])
	current_top_left_corner_suit = top_left_corner.find_child(symbols[my_suit])
	current_bottom_right_corner_value = bottom_right_corner.find_child(patterns[my_value])
	current_bottom_right_corner_suit = bottom_right_corner.find_child(symbols[my_suit])
	
	current_top_left_corner_suit.visible = true
	current_top_left_corner_value.visible = true
	current_bottom_right_corner_suit.visible = true
	current_bottom_right_corner_value.visible = true
	current_center_pattern.visible = true
	
	current_center_pattern.modulate = colors[my_suit]
	current_top_left_corner_value.modulate = colors[my_suit]
	current_bottom_right_corner_value.modulate = colors[my_suit]
	pass

func get_width():
	return find_child("BasicCardFront").texture.get_width() * scale.x

func get_height():
	return find_child("BasicCardFront").texture.get_height() * scale.y


func _on_area_2d_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			card_clicked.emit(self)
			print ("Clicked: " + str(self))
	pass

func change_focused(is_focus: bool):
	if in_focus == is_focus:
		return
	in_focus = is_focus
	if in_focus:
		scale_before_focused = scale
		scale *= focus_scale
	else:
		scale = scale_before_focused
	pass


func _on_area_2d_mouse_entered():
	mouse_hovers.emit(self)
	pass # Replace with function body.


func _on_area_2d_mouse_exited():
	mouse_stopped_hovering.emit(self)
	pass # Replace with function body.

func _to_string():
	return str(patterns[my_value]) + " of " + str(symbols[my_suit])
