extends Node


func _ready() -> void:
	var bus := MainEventBus

	var base_signals := {}
	for sig in ClassDB.class_get_signal_list("Node", false):
		base_signals[sig["name"]] = true

	for sig in bus.get_signal_list():
		var sig_name: String = sig["name"]
		if base_signals.has(sig_name):
			continue
		var arg_count: int = sig["args"].size()
		var signal_object: Signal = bus[sig_name]
		signal_object.connect(_log.bind(sig_name))


func _log(event_name: String) -> void:
	print("[EventLogger] %s" % event_name)
