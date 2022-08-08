extends Node2D




func _on_Hurtbox_area_entered(area):
	$AnimationPlayer.play("Open")
