class_name BaseEnemy
extends CharacterBody3D

@export_category("Atributos")
@export var vida :int
@export var damage :float
@export var velocidad:float


func movimiento(delta:float) -> void:
	pass
	
	
func die() -> void:
	pass
	
func attack(body:CharacterBody3D) -> void:
	pass

func recivir_ataque(damage: float) -> void:
	vida -= damage
