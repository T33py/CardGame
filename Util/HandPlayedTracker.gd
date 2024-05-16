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
	var card_count = len(play_area.cards)
	if card_count == 0:
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
	
	var found_pair = false
	var pair_of = ""
	var found_triple = false
	var triple_of = ""
	var found_four = false
	for rank in rank_count:
		if rank_count[rank] == 2:
			if found_pair:
				hand = "two pair"
			else:
				pair_of = play_area.cards[0].patterns[rank] + "s"
				hand = "pair of " + pair_of
				found_pair = true
		if rank_count[rank] == 3:
			triple_of = play_area.cards[0].patterns[rank] + "s"
			hand = "three of " + triple_of
			found_triple = true
		if rank_count[rank] == 4:
			hand = "four of " + play_area.cards[0].patterns[rank] + "s"
			found_four = true
		
		
	var straight = false
	if len(rank_count) == 5:
		var ordered = rank_count.keys()
		ordered.sort()
		print("ordered hand " + str(ordered))
		if (ordered[1] - ordered[0] == 1 or (ordered[0] == 0 and ordered[4] == 13)or (ordered[0] == 0 and ordered[1] == 2)) and ordered[2] - ordered[1] == 1 and ordered[3] - ordered[2] == 1 and ordered[4] - ordered[3] == 1:
			straight = true
			hand = "straight"
			
	var flush = false
	if len(suit_count) == 1 and card_count == 5:
		flush = true
		hand = "flush"
	
	if found_pair && found_triple:
		hand = "house - " + triple_of + " full of " + pair_of
	
	if straight and flush:
		hand = "straight flush"
	
	
	return hand
