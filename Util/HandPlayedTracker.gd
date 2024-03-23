extends Node2D

@export var play_area: PlayArea

var time_between_updates = 0.5
var time_since_update = 0

var text: RichTextLabel


# Called when the node enters the scene tree for the first time.
func _ready():
	text = find_child("RichTextLabel")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time_since_update += delta
	if time_since_update > time_between_updates:
		update_text(figure_out_played_hand())
		time_since_update = 0
	pass


func update_text(to):
	text.text = to
	pass
	
func figure_out_played_hand():
	var hand = ""
	if len(play_area.cards) == 0:
		return hand
	
	# count the cards things
	var suit_count = {}
	var rank_count = {}
	for card in play_area.cards:
		if card.my_suit in suit_count:
			suit_count[card.my_suit] += 1
		else:
			suit_count[card.my_suit] = 1
		if card.my_value in rank_count:
			rank_count[card.my_value] += 1
		else:
			rank_count[card.my_value] = 1
	
#	print(rank_count)
	for rank in rank_count:
		if rank_count[rank] == 2:
			hand = "pair of " + play_area.cards[0].patterns[rank] + "s"
	
	return hand
