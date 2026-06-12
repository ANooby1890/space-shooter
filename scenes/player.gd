extends CharacterBody2D

@export var speedY := 400
@export var speedX := 300
@export var godmode := false
	
var gameOver = false

func _ready() -> void:
	pass

# CHANGED: Moved from _process to _physics_process for accurate physics calculations
func _physics_process(delta: float) -> void:
	if not gameOver:
		var direction = Input.get_axis("left", "right")
		
		# 1. Direct assignment to the built-in velocity vector
		velocity = Vector2(direction * speedX, -speedY)
		
		# 2. Move using Godot's standard physics (it handles delta automatically!)
		move_and_slide()

		# Handle visual sprite rotation based on direction, not hardcoded keys ---
		if direction > 0 and $PlayerImage.rotation < 0.2:
			# Moving Right
			$PlayerImage.rotation += 1 * delta
		elif direction < 0 and $PlayerImage.rotation > -0.2:
			# Moving Left
			$PlayerImage.rotation -= 1 * delta
		elif direction == 0:
			# No horizontal input: Return to center
			if $PlayerImage.rotation < 0:
				$PlayerImage.rotation += 1 * delta
				# Prevent overshooting past 0
				if $PlayerImage.rotation > 0: $PlayerImage.rotation = 0
			elif $PlayerImage.rotation > 0:
				$PlayerImage.rotation -= 1 * delta
				# Prevent overshooting past 0
				if $PlayerImage.rotation < 0: $PlayerImage.rotation = 0
				
		# Old move_and_collide check replaced with Godot's slide collision check
		if get_slide_collision_count() > 0 and not godmode:
			var collision_info = get_slide_collision(0) # Get the first collision
			var collider = collision_info.get_collider()
			if collider is Obstacle:
				print("Physics movement hit a obstacle! Object name: ", collider.name)
				gameOver = true
