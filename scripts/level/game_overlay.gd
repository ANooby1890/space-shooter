extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func game_paused():
	self.show()

func _on_quit_button_pressed() -> void:
		get_tree().change_scene_to_file("res://scenes/rooms/main_menu.tscn")
