class_name CollisionMap
extends TileMap

func is_colliding() -> bool:
	for child in get_children():
		if not child is Collider: continue;
		var collider = child as Collider;
		if collider.is_colliding(): return true;
		 
	return false;
