extends Node2D
class_name Player

@export var deck: Deck
@export var hand: Hand
@export var playarea: PlayArea

# Called when the node enters the scene tree for the first time.
func _ready():
	playarea.lmb_up.connect(on_playarea_lmb_up)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func on_playarea_lmb_up():
	var card = deck.currently_picked_up_card
	print("try to play " + str(card))
	if card == null:
		return
	if card not in hand.cards:
		return
	
	card.end_of_being_dragged()	
	hand.play_card(card)
	return
