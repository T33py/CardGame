extends Sprite2D
class_name CardDisplayArea


var cards: Array[Card] = []
var card_distance_modifier = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func place_card(card: Card):
	print("move card to display area")
	card.reparent(get_parent())
	cards.append(card)
	layout_cards()
	pass
	
func remove_card(card: Card):
	for i in range(len(cards)):
		if cards[i] == card:
			cards.remove_at(i)
			break
	layout_cards()
	pass

func layout_cards():
	var segments = len(cards)
	
	# if its trivial to organize
	if segments == 0:
		return
#	if segments == 1:
#		cards[0].position = self.position
#		return
	
	var width = texture.get_width()
	var left_border = position.x - (width / 2)
	var dist = texture.get_width()
	var interval = dist / segments
	
	for i in range(segments):
		var card = cards[i]
		var target_height = texture.get_height() * scale.y * 1.05
		var card_height = card.get_height()
		card.scale *= target_height / card_height
		
		
		var offset = left_border + ((interval * i+1 + interval * 0.5) * card_distance_modifier)
		card.position = Vector2(offset, position.y)
		
		
	pass
