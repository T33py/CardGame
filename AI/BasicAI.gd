extends Node2D
class_name BasicAI

signal i_stand

@export var deck: Deck
@export var hand: Hand
@export var play_area: PlayArea

var standing = false

# Called when the node enters the scene tree for the first time.
func _ready():
	return 


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	return


func play_a_card():
	return hand.play_card(hand.cards.pick_random())

func play_a_hand():
	play_area.play_hand()
	return

func take_a_turn():
	if standing:
		return
	
	if len(hand.cards) == 0:
		stand()
	
	if len(play_area.cards) < play_area.number_of_cards_to_allow:
		play_a_card()
	else:
		stand()
	return

func stand():
	print("I STAND")
	standing = true
	i_stand.emit()
	
