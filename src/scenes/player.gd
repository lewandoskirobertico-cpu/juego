extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
var sens := .5
var vida: float = 100
@onready var bullet : PackedScene
@onready var cam = $pivote


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _process(delta: float) -> void:
	if vida <= 0:
		queue_free()
		
func _physics_process(delta: float) -> void:
	movimiento(delta)
	move_and_slide()
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * sens))
		cam.rotate_x(deg_to_rad(-event.relative.y * sens))
		cam.rotation.x = clamp(cam.rotation.x , deg_to_rad(-90), deg_to_rad(45))
func movimiento(delta:float) -> void:

	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("a", "d", "w", "s")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)



func shoot() -> void:
	var bala = bullet.instantiate()
	bala.global_position  = $arma.global_position
	bala.direction = (-transform.basis.z).normalized()
	get_parent().add_child(bala)




func recivir_ataque(damage: float) -> void:
	vida -= damage
