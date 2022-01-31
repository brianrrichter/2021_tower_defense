extends Node2D

var entity_scn = preload("res://Entity.tscn")
var entity2_scn = preload("res://Entity2.tscn")
var tower_scn = preload("res://Tower.tscn")
var tower2_scn = preload("res://Tower2.tscn")
var won_scn = preload("res://PopupWon.tscn")
var lose_scn = preload("res://PopupLose.tscn")

enum {PRE_START, RUNNING, LOST_RUN, WON_RUN}

var game_state = PRE_START

var path = []

var escaped_count = 0
var max_escaped = 10

var wave_counter = 0
var last_wave = 5
var coins = 300

var towers_positions = {}

var placeIndicator = null

onready var bar_tower_buttons = ButtonGroup.new()

onready var tile_map = $Navigation2D/TileMap
onready var entities = $Entities
onready var towers = $Towers
onready var nextWaveTimer = $NextWaveTimer

var game_structure = null

#0,1,2
var lvl1 = null
#[
#			[2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2],
#			[2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2],
#			[2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2],
#			[2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2],
#			[2,2,2,2,2,2,0,0,0,0,2,2,2,2,2,2,2,2,2,2],
#			[2,2,2,2,2,2,0,1,1,0,2,2,2,2,2,2,2,2,2,2],
#			[2,2,2,3,0,0,0,2,2,0,1,2,2,2,2,2,2,2,2,2],
#			[2,2,2,2,2,1,1,2,2,0,0,0,4,2,2,2,2,2,2,2],
#			[2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2],
#			[2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2],
#			[2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2],
#			[2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2],
#			]

var lvl2 = null
#[
#			[2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2],
#			[2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2],
#			[2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2],
#			[2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2],
#			[2,2,2,2,2,2,2,2,2,4,0,0,2,2,2,2,2,2,2,2],
#			[2,2,2,2,2,2,2,2,2,2,1,0,1,2,2,2,2,2,2,2],
#			[2,2,2,2,2,2,2,3,0,0,1,0,1,2,2,2,2,2,2,2],
#			[2,2,2,2,2,2,2,2,2,0,0,0,2,2,2,2,2,2,2,2],
#			[2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2],
#			[2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2],
#			[2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2],
#			[2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2],
#			]

# Called when the node enters the scene tree for the first time.
func _ready():
	
	$CanvasLayer.curr_level = self
	
	AudioServer.set_bus_mute(0, true)
	
	game_structure = load_from_file("res://definitions/game_structure.json");
	
	print("wwwwwwwwwww world name:", game_structure["worlds"][0]["name"])
	
	print("wwwwwwwwwww level name:",game_structure["worlds"][0]["levels"][0]["name"])
	
	lvl1 = game_structure["worlds"][0]["levels"][0]["map"]
	lvl2 = game_structure["worlds"][0]["levels"][1]["map"]
	
#	for uc in tile_map.get_used_cells():

	tile_map.clear()
	
	var lvl = lvl1
	
	if (Globals.current_level == 2):
		lvl = lvl2
	
	for i in lvl.size():
		var rows = lvl[i]
		for j in rows.size():
			var c = rows[j]
			#x, y
			tile_map.set_cellv(Vector2(j, i), c)
			if c == 3:
				$Spawn.position = tile_map.map_to_world(Vector2(j, i)) + Vector2(32, 32)
			elif c == 4:
				$Goal.position = tile_map.map_to_world(Vector2(j, i)) + Vector2(32, 32)
	
#	tile_map.set_cellv(Vector2(6,5), 0)
	tile_map.update_dirty_quadrants()
	
	
	path = $Navigation2D.get_simple_path($Spawn.position, $Goal.position, false)
	
	path.append($Goal.position)
	
	print("path: ", path)
	
	
	
	$CanvasLayer/MarginContainer/HBoxContainer2/ButtonsContainer/T1Button.group = bar_tower_buttons
	$CanvasLayer/MarginContainer/HBoxContainer2/ButtonsContainer/T2Button.group = bar_tower_buttons
	
