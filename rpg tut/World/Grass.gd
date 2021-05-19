extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const GrassEffect=preload("res://Effects/Grass_effect.tscn")
func create_grassEffect():
	
	
	var grassEffect=GrassEffect.instance()
	var world=get_tree().current_scene
	world.add_child(grassEffect)
	grassEffect.global_position=global_position
	


func _on_Hurtbox_area_entered(area):
	create_grassEffect()
	queue_free()
