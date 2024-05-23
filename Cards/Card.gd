extends Node2D
class_name Card

enum Suits  { Hearts, Diamonds, Clubs, Spades, }
enum Values { Ace, One, Two, Three, Four, Five, Six, Seven, Eight, Nine, Ten, Jack, Queen, King, }
enum States { InDeck, Discarded, InHand, InField, Moving }
signal card_clicked(card: Card)
signal mouse_hovers(card: Card)
signal mouse_stopped_hovering(card: Card)
var hover_ee_protect = false

signal picked_up(card: Card)
signal put_down(card: Card)
var emitted_picked_up = false

signal am_being_hovered_over(me: Card, other: Card)
var left_hover_detect: Area2D
var right_hover_detect: Area2D
var hover_side = 0

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

var focusable = true
var focusloss_scale_override = false
var in_focus = false
var focus_scale = 1.05
var scale_before_focused = 1
var z_before_focused = 0
var focusborder: Sprite2D
var focusborder2: Sprite2D

var may_be_dragged = false
var user_attempts_to_drag = false
var end_of_drag_return_position
var not_click_delay = 0.15
var not_click_timer = 0

@export var my_suit : Suits = Suits.Hearts
@export var my_value: Values = Values.Ace
var my_state: States = States.InDeck
var remembered_state: States = States.InDeck

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
#	print("new card")
	end_of_drag_return_position = position
	content = find_child("Content", false)
	top_left_corner = content.find_child("TopLeftCorner", false)
	bottom_right_corner = content.find_child("BottomRightCorner", false)
	center_pattern = content.find_child("CenterPattern", false)
	
	current_center_pattern = center_pattern.find_child(patterns[my_value], false)
	current_top_left_corner_value = top_left_corner.find_child(patterns[my_value], false)
	current_top_left_corner_suit = top_left_corner.find_child(symbols[my_suit], false)
	current_bottom_right_corner_value = bottom_right_corner.find_child(patterns[my_value], false)
	current_bottom_right_corner_suit = bottom_right_corner.find_child(symbols[my_suit], false)
	
	left_hover_detect = find_child("left_side", false)
	left_hover_detect.hovered.connect(_on_hovered_by)
	right_hover_detect = find_child("right_side", false)
	right_hover_detect.hovered.connect(_on_hovered_by)
	
	focusborder = find_child("FocusBorder", false)
	focusborder2 = find_child("FocusBorder2", false)
	
	redraw()
	return # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if suit_or_value_changed:
		redraw()
		
	if may_be_dragged:
		not_click_timer += delta
		if not_click_timer >= not_click_delay:
			being_dragged()
	
	if hover_ee_protect:
		hover_ee_protect = false
	return

func set_suit(suit: Suits):
	my_suit = suit
	suit_or_value_changed = true
	return
	
func set_value(value: Values):
	my_value = value
	suit_or_value_changed = true
	return

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
	return

func get_width():
	return find_child("BasicCardFront").texture.get_width()

func get_height():
	return find_child("BasicCardFront").texture.get_height()


func _on_area_2d_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			print ("Clicked: " + str(self))
			card_clicked.emit(self)
			# make shure we emit the card_clicked signal to allow the owner of this card to decide whether it should be dragged
			if not may_be_dragged:
				end_of_drag_return_position = global_position
				may_be_dragged = true
		if event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
			end_of_being_dragged()
			print("released")
		
		if event.button_index == MOUSE_BUTTON_RIGHT and my_state == States.Moving:
			end_of_being_dragged()
	return

func change_focused(is_focus: bool):
	if in_focus == is_focus or not focusable:
		return
	in_focus = is_focus
	if in_focus:
		scale_before_focused = scale
		scale *= focus_scale
		z_before_focused = z_index
		z_index = 1000
		focusborder.visible = true
		focusborder2.visible = true
	else:
		# if the scale has not been overwritten we return to the original one
		if not focusloss_scale_override:
			scale = scale_before_focused
			z_index = z_before_focused
		focusloss_scale_override = false
		focusborder.visible = false
		focusborder2.visible = false
	return


func being_dragged():
	if !emitted_picked_up:
		picked_up.emit(self)
		emitted_picked_up = true
	if my_state != States.Moving:
		remembered_state = my_state
		my_state = States.Moving
	global_position = get_global_mouse_position()
	focusable = false
	return

func end_of_being_dragged():
	if not may_be_dragged:
		return
	
	may_be_dragged = false
	global_position = end_of_drag_return_position
	my_state = remembered_state
	emitted_picked_up = false
	not_click_timer = 0
	focusable = true
	
	put_down.emit(self)
	return

func _on_area_2d_mouse_entered():
	hover_ee_protect = true
	mouse_hovers.emit(self)
	return # Replace with function body.


func _on_area_2d_mouse_exited():
	if hover_ee_protect:
		return
	mouse_stopped_hovering.emit(self)
#	end_of_being_dragged()
	return # Replace with function body.

func _to_string():
	return str(patterns[my_value]) + " of " + str(symbols[my_suit]) + "s"


func _on_hovered_by(area, side: int):
	if area.get_parent() is Card:
		var card = area.get_parent() as Card
		if not may_be_dragged and card.may_be_dragged:
			hover_side = side
			am_being_hovered_over.emit(self, area as Card)
	pass # Replace with function body.