#	var t2_texture = load("res://images/tower.png")
#	$CanvasLayer/MarginContainer/HBoxContainer2/ButtonsContainer/T2Button.set_pressed_texture(t2_texture)
	
	for b in $CanvasLayer/MarginContainer/HBoxContainer2/ButtonsContainer.get_children():
		b.connect("pressed", self, "button_pressed", [b])
		b.connect("toggled", self, "button_toggled", [b])
	
#	var b = $CanvasLayer/MarginContainer/HBoxContainer2/HBoxContainer/RestartButton
#	b.connect("pressed", self, "button_pressed", [b])
	
#	$CanvasLayer.connect("message", self, "attend_level_ui_message")
	
	
	nextWaveTimer.connect("timeout", self, "next_wave")
	
	game_state = PRE_START

func load_from_file(__path):
	
	var file = File.new()
	
	if !file.file_exists(__path):
		print("file don't exists: ", __path)
		return
	
	file.open(__path, File.READ)
	var text = file.get_as_text()
	
	return parse_json(text)

func attend_level_ui_message(params):
	if params.type == "restart":
		restart()
	if params.type == "start":
		start()
	if params.type == "game_speed":
		change_game_speed()
	if params.type == "next_wave":
		next_wave()

func button_toggled(pressed, button):
	print("button toggled")
	if pressed:
		button.set_self_modulate(Color(.5, .5, .5))
	else:
		button.set_self_modulate(Color(1, 1, 1))

func button_pressed(button):
	
	print("button clicked", button.name)
	
	if button.name == "T1Button" :
		release_place_indicator()
		if placeIndicator == null:
			placeIndicator = Sprite.new()
			placeIndicator.name = "t1_indicator"
			placeIndicator.texture = load("res://images/tower.png")
			placeIndicator.position = Vector2(50, 50)
			add_child(placeIndicator)
	elif button.name == "T2Button" :
		release_place_indicator()
		if placeIndicator == null:
			placeIndicator = Sprite.new()
			placeIndicator.name = "t2_indicator"
			placeIndicator.texture = load("res://images/tower2.png")
			placeIndicator.position = Vector2(50, 50)
			add_child(placeIndicator)
	elif button.name == "NextWaveButton" :
		next_wave()
	elif button.name == "GameSpeedButton":
		change_game_speed()

func change_game_speed():
	if Engine.time_scale < 2:
		Engine.time_scale = 2.0
#		button.text = ">> (2x)"
	elif Engine.time_scale < 4:
		Engine.time_scale = 4.0
#		button.text = ">> (4x)"
	else:
		Engine.time_scale = 1
#		button.text = ">> (1x)"

func start():
	game_state = RUNNING
	next_wave()

func restart():
	get_tree().reload_current_scene()

func next_wave():
	if (entities.get_child_count() > 0):
		return
	if game_state != RUNNING:
		return
	
	if wave_counter >= last_wave:
		#ultima wave já foi vencida
		return
	if !nextWaveTimer.is_stopped():
		nextWaveTimer.stop()
	$CanvasLayer/TimerContiner.hide()
	wave_counter = wave_counter + 1
	$CanvasLayer/HBoxContainer/currWaveValueLabel.text = str(wave_counter, "/", last_wave)
	
	for i in range(0,10):
		
		var e = null
		if i < 8:
			e = entity_scn.instance()
			e.set_max_health(wave_counter)
		else:
			e = entity2_scn.instance()
			e.set_max_health(wave_counter * 2)
			e.run_speed = e.run_speed * 1.2
		e.position = $Spawn.position
		e.goal_pos = $Goal.position
		e.path = path
		e.curr_level = self
		e.connect("escaped", self, "_entity_escaped")
		entities.add_child(e)
		yield(get_tree().create_timer(1.0, false), "timeout")

func get_path_direction(pos):
	return $Path2D.curve.get_closest_offset(pos)
#	return $Goal.position;

