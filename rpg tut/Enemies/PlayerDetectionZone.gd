extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


var player = null


func can_see_player():
	return player !=null

func _on_PlayerDetectionZone_body_entered(body):
	player=body


func _on_PlayerDetectionZone_body_exited(body):
	player=null

