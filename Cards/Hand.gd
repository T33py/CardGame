extends Node2D
class_name Hand

@export var current_deck: Deck
var cards: Array[Card] = []

var display_area: CardDisplayArea

var draw_card = false

# Called when the node enters the scene tree for the first time.
func _ready():
	display_area = find_child("DisplayArea", false)
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if draw_card:
		draw_random_card()
	if len(display_area.cards) < 2:
		draw_card = true
	pass
	
func draw_random_card():
	if current_deck != null:
		var card = current_deck.draw_random()
		cards.append(card)
		display_area.place_card(card)
		
	draw_card = false
