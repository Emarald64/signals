extends Area2D

var collected:=false

func found() -> void:
	collected=true
	set_deferred("monitorable",false)
	$AnimatedSprite2D.show()
	$AnimatedSprite2D.play()
	$AnimationPlayer.play("collect")
