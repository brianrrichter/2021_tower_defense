extends Popup

signal next()

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$HBoxContainer/NextButton.connect("pressed", self, "next")
	pass # Replace with function body.

func next():
	emit_signal("next")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
