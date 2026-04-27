extends Node2D

@export var starterScene: PackedScene

@onready var locationNode: Node = %Location;

var currentLocation: PackedScene;

func _ready() -> void:
	setLocation(starterScene);
	
func setLocation(location: PackedScene):
	currentLocation = location;
	for child: Node in locationNode.get_children():
		child.queue_free();
	var locationScene = currentLocation.instantiate();
	locationNode.add_child(locationScene);
	MainEventBus.level_changed.emit()
	
