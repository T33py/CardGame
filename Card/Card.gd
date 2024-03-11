extends Node2D
class_name PlayingCard

enum Suits  { Hearts, Diamonds, Clubs, Spades, }
enum Values { Ace, One, Two, Three, Four, Five, Six, Seven, Eight, Nine, Ten, Jack, Queen, King, }

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
	content = find_child("Content", false)
	top_left_corner = content.find_child("TopLeftCorner", false)
	bottom_right_corner = content.find_child("BottomRightCorner", false)
	center_pattern = content.find_child("CenterPattern", false)
	
	current_center_pattern = center_pattern.find_child(patterns[my_value])
	current_top_left_corner_value = top_left_corner.find_child(patterns[my_value])
	current_top_left_corner_suit = top_left_corner.find_child(symbols[my_suit])
	current_bottom_right_corner_value = bottom_right_corner.find_child(patterns[my_value])
	current_bottom_right_corner_suit = bottom_right_corner.find_child(symbols[my_suit])
	
	
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
