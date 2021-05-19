extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const HIT_EFFECT= preload("res://Effects/hit_effect.tscn")

signal invince_start
signal invince_end

var invincible = false setget set_invincible
onready var timer =$Timer

func set_invincible(value):
	invincible=value
	if invincible==true:
		emit_signal("invince_start")
	else:
		emit_signal("invince_end")
	
	
func create_hit_effect():
	
	var effect = HIT_EFFECT.instance()
	var main =  get_tree().current_scene
	main.add_child(effect)
	effect.global_position= global_position


func start_invinciblity(duration):
	self.invincible=true
	timer.start(duration)
	

func _on_Timer_timeout():
	self.invincible=false


func _on_Hurtbox_invince_end():
	set_deferred("monitorable",false)


func _on_Hurtbox_invince_start():
	monitorable=false
