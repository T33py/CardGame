extends Sprite2D
class_name CardDisplayArea

var cards: Array[Card] = []
var card_distance_modifier = 1
var card_distance_offset = 0
var phantom_card = false
var phantom_card_pos = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func place_card(card: Card):
	if phantom_card:
		cards.insert(phantom_card_pos, card)
		remove_phantom_card()
	else:
		cards.append(card)
	layout_cards()
	pass
	
func remove_card(card: Card):
	remove_phantom_card()
	remove_from_list(card, cards)
	layout_cards()
	pass
	
func add_phantom_card(pos: int):
	phantom_card = true
	phantom_card_pos = pos
	layout_cards()
	return
	
func remove_phantom_card():
	if not phantom_card:
		return
	phantom_card = false
	layout_cards()
	return

func layout_cards():
	var segments = len(cards)
	
	# if its trivial to organize
	if segments == 0:
		return
	
	if phantom_card:
		segments += 1
	
	var width = texture.get_width() * global_scale.x
	var left_border = global_position.x - (width / 2)
	var interval = width / segments
	var target_height = texture.get_height() * global_scale.y * 1.05
	
	for i in range(segments):
		# handle phantom card
		var c = i
		if phantom_card:
			if c == phantom_card_pos:
				continue
			if c >= phantom_card_pos:
				c -= 1
		
		# move the card to its display position
		var card = cards[c]
		card.z_index = z_index + 1 + i
		var card_height = card.get_height() * card.global_scale.y
		card.scale *= target_height / card_height
		if card.in_focus:
			card.change_focused(true)
		
		# place card at left border in the middle of its interval at interval 'i'
		var offset = left_border + ((interval * 0.5 + interval * i) * card_distance_modifier) + (card_distance_offset * i)
		card.global_position = Vector2(offset, global_position.y)
		
	return

func remove_from_list(item, list: Array):
	for i in range(len(list)):
		if list[i] == item:
			list.remove_at(i)
			break
	return
