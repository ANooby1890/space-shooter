extends Camera2D

@export var player: CharacterBody2D

func _physics_process(_delta):
	if player:
		# Only set the Y position to the player's Y position
		# X is left completely independent
		global_position.y = player.global_position.y
		
