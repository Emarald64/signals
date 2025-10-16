extends Node2D

const circleSpeed:=200
static var gradient:=preload("res://Scenes/detector_circle_gradient.tres")
static var widthCurve:=preload("res://Scenes/detector_circle_width_curve.tres")
var currentRadius:=0.0
var maxDistance:float


func _draw() -> void:
	draw_circle(Vector2.ZERO,currentRadius,gradient.sample(maxDistance/500),false,widthCurve.sample(currentRadius/maxDistance))

func _process(delta: float) -> void:
	currentRadius+=circleSpeed*delta
	if currentRadius>maxDistance:
		queue_free()
	queue_redraw()
