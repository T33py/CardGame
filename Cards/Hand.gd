extends Node2D
class_name Hand

var display_area: CardDisplayArea

@export var deck: Deck
@export var play_area: PlayArea
@export var base_handsize = 7
@export var selected_card_y_offset = 100
var cards: Array[Card] = []
var cards_being_hovered: Array[Card] = []
var selected_card: Card = null

var draw_card = false

# Called when the node enters the scene tree for the first time.
func _ready():
	display_area = find_child("DisplayArea", false)
	return # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if draw_card:
		draw_random_card()
	if len(display_area.cards) < base_handsize:
		draw_card = true
	return
	
func draw_random_card():
	if deck != null:
		if len(deck.cards) == 0:
			return
		var card: Card = deck.draw_random()
		cards.append(card)
		display_area.place_card(card)
		card.mouse_hovers.connect(_player_hovers_over_card)
		card.mouse_stopped_hovering.connect(_player_no_longer_hovers_over_card)
		card.card_clicked.connect(_select_card)
		
	draw_card = false
	return

# handles the "card clicked" signal
func _select_card(card: Card):
	print("select " + str(card))
	if selected_card == null:
		selected_card = card
		print("selected " + str(card))
		card.position.y -= selected_card_y_offset
		return
	
	if not card.in_focus:
		return
		
	if selected_card != card:
		selected_card.position.y += selected_card_y_offset
		selected_card = card
		card.position.y -= selected_card_y_offset
		return
		
	if selected_card == card:
		print(str(selected_card) + " no longer selected")
		selected_card = null
		card.position.y += selected_card_y_offset
		return
	
	pass

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
#	print("player hovers " + str(card))
	if card not in cards_being_hovered:
		cards_being_hovered.append(card)
	handle_multihover()
	return
	
func _player_no_longer_hovers_over_card(card: Card):
#	print("player no longer hovers " + str(card))
	for c in range(len(cards_being_hovered)):
		if card == cards_being_hovered[c]:
			cards_being_hovered.remove_at(c)
			break
	card.change_focused(false)
	handle_multihover()
	return
	


func _on_play_card_button_pressed():
	play_card()
	return # Replace with function body.


func _on_discard_card_button_pressed():
	discard_card()
	return # Replace with function body.

	
func play_card(card: Card = null):
	if card == null:
		card = selected_card
	if card == null:
		return false
#	print("Play card from hand")
#	print("  " + str(card))
		
	if play_area.play_card(card):
		selected_card = null
		disconnect_card(card)
		return true
	return false

func discard_card(card: Card = null):
	if card == null:
		card = selected_card
	if card == null:
		return
	print("discard card from hand")
	print("  " + str(card))
		
	if deck.discard(card):
		selected_card = null
		disconnect_card(card)
	return
	
func disconnect_card(card: Card):
	for c in range(len(cards)):
		if cards[c] == card:
			cards.remove_at(c)
			break
	for c in range(len(cards_being_hovered)):
		if cards[c] == card:
			cards.remove_at(c)
			break
	card.disconnect("mouse_hovers", _player_hovers_over_card)
	card.disconnect("mouse_stopped_hovering", _player_no_longer_hovers_over_card)
	card.disconnect("card_clicked", _select_card)
	display_area.remove_card(card)
	return
