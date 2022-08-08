extends CanvasLayer

onready var info_pos

onready var realization_texture = $TextureRect

func _ready():
	pass
	realization_texture.visible = false
	#Global.set("UI_layer", self)
	#Global.main.update_wave()

func _input(event):
	if event.is_action_pressed("realization"):
		if realization_texture.visible == false:
			realization_texture.visible = true
		else:
			realization_texture.visible = false
