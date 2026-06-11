extends CharacterBody2D

@export var speedY := 400
@export var speedX := 300
var borderWidth = 10
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
	
		# Get the size of the game window screen
		var screen_size = get_viewport_rect().size
		
		# Clamp X coordinate between 0 and screen width
		position.x = clamp(position.x, -(screen_size.x)/2 + borderWidth, (screen_size.x)/2 - borderWidth)
		
		# Handle visual sprite rotation based on key inputs
		if Input.is_key_pressed(KEY_RIGHT) and $PlayerImage.rotation < 0.2:
			$PlayerImage.rotation += 1 * delta
		elif Input.is_key_pressed(KEY_LEFT) and $PlayerImage.rotation > -0.2:
			$PlayerImage.rotation -= 1 * delta
		else:
			if $PlayerImage.rotation < 0:
				$PlayerImage.rotation += 1 * delta
			elif $PlayerImage.rotation > 0:
				$PlayerImage.rotation -= 1 * delta
				
		# Old move_and_collide check replaced with Godot's slide collision check
		if get_slide_collision_count() > 0:
			var collision_info = get_slide_collision(0) # Get the first collision
			var collider = collision_info.get_collider()
			if collider is Crashable:
				print("Physics movement hit a wall! Object name: ", collider.name)
				gameOver = true
