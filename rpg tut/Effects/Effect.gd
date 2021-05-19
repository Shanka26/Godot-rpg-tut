extends AnimatedSprite


# Declare member variables here. Examples:
# var a = 2



# Called when the node enters the scene tree for the first time.
func _ready():
	self.connect("animation_finished",self,"_on_animation_finished")
	frame=0
	play("animate")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_animation_finished():
	queue_free()
