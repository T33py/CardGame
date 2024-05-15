extends Node2D

@export var ai: BasicAI
@export var player_play_area: PlayArea
@export var ai_play_area: PlayArea

@export var hand_clear_delay: float = 1
var hand_clear_timer = 0

var ai_stands = false
var player_stands = false


# Called when the node enters the scene tree for the first time.
func _ready():
	player_play_area.card_played.connect(_on_player_played_card)
	player_play_area.end_turn.connect(_on_player_stands)
	ai_play_area.card_played.connect(_on_ai_played_card)
	ai.i_stand.connect(_on_ai_stands)
	return 


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if ai_stands && player_stands:
		ai.play_a_hand()
		hand_clear_timer += delta
		if hand_clear_timer >= hand_clear_delay:
			hand_clear_timer = 0
			player_play_area.clear()
			ai_play_area.clear()
			player_stands = false
			ai.standing = false
			ai_stands = false
		
	if player_stands:
		ai.take_a_turn()
	return


func _on_player_played_card():
	if ai_stands:
		return
	print("ai should play a card")
	ai.take_a_turn()
	return

func _on_player_stands(cards: Array[Card]):
	player_stands = true
	return

func _on_ai_played_card():
	# TODO
	return

func _on_ai_stands():
	print("ai stands")
	ai_stands = true
	return
