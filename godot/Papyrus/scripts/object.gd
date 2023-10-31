extends RigidBody2D

func _on_body_entered(body):
	print("The ball collided with: ", body.name)
