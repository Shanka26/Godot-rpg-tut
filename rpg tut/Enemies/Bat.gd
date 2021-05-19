extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var knockBack=Vector2.ZERO
onready var stats =$Stats 
onready var playerDetectionZone=$PlayerDetectionZone
export var friction=200
export var acceleration=90
export var maxSpeed=150
const EnemyDeathEffect=preload("res://Effects/enemy_death_effect.tscn")
var velocity=Vector2.ZERO
onready var sprite=$AnimatedSprite
onready var hurtbox=$Hurtbox
onready var soft_collision =$SoftCollision
onready var wander_controller= $WanderController
onready var animationPlayer = $AnimationPlayer
export (int) var target_brake=5
enum{
	IDLE,
	WANDER,
	CHASE 
}

var state = IDLE



func _physics_process(delta):
	knockBack=knockBack.move_toward(Vector2.ZERO,200*delta)
	knockBack=move_and_slide(knockBack)
	
	match state:
		IDLE:
			
			velocity=velocity.move_toward(Vector2.ZERO,friction*delta)
			seek_player()
			if wander_controller.get_time_left()==0:
				reset()
		WANDER:
			
			seek_player()
			if wander_controller.get_time_left()==0:
				reset()
				
			accelerate_to(wander_controller.target_position,delta)
				
			if global_position.distance_to(wander_controller.target_position)<=target_brake:
				reset()
					
		CHASE:
			
			var player = playerDetectionZone.player
			if player!=null:
				accelerate_to(player.global_position,delta)
			else:
				state=IDLE
				
			
						
	if soft_collision.is_colliding():
		velocity+=soft_collision.get_push_vector()*delta*300
	
	velocity=move_and_slide(velocity)
func reset():
	state = random_state([IDLE,WANDER])
	wander_controller.start_timer(rand_range(2,4))
func seek_player():
	if playerDetectionZone.can_see_player():
			print("seeeeeeeeee")
			state=CHASE
	print(stats.health)
func accelerate_to(position,delta):
	var direction =global_position.direction_to(position)
	velocity=velocity.move_toward(direction*maxSpeed ,acceleration*delta)
	sprite.flip_h=velocity.x <0

func random_state(state_list):
	state_list.shuffle()
	print("random")
	print(state_list.pop_front())
	return state_list.pop_front()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Hurtbox_area_entered(area):
	knockBack=area.knockback_vector*120
	stats.health-=area.damage
	hurtbox.create_hit_effect()
	hurtbox.start_invinciblity(0.425)
	


func _on_Stats_no_health():
	queue_free()
	var enemyDeathEffect=EnemyDeathEffect.instance()
	get_parent().add_child(enemyDeathEffect)
	
	enemyDeathEffect.global_position=global_position


func _on_Hurtbox_invince_end():
	animationPlayer.play("stopBlink")


func _on_Hurtbox_invince_start():
	animationPlayer.play("startBlink")
