extends CharacterBody3D

@export var speed: float = 3.0
@export var float_speed: float = 3.0
@export var float_height: float = 0.2
@export var flap_strength: float = 0.2

@onready var player = get_tree().get_first_node_in_group("player")
@onready var anim: AnimationPlayer = $bat_model/Armature/AnimationPlayer
@onready var bat_model: Node3D = $bat_model
@onready var armature: Node3D = $bat_model/Armature

var float_timer: float = 0.0
var original_position: Vector3

func _ready():
	original_position = bat_model.position
	if anim and anim.has_animation("Idle"):
		anim.play("Idle")

func _physics_process(delta):
	if not player:
		return

	# ✅ Floating effect
	float_timer += delta
	var new_y = original_position.y + sin(float_timer * float_speed) * float_height
	bat_model.position.y = new_y

	# ✅ Wing flapping (rotate armature)
	armature.rotation.z = sin(float_timer * 12.0) * flap_strength

	# ✅ Movement toward player
	var direction = (player.global_transform.origin - global_transform.origin).normalized()
	velocity = direction * speed
	move_and_slide()

	# ✅ Rotate bat to face the player
	look_at(player.global_transform.origin, Vector3.UP)
