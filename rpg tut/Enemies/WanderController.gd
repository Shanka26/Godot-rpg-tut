extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var start_position= global_position
onready var target_position=global_position
onready var timer =$Timer

export (int) var wander_range

# Called when the node enters the scene tree for the first time.

func update_target_position():
		var target_vector=Vector2(rand_range(-wander_range,wander_range),rand_range(-wander_range,wander_range))
		target_position=start_position+target_vector
		
func _ready():
	pass # Replace with function body.
"Timer"

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func get_time_left():
	return timer.time_left

func start_timer(duration):
	timer.start(duration)
	
	
func _on_Timer_timeout():
		update_target_position()
