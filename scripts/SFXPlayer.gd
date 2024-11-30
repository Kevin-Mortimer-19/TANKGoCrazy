extends Node

var channel_count = 16
var bus = "master"

var loop_channel

var available = []

var playing = []

var queue = []

var looping = false


func _ready() -> void:
	process_mode = ProcessMode.PROCESS_MODE_ALWAYS
	for i in channel_count:
		var c = AudioStreamPlayer.new()
		c.name = "Stream " + str(i)
		add_child(c)
		available.append(c)
		c.connect("finished", _on_stream_finished, 0)
		c.bus = bus
	loop_channel = AudioStreamPlayer.new()
	add_child(loop_channel)
	loop_channel.finished.connect(restart_loop)


func restart_loop() -> void:
	loop_channel.play()


func _on_stream_finished() -> void:
	pass


func play(sound_path: AudioStream) -> void:
	queue.append(sound_path)


func start_loop(sound_path: AudioStream) -> void:
	loop_channel.stream = sound_path
	loop_channel.play()
	looping = true


func end_loop() -> void:
	loop_channel.stop()
	looping = false


func _process(_delta: float) -> void:
	if not queue.is_empty() and not available.is_empty():
		available[0].stream = queue.pop_front()
		available[0].play()
		var active_streams = playing
		for s in active_streams:
			if not s.playing:
				playing.erase(s)
				available.append(s)
		available.append(available.pop_front())
