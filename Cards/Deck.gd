extends Node2D
class_name Deck

var suits = [Card.Suits.Hearts, Card.Suits.Diamonds, Card.Suits.Clubs, Card.Suits.Spades]
var values = [Card.Values.Ace, Card.Values.Two, Card.Values.Three, Card.Values.Four, Card.Values.Five, Card.Values.Six, Card.Values.Seven, Card.Values.Eight, Card.Values.Nine, Card.Values.Ten, Card.Values.Jack, Card.Values.Queen, Card.Values.King, ]
enum Defaults { Default52, }

@export var card_template: PackedScene
@export var default: Defaults = Defaults.Default52
var all_cards: Array[Card] = []
var cards: Array[Card] = []
var discards: Array[Card] = []

var random = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	setup_default_deck()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func draw_random() -> Card:
	var idx = random.randi_range(0, len(cards)-1)
	var c = cards[idx]
	cards.remove_at(idx)
	return c


func setup_default_deck():
	if default != null:
		setup_deck(default)
	pass
	
func setup_deck(specific_deck: Defaults):
	cards.clear()
	if specific_deck == Defaults.Default52:
		setup_default52()
	pass

func setup_default52():
	var x = 1
	var y = 1
	for suit in suits:
		for value in values:
			var c  = card_template.instantiate() as Card
			add_child(c)
			c.visible = true
			print("Making: " + str(value) + " of " + str(suit))
			c.set_suit(suit)
			c.set_value(value)
			all_cards.append(c)
			cards.append(c)
			c.position = Vector2(x*15, y*15)
			x += 1
		y += 1
		x = 1
	
