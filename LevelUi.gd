extends CanvasLayer



var curr_level = null

onready var pause_button = $MarginContainer/HBoxContainer2/HBoxContainer/PauseButton
onready var restart_button = $MarginContainer/HBoxContainer2/HBoxContainer/RestartButton
onready var start_button = $MarginContainer/HBoxContainer2/HBoxContainer/StartButton

onready var speed_button = $MarginContainer/HBoxContainer2/HBoxContainer/GameSpeedButton
onready var next_wave_button = $MarginContainer/HBoxContainer2/HBoxContainer/NextWaveButton

# Called when the node enters the scene tree for the first time.
func _ready():
	pause_button.connect("pressed", self, "pause_pressed")
	restart_button.connect("pressed", self, "restart_pressed")
	start_button.connect("pressed", self, "start_pressed")
	speed_button.connect("pressed", self, "speed_pressed")
	next_wave_button.connect("pressed", self, "next_wave_pressed")

func pause_pressed():
	PauseMenu.toggle_pause()

func next_wave_pressed():
	curr_level.attend_level_ui_message({"type":"next_wave"})

func restart_pressed():
#	emit_signal("message", {"type":"restart"})
	curr_level.attend_level_ui_message({"type":"restart"})

func start_pressed():
#	emit_signal("message", {"type":"start"})
	curr_level.attend_level_ui_message({"type":"start"})

func speed_pressed():
	curr_level.attend_level_ui_message({"type":"game_speed"})

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
