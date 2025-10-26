extends BaseEnemy

@onready var player: CharacterBody3D = $"../Player"
var isAttack: bool

func _process(delta: float) -> void:
	if vida <= 0:
		die()

func _physics_process(delta: float) -> void:
	if player != null and not isAttack:
		movimiento(delta)
		return

func die() -> void:
	print("☠️ Enemigo eliminado")
	queue_free()

func movimiento(delta: float) -> void:
	var directionTo = player.global_position - global_position
	var direction = (transform.basis * Vector3(directionTo.x, 0, directionTo.z)).normalized()

	if direction:
		velocity = direction * delta * velocidad
	else:
		velocity.x = move_toward(velocity.x, 0, velocidad)
		velocity.z = move_toward(velocity.z, 0, velocidad)

	if not is_on_floor():
		velocity += get_gravity() * delta

	move_and_slide()

func attack(body: Node3D) -> void:
	isAttack = true
	if body.has_method("recivir_ataque"):
		body.recivir_ataque(damage)

func _on_area_attack_body_entered(body: Node3D) -> void:
	if body.name == "Player":
		print("⚔️ Enemigo atacando al jugador")
		attack(body)
		$Timer.start()

func _on_area_attack_body_exited(body: Node3D) -> void:
	if body.name == "Player":
		isAttack = false
		$Timer.stop()

func _on_timer_timeout() -> void:
	if isAttack and player and is_instance_valid(player):
		attack(player)

# 💢 Nueva función estándar para recibir daño:
func recibir_disparo(damage: float) -> void:
	vida -= damage
	print("💢 Enemigo recibió", damage, "de daño. Vida restante:", vida)
	if vida <= 0:
		die()
