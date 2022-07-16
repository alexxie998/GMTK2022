extends Node2D


onready var health_bar = $over
onready var under=$under
onready var updateTween=$Tween




func _on_Player_health_changed(old_health):
	health_bar.value=old_health
	updateTween.interpolate_property(under , "value" , under.value , health_bar.value , 0.4 , Tween.TRANS_SINE , Tween.EASE_IN_OUT , 0.4)
	updateTween.start()


func _on_Player_on_max_health_updated(health,cur_health):
	health_bar.max_value=health
	under.max_value=health
	health_bar.value=cur_health
	under.value=cur_health

