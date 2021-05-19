extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const HurtSound= preload("res://playerHurtSound.tscn")
var velocity =Vector2.ZERO
export var MAX_SPEED=100
export var ACCELERATION=100
export var ROLL_SPEED=100
export var FRICTION=2000
var stats =PlayerStats

var rollVector=Vector2.DOWN

enum{
	MOVE,
	ROLL,
	ATTACK
}
var state=MOVE
onready var animationPlayer=$AnimationPlayer
onready var animationTree=$AnimationTree
onready var animationState=animationTree.get("parameters/playback")
onready var swordHitbox=$Position2D/sword_hitbox
onready var hurtbox =$Hurtbox
onready var blink_player=$BLinkPlayer


func _ready():
	randomize()
	stats.connect("no_health",self,"queue_free")
	animationTree.active=true;
	swordHitbox.knockback_vector=rollVector
# Called when the node enters the scene tree for the first time.
func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)
		ROLL:
			roll_state(delta)
		ATTACK:
			attack_state(delta)
	
	
func move_state(delta):
	var input_vector=Vector2.ZERO
	input_vector.x=Input.get_action_strength("ui_right")-Input.get_action_strength("ui_left")
	input_vector.y=Input.get_action_strength("ui_down")-Input.get_action_strength("ui_up")
	input_vector=input_vector.normalized()

	if input_vector!=Vector2.ZERO:
		rollVector=input_vector
		swordHitbox.knockback_vector=input_vector
		animationTree.set("parameters/idle/blend_position",input_vector)
		animationTree.set("parameters/run/blend_position",input_vector)
		animationTree.set("parameters/attack/blend_position",input_vector)
		animationTree.set("parameters/roll/blend_position",input_vector)
		velocity = velocity.move_toward(input_vector*MAX_SPEED,ACCELERATION*delta)
		velocity+=input_vector*ACCELERATION*delta
		velocity=velocity.clamped(MAX_SPEED)
		animationState.travel("run")
	else:
		velocity = velocity.move_toward(Vector2.ZERO,FRICTION*delta)
		animationState.travel("idle")
		
	move() 
	
	if Input.is_action_just_pressed("attack"):
		state=ATTACK
	if Input.is_action_just_pressed("roll"):
		state=ROLL
	
func roll_state(delta):
	velocity=rollVector*ROLL_SPEED
	animationState.travel("roll")
	move()
	
func attack_state(delta):
	animationState.travel("attack")
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func move():
	velocity= move_and_slide(velocity) 
	
func rollAnimationFinished():
	velocity=velocity/1.1
	state=MOVE
func attack_animation_finished():
	state=MOVE


func _on_Hurtbox_area_entered(area):
	if hurtbox.invincible==false:
		stats.health-=area.damage
		print("ouch")
		hurtbox.start_invinciblity(0.6)
		hurtbox.create_hit_effect()
		var player_hurt=HurtSound.instance()
		get_tree().current_scene.add_child(player_hurt)


func _on_Hurtbox_invince_start():
	blink_player.play("start")


func _on_Hurtbox_invince_end():
	blink_player.play("stop")
