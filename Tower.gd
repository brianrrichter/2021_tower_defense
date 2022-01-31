extends "res://TowerBase.gd"

#extends Area2D
#
#var projectile_scn = preload("res://Projectile.tscn")
#
#var shoot_timer
#
## Declare member variables here. Examples:
## var a = 2
## var b = "text"
#
#
## Called when the node enters the scene tree for the first time.
#func _ready():
#
#	shoot_timer = Timer.new()
#	shoot_timer.connect("timeout", self, "_on_shoot_timer_timeout")
##	shoot_timer.set_autostart(false)
##	shoot_timer.wait_time = 5
##	shoot_timer.one_shot = false
#
#	add_child(shoot_timer)
#	shoot_timer.start(1.5)
#
#
#	pass # Replace with function body.
#
#func _on_shoot_timer_timeout():
#	var num_sprites = 8
#
#	$AudioShot.play()
#
#	for i in range(num_sprites):
#		var p = projectile_scn.instance()
#		p.direction = Vector2(0, 1).rotated((2 * PI) / num_sprites * i)
#		add_child(p)
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
##func _process(delta):
##	pass
