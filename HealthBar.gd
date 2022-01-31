extends Control


onready var bar = $Bar


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_current_health(value):
	bar.value = value

func set_max_health(value):
	bar.max_value = value


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
