extends BaseEnemy

@onready var player: CharacterBody3D = $"../Player"
var isAttack: bool


func _process(delta: float) -> void:
	if vida <= 0:
		die()


func _physics_process(delta: float) -> void:
		if player != null && !isAttack:
			movimiento(delta)
			return

func die() -> void:
	queue_free()
func movimiento(delta:float) -> void:
	
	var directionTo = player.global_position - global_position
	var direction = (transform.basis * Vector3(directionTo.x , 0 , directionTo.z)).normalized()


	if direction:
		velocity = direction * delta * velocidad 
	else: 
		velocity.x = move_toward(velocity.x, 0, velocidad)
		velocity.z = move_toward(velocity.z, 0, velocidad)

	if not is_on_floor():
		velocity += get_gravity() * delta
		
	move_and_slide()

#### funciones para que te persigan en un area de vision los enemigos
#func _on_area_3d_body_entered(body: Node3D) -> void:
	#if body.name == "Player":
		#player = body


#func _on_area_3d_body_exited(body: Node3D) -> void:
	#if body.name == "Player":
		#player = null

func attack(body) -> void:
	isAttack = true
	body.recivir_ataque(damage)
	
"""funcion para activar el ataque"""
func _on_area_attack_body_entered(body: Node3D) -> void:
	if body.name == "Player":
		attack(body)
		$Timer.start()


func _on_area_attack_body_exited(body: Node3D) -> void:
	if body.name == "Player":
			isAttack = false
			$Timer.stop()


func _on_timer_timeout() -> void:
	if isAttack:
		attack(player)
