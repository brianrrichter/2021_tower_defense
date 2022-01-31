extends Popup

signal restart()

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


func _ready():
	$HBoxContainer/RestartButton.connect("pressed", self, "restart")
	pass # Replace with function body.

func restart():
	emit_signal("restart")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
