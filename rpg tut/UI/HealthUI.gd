extends Control 

var hearts=5 setget set_hearts
var max_hearts=5 setget set_max_hearts
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var heartUIFull=$HeartUFull
onready var heartUIEmpty=$HeartUIEmpty

func set_hearts(value):
	hearts=clamp(value,0,max_hearts)
	if heartUIFull!=null:
		heartUIFull.rect_size.x=hearts*15
	
	
func set_max_hearts(value):
	max_hearts=max(value,1)
	self.hearts=min(hearts,max_hearts)
	if heartUIEmpty!=null:
		heartUIEmpty.rect_size.x=hearts*15

# Called when the node enters the scene tree for the first time.
func _ready():
	self.max_hearts=PlayerStats.max_health
	self.hearts=PlayerStats.health
	PlayerStats.connect("health_changed",self,"set_hearts")
	PlayerStats.connect("max_health_changed",self,"set_max_hearts")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
