extends Node2D
class_name Deck

signal deck_empty

var suits = [Card.Suits.Hearts, Card.Suits.Diamonds, Card.Suits.Clubs, Card.Suits.Spades]
var values = [Card.Values.Ace, Card.Values.Two, Card.Values.Three, Card.Values.Four, Card.Values.Five, Card.Values.Six, Card.Values.Seven, Card.Values.Eight, Card.Values.Nine, Card.Values.Ten, Card.Values.Jack, Card.Values.Queen, Card.Values.King, ]
enum Defaults { Default52, }

@export var card_template: PackedScene
@export var default: Defaults = Defaults.Default52
var cards_to_set_up = []
var deck_ready = false
var all_cards: Array[Card] = []
var cards: Array[Card] = []
var cards_display: CardDisplayArea
var discards: Array[Card] = []
var discards_display:CardDisplayArea
var do_things_later: DoThingsLater

var currently_picked_up_card: Card = null
var clear_currently_picked_up_card = false
var pickup_clear_next = 0

var random = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	cards_display = find_child("DeckDisplayArea", false)
	cards_display.card_distance_modifier = 0
	cards_display.card_distance_offset = 5
	discards_display = find_child("DiscardsDisplayArea", false)
	discards_display.card_distance_modifier = 0
	discards_display.card_distance_offset = 5
	do_things_later = find_child("DoThingsLater", false)
	
	setup_default_deck()
	return # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# We need to remember the card that the player picked up untill the next frame -
	# - to make shure other things can react to the event that made the card not be picked up this frame
	if clear_currently_picked_up_card:
		if pickup_clear_next > 0:
			pickup_clear_next = 0
		else:
			clear_currently_picked_up_card = false
			currently_picked_up_card = null
		
	return

func draw_random() -> Card:
	if len(cards) == 0:
		deck_empty.emit()
		return null
		
	var idx = random.randi_range(0, len(cards)-1)
	var card = cards[idx]
	cards.remove_at(idx)
	cards_display.remove_card(card)
	return card
	
func discard(card: Card)-> bool:
	if card not in all_cards:
		return false
	print("discarding " + str(card))
	discards.append(card)
	discards_display.place_card(card)
#	redo_card_positions()
	return true

func add_card(card: Card):
	if card == null:
		return
	card.picked_up.connect(on_card_picked_up)
#	card.put_down.connect(on_card_put_down)
	card.put_down.connect(on_card_put_down)
#	print("connected signals of " + str(card))
	all_cards.append(card)
	cards.append(card)
	cards_display.place_card(card)
	return
	
func remove_card(card: Card):
	if card == null:
		return
	
	print("REMOVE " + str(card) + " FROM DECK")
	card.picked_up.disconnect(on_card_picked_up)
	card.put_down.disconnect(on_card_put_down)
	cards_display.remove_card(card)
	remove_from_list(card, all_cards)
	remove_from_list(card, cards)
	return

func on_card_picked_up(card: Card):
	print("on card picked up " + str(card))
	if card == null:
		return
	if currently_picked_up_card == null:
		currently_picked_up_card = card
		clear_currently_picked_up_card = false
		pickup_clear_next = 0
		print("picked up " + str(card))
		return
	
	elif currently_picked_up_card.z_index < card.z_index:
		currently_picked_up_card.end_of_being_dragged()
		currently_picked_up_card = card
		clear_currently_picked_up_card = false
		pickup_clear_next = 0
		print("picked up " + str(currently_picked_up_card))
		
	else:
		card.end_of_being_dragged()
	return

func on_card_put_down(card: Card):
	print("on card put down " + str(card))
	if card == null:
		return
	if card == currently_picked_up_card:
		clear_currently_picked_up_card = true
		pickup_clear_next = 1
	return

func setup_default_deck():
	if default != null:
		setup_deck(default)
	return
	
func setup_deck(specific_deck: Defaults):
	cards.clear()
	if specific_deck == Defaults.Default52:
		setup_default52()
	return

func setup_default52():
	for suit in suits:
		for value in values:
			cards_to_set_up.append([suit, value])
	do_things_later.add_thing_to_do_each_frame(setup_next_playing_card)
	return

func setup_next_playing_card():
	if len(cards_to_set_up) == 0:
		do_things_later.remove_thing_to_do_each_frame(setup_next_playing_card)
		deck_ready = true
		return
	while len(cards_to_set_up) > 0:
		var suit = cards_to_set_up[0][0]
		var value = cards_to_set_up[0][1]
		var card  = card_template.instantiate() as Card
		add_child(card)
		card.global_scale.x = 1
		card.global_scale.y = 1
		card.visible = true
	#			print("Making: " + str(value) + " of " + str(suit))
		card.set_suit(suit)
		card.set_value(value)
		add_card(card)
		cards_to_set_up.remove_at(0)
	return

func remove_from_list(item, list: Array):
	for i in range(len(list)):
		if list[i] == item:
			list.remove_at(i)
			break
	return
