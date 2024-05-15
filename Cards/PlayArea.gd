extends Node2D
class_name PlayArea

signal currently_hovered
signal no_longer_hovered
signal lmb_up
signal card_played
signal end_turn(cards: Array[Card])

var display_area: CardDisplayArea

@export var deck: Deck
@export var number_of_cards_to_allow = 5
@export var selected_card_y_offset = 100
var cards: Array[Card] = []
var cards_being_hovered: Array[Card] = []
var selected_card: Card = null
var hovered = false

# Called when the node enters the scene tree for the first time.
func _ready():
	display_area = find_child("DisplayArea", false)
	
	return # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	return
	
# play a card onto the play area
func play_card(card: Card)-> bool:
	cards_being_hovered.clear()
	if len(cards) >= number_of_cards_to_allow:
		return false
	display_area.place_card(card)
	cards = display_area.cards
	card.connect("mouse_hovers", _player_hovers_over_card)
	card.connect("mouse_stopped_hovering", _player_no_longer_hovers_over_card)
	card.am_being_hovered_over.connect(_on_card_is_hovered_over)
	card_played.emit()
	return true

func play_hand():
	var cards_played = []
	for card in cards:
		cards_played.append(card)
	for card in cards_played:
		remove_card_from_play(card)
	print("ending turn with " + str(cards_played))
	cards_being_hovered.clear()
	selected_card = null
	display_area.layout_cards()
	end_turn.emit(cards_played)
	return

# remove a card from the play area
func remove_card_from_play(card: Card):
	if card not in cards:
		return
	display_area.remove_card(card)
	card.mouse_hovers.disconnect(_player_hovers_over_card)
	card.mouse_stopped_hovering.disconnect(_player_no_longer_hovers_over_card)
	card.am_being_hovered_over.disconnect(_on_card_is_hovered_over)
	remove_from_list(card, cards)
	deck.discard(card)
	return
	
func clear():
	for card in cards:
		remove_card_from_play(card)
	return

# handles the mouse hovering multiple cards
func handle_multihover():
	if len(cards_being_hovered) == 0:
		return
		
	print(cards_being_hovered)
	
	for card in cards_being_hovered:
		card.change_focused(false)
		
	if len(cards_being_hovered) == 1:
		cards_being_hovered[0].change_focused(true)
		return
	
	var top_z = 10000
	var top_card:Card = cards[0]
	for card in cards_being_hovered:
		card.change_focused(false)
		if card.z_index < top_z:
			top_card = card
		
	top_card.change_focused(true)
	return

func _player_hovers_over_card(card: Card):
	print("player hovers " + str(card))
	if card not in cards_being_hovered:
		cards_being_hovered.append(card)
	handle_multihover()
	return

func _player_no_longer_hovers_over_card(card: Card):
	print("player no longer hovers " + str(card))
	for c in range(len(cards_being_hovered)):
		if card == cards_being_hovered[c]:
			cards_being_hovered.remove_at(c)
			break
	card.change_focused(false)
	handle_multihover()
	return


func _on_play_hand_pressed():
	play_hand()
	return


func _on_area_2d_mouse_entered():
	print("hovers pa")
	hovered = true
	currently_hovered.emit()
	return


func _on_area_2d_mouse_exited():
	hovered = false
	no_longer_hovered.emit()
	display_area.remove_phantom_card()
	return


func _on_area_2d_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if hovered:
			if event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
				lmb_up.emit()
				display_area.remove_phantom_card()
	pass # Replace with function body.

func _on_card_is_hovered_over(card: Card, hoverer: Card):
	if card not in cards:
		return
	if len(cards) >= number_of_cards_to_allow:
		return
	
	var i = 0
	for c in cards:
		if c == card:
			if c.hover_side == 1:
				i += 1
			break
		i += 1
	display_area.add_phantom_card(i)
	return

func _on_area_2d_area_exited(area):
	display_area.remove_phantom_card()
	return

func remove_from_list(item, list: Array):
	for i in range(len(list)):
		if list[i] == item:
			list.remove_at(i)
			break
	return

