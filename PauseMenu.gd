extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS
	$Control.visible = false
	
	$Control/HBoxContainer/UnpauseButton.connect("pressed", self, "toggle_pause")
	
	$Control/HBoxContainer/MapScreenButton.connect("pressed", self, "map")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _input(event):
	if event is InputEventKey and event.is_pressed() and Input.is_key_pressed(KEY_F12) and !event.is_echo():
		toggle_pause()

func map():
	get_tree().change_scene("res://MapScreen.tscn")
	toggle_pause()

func toggle_pause():
	var to_be_paused = !get_tree().paused
	get_tree().paused = to_be_paused
	$Control.visible = to_be_paused
	if to_be_paused:
		$Control/HBoxContainer/UnpauseButton.grab_focus()
