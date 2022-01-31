extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$HBoxContainer/Lvl1Button.connect("pressed", self, "go_to_lvl")
	$HBoxContainer/Lvl2Button.connect("pressed", self, "go_to_lvl2")


func go_to_lvl():
	Globals.current_level = 1
	get_tree().change_scene("res://Main.tscn")

func go_to_lvl2():
	Globals.current_level = 2
	get_tree().change_scene("res://Main.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
