extends CharacterBody2D
signal hit
signal blood_collected(points: int)
@export var SPEED = 300.0
@export var health = 1.0

var screen_size

func _ready():
	screen_size = get_viewport_rect().size

func _physics_process(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_vector("left", "right", "up", "down")
	if direction:
		velocity.x = direction.x * SPEED
		velocity.y = direction.y * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)
		
	move_and_slide()
	position = position.clamp(Vector2.ZERO, screen_size)
