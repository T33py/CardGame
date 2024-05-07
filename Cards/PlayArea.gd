extends Node2D
class_name PlayArea

signal currently_hovered
signal no_longer_hovered
signal lmb_up
signal card_played
signal hand_played

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
	
func play_card(card: Card)-> bool:
	cards_being_hovered.clear()
	if len(cards) >= number_of_cards_to_allow:
		return false
	cards.append(card)
	display_area.place_card(card)
	card.connect("mouse_hovers", _player_hovers_over_card)
	card.connect("mouse_stopped_hovering", _player_no_longer_hovers_over_card)
	card_played.emit()
	return true

func play_hand():
	hand_played.emit()
	cards_being_hovered.clear()
	return
	
func clear():
	for card in cards:
		card.disconnect("mouse_hovers", _player_hovers_over_card)
		card.disconnect("mouse_stopped_hovering", _player_no_longer_hovers_over_card)
		display_area.remove_card(card)
		deck.discard(card)
		
	cards.clear()
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
	return


func _on_area_2d_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if hovered:
			if event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
				lmb_up.emit()
	pass # Replace with function body.


func remove_from_list(item, list: Array):
	for i in range(len(list)):
		if list[i] == item:
			list.remove_at(i)
			break
	return
