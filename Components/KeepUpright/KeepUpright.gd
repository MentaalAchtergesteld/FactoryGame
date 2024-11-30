class_name KeepUpright
extends Node2D

func _process(delta):
	rotation = -get_parent().rotation;
