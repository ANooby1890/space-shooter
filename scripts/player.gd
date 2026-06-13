extends CharacterBody2D

@onready var spawn_position: Vector2 = global_position
@export var speedY := 400
@export var speedX := 300
@export var godmode := false
	
var dead = false

func _ready() -> void:
	pass

# CHANGED: Moved from _process to _physics_process for accurate physics calculations
func _physics_process(delta: float) -> void:
	if not dead:
		var direction = Input.get_axis("left", "right")
		
		# 1. Direct assignment to the built-in velocity vector
		velocity = Vector2(direction * speedX, -speedY)
		
		# 2. Move using Godot's standard physics (it handles delta automatically!)
		move_and_slide()

		# Handle visual sprite rotation based on direction, not hardcoded keys ---
		if direction > 0 and $PlayerSprite.rotation < 0.2:
			# Moving Right
			$PlayerSprite.rotation += 1 * delta
		elif direction < 0 and $PlayerSprite.rotation > -0.2:
			# Moving Left
			$PlayerSprite.rotation -= 1 * delta
		elif direction == 0:
			# No horizontal input: Return to center
			if $PlayerSprite.rotation < 0:
				$PlayerSprite.rotation += 1 * delta
				# Prevent overshooting past 0
				if $PlayerSprite.rotation > 0: $PlayerSprite.rotation = 0
			elif $PlayerSprite.rotation > 0:
				$PlayerSprite.rotation -= 1 * delta
				# Prevent overshooting past 0
				if $PlayerSprite.rotation < 0: $PlayerSprite.rotation = 0
				
		# Old move_and_collide check replaced with Godot's slide collision check
		if get_slide_collision_count() > 0 and not godmode:
			var collision_info = get_slide_collision(0) # Get the first collision
			var collider = collision_info.get_collider()
			if collider is Obstacle:
				print("Physics movement hit a obstacle! Object name: ", collider.name)
				dead = true
				get_node("../GameOverlay").game_paused()
