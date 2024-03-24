extends Node2D
class_name PlayArea

var display_area: CardDisplayArea

@export var number_of_cards_to_allow = 5
@export var selected_card_y_offset = 100
var cards: Array[Card] = []
var cards_being_hovered: Array[Card] = []
var selected_card: Card = null

# Called when the node enters the scene tree for the first time.
func _ready():
	display_area = find_child("DisplayArea", false)
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func play_card(card: Card):
	if len(cards) >= number_of_cards_to_allow:
		return false
	cards.append(card)
	display_area.place_card(card)
	card.connect("mouse_hovers", _player_hovers_over_card)
	card.connect("mouse_stopped_hovering", _player_no_longer_hovers_over_card)
	return true


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
		pass
	top_card.change_focused(true)
	pass

func _player_hovers_over_card(card: Card):
	print("player hovers " + str(card))
	if card not in cards_being_hovered:
		cards_being_hovered.append(card)
	handle_multihover()
	pass
	
func _player_no_longer_hovers_over_card(card: Card):
	print("player no longer hovers " + str(card))
	for c in range(len(cards_being_hovered)):
		if card == cards_being_hovered[c]:
			cards_being_hovered.remove_at(c)
			break
	card.change_focused(false)
	handle_multihover()
	pass
	
