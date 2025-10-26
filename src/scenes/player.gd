extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
var sens := 0.5
var vida: float = 100
var target: Node3D = null
var shoot_interval := 0.5 # segundos entre disparos

@onready var bullet: PackedScene = preload("res://src/scenes/bullet.tscn")
@onready var cam = $pivote
@onready var arma = $arma
@onready var area = $AreaDeteccion
@onready var shoot_timer = Timer.new()

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	add_child(shoot_timer)
	shoot_timer.wait_time = shoot_interval

	# Conectamos señales
	shoot_timer.timeout.connect(_on_timer_timeout)

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
		cam.rotation.x = clamp(cam.rotation.x, deg_to_rad(-90), deg_to_rad(45))

func movimiento(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var input_dir := Input.get_vector("a", "d", "w", "s")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

func shoot() -> void:
	if target == null or not is_instance_valid(target):
		return
	var bala = bullet.instantiate()
	bala.global_position = arma.global_position
	bala.direction = (target.global_position - arma.global_position).normalized()
	get_parent().add_child(bala)
	print("💥 Disparo generado en: ", arma.global_position)

func recibir_daño(damage: float) -> void:
	vida -= damage
	print("🩸 Jugador recibió", damage, "de daño. Vida restante:", vida)

# --- Señales ---


func _on_area_deteccion_body_entered(body: Node3D) -> void:
	if body.is_in_group("enemy"):
		print("🎯 Enemigo detectado:", body.name)
		target = body
		shoot_timer.start()
		
func _on_area_deteccion_body_exited(body: Node3D) -> void:
	if body == target:
		target = null
		shoot_timer.stop()

func _on_timer_timeout() -> void:
	print("⏱ Timer disparando")
	if target != null and is_instance_valid(target):
		shoot()
	else:
		shoot_timer.stop()