func _entity_escaped():
	escaped_count = escaped_count + 1
	$CanvasLayer/HBoxContainer/countValueLabel.text = str(escaped_count)

func _input(event):
	if event is InputEventKey and event.scancode == KEY_ESCAPE and event.pressed:
		release_place_indicator(true)

func release_place_indicator(release_button = false):
	if placeIndicator != null:
		placeIndicator.queue_free()
		placeIndicator = null
		if release_button && bar_tower_buttons.get_pressed_button() != null:
			bar_tower_buttons.get_pressed_button().pressed = false

func _unhandled_input(event):
	if event is InputEventMouseButton and !event.is_pressed():
		if event.button_index == BUTTON_LEFT:
			if bar_tower_buttons.get_pressed_button() == null:
				return
			
			if coins < 100:
				return
			
			var map_pos = tile_map.world_to_map(event.position)
			print("position: ", map_pos)
			
			if map_pos in towers_positions:
				return
			
			if tile_map.get_cellv(map_pos) != 1:
				return
			
			var t = null
			
			if placeIndicator.name == "t1_indicator":
				t = tower_scn.instance()
			elif placeIndicator.name == "t2_indicator":
				t = tower2_scn.instance()
	#		t.position = event.position
			t.position = tile_map.map_to_world(map_pos) + Vector2(32, 32)
			
			towers_positions[map_pos] = t
			
			$Towers.add_child(t)
			coins = coins - 100
		elif event.button_index == BUTTON_RIGHT:
			release_place_indicator(true)

func _process(delta):
#	path = get_simple_path(start_point, end_point, false)
	if placeIndicator != null:
		var map_pos = tile_map.world_to_map(get_viewport().get_mouse_position())
		if coins >= 100 \
				and !(map_pos in towers_positions) and tile_map.get_cellv(map_pos) == 1:
			placeIndicator.set_self_modulate(Color(.5, 1, .5))
			placeIndicator.position = tile_map.map_to_world(map_pos) + Vector2(32, 32)
		else:
			placeIndicator.set_self_modulate(Color(.9, .2, .2))
			placeIndicator.position = get_viewport().get_mouse_position()
	
	if game_state == RUNNING && escaped_count >= max_escaped:
		game_state = LOST_RUN
		for t in $Towers.get_children():
			t.queue_free()
#		$CanvasLayer/HBoxContainer/currWaveValueLabel.text = "Perdeu!"
		var loseScreen = lose_scn.instance()
		add_child(loseScreen)
		loseScreen.popup_centered_ratio(0.5)
		loseScreen.connect("restart", self, "restart")
	
	if game_state == RUNNING and entities.get_child_count() <= 0:
		if nextWaveTimer.is_stopped():
			if wave_counter >= last_wave:
#				$CanvasLayer/HBoxContainer/currWaveValueLabel.text = "Venceu!"
				game_state = WON_RUN
				Globals.current_level = Globals.current_level + 1
				var wonScreen = won_scn.instance()
				add_child(wonScreen)
				wonScreen.popup_centered_ratio(0.5)
				wonScreen.connect("next", self, "go_next_scene")
#				get_tree().change_scene("res://Main.tscn")
			else:
				coins = coins + 100
				nextWaveTimer.start()
				$CanvasLayer/TimerContiner.show()

		
	
	if !nextWaveTimer.is_stopped():
		$CanvasLayer/TimerContiner/TimerValueLabel.text = str("%1.1f" % nextWaveTimer.time_left)
	
	$CanvasLayer/HBoxContainer/coinValueLabel.text = str(coins)
#	update() #for draw

func go_next_scene():
	get_tree().change_scene("res://Main.tscn")


#func _draw():
#	draw_circle($Spawn.position, 50, Color(1,1,1))
#	draw_circle($Goal.position, 50, Color(1,1,1))
#
#	if path.size() > 2:
#		for point in path:
#			draw_circle(point, 10, Color(1,1,1))
#		draw_polyline(path, Color(1,0,0), 3.0, true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
