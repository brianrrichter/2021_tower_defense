extends KinematicBody2D

const UNIT_SIZE = 16
var run_speed = 4 * UNIT_SIZE

var goal_pos
var velocity = Vector2()
var path = []
var curr_goal_index = 1
var hp = 2

var curr_level = null

onready var _health_bar = $HealthBar
onready var _animatedSprite = $AnimatedSprite
onready var _collisionShape2D = $CollisionShape2D

signal escaped()

# Called when the node enters the scene tree for the first time.
func _ready():
	
	_health_bar.set_current_health(hp)
	_health_bar.set_max_health(hp)
	
	_animatedSprite.play("default")
	
	
#	goal_pos = path[path.size() -11]
#	print ("path.size: ", path.size())
#	print ("path.size -11: ", path.size() -11)

#	goal_pos = path[curr_goal_index]
#	goal_pos = curr_level.get_path_direction(position)
	
	pass

func set_max_health(value):
	hp = value

func _physics_process(delta):
	
	if position.distance_to(path[curr_goal_index]) < 20 and path.size() -1 > curr_goal_index:
		curr_goal_index = curr_goal_index + 1
#
	var direction = (path[curr_goal_index] - position).normalized()
	
#	var direction = curr_level.get_path_direction(position)
	
	var ang = lerp(_animatedSprite.get_rotation(), direction.angle(), .09)
	
	_animatedSprite.set_rotation(ang)
	_collisionShape2D.set_rotation(ang)
#	rotates helth bar as well, wich is not intended
#	set_rotation(direction.angle())
	
#	velocity = move_and_slide(direction * run_speed, Vector2.ZERO)
	
	velocity = lerp(velocity, direction * run_speed, .1)
	
	velocity = move_and_slide(velocity, Vector2.ZERO)
	
#	velocity.x = lerp(velocity.x, run_speed, .1)
#
#	velocity = move_and_slide(velocity, Vector2.ZERO)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func victory_out():
	emit_signal("escaped")
	queue_free()

func take_hit():
	
	hp = hp -1
	
	_health_bar.set_current_health(hp)
	
	if hp >= 1:
		$AnimatedSprite.set_self_modulate(Color(.7, .9, .7))
	else:
		$AnimatedSprite.set_self_modulate(Color(.9, .2, .2))
		$CollisionShape2D.set_deferred("disabled", true)
		run_speed = 0
		$AudioDead.play()
		yield(get_tree().create_timer(1.0, false), "timeout")
		queue_free()



