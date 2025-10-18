extends Area2D

func found() -> void:
	set_deferred("monitorable",false)
	$AnimatedSprite2D.show()
	$AnimatedSprite2D.play()
	$AnimationPlayer.play("collect")
