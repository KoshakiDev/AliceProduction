extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var animation_player = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
const hit_effect = preload("res://src/components/hit/HitEffect.tscn")


func _input(event):
	if event.is_action_pressed("sink_1"):
		animation_player.play("Sink_1")
	if event.is_action_pressed("sink_2"):
		animation_player.play("Sink_2")
		Global.is_box_deleted = true
		yield(animation_player, "animation_finished")
		queue_free()

func _on_Hurtbox_area_entered(area):
	var effect = hit_effect.instance()
	Global.misc.add_child(effect)
	effect.global_position = Vector2(0, 10) + global_position
