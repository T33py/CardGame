extends Node2D
class_name Deck

signal deck_empty

var suits = [Card.Suits.Hearts, Card.Suits.Diamonds, Card.Suits.Clubs, Card.Suits.Spades]
var values = [Card.Values.Ace, Card.Values.Two, Card.Values.Three, Card.Values.Four, Card.Values.Five, Card.Values.Six, Card.Values.Seven, Card.Values.Eight, Card.Values.Nine, Card.Values.Ten, Card.Values.Jack, Card.Values.Queen, Card.Values.King, ]
enum Defaults { Default52, }

@export var card_template: PackedScene
@export var default: Defaults = Defaults.Default52
var all_cards: Array[Card] = []
var cards: Array[Card] = []
var cards_display: CardDisplayArea
var discards: Array[Card] = []
var discards_display:CardDisplayArea

var random = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	cards_display = find_child("DeckDisplayArea", false)
	cards_display.card_distance_modifier = 0
	cards_display.card_distance_offset = 5
	discards_display = find_child("DiscardsDisplayArea", false)
	discards_display.card_distance_modifier = 0
	discards_display.card_distance_offset = 5
	
	setup_default_deck()
	return # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
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
	discards.append(card)
	discards_display.place_card(card)
#	redo_card_positions()
	return true

func add_card(card: Card):
	if card == null:
		return
	all_cards.append(card)
	cards.append(card)
	cards_display.place_card(card)
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
			var card  = card_template.instantiate() as Card
			add_child(card)
			card.global_scale.x = 1
			card.global_scale.y = 1
			print(str(card))
			add_card(card)
			card.visible = true
			print("Making: " + str(value) + " of " + str(suit))
			card.set_suit(suit)
			card.set_value(value)
	return
