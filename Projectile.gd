extends Area2D


const MOVE_SPEED = 75.0
var max_distance = 100
var direction = Vector2.ONE
var hits_avaiable = 1

func _ready():
	connect("body_entered", self, "_on_body_entered")

func _process(delta):
#	position += Vector2(MOVE_SPEED * delta, 0.0)
	position += direction * MOVE_SPEED * delta
	if position.distance_to(Vector2.ZERO) >= max_distance:
#	if position.x >= SCREEN_WIDTH + 8:
		queue_free()



func _on_body_entered(body):
	body.take_hit()
	hits_avaiable = hits_avaiable -1
	if hits_avaiable <= 0:
		queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
