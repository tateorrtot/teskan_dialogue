tool
extends Control
var inital_size = self.get_rect().size.y

func _on_ChildrenList_item_rect_changed():
	#print("Child added")
	self.rect_min_size.y = inital_size + $ChildrenList.rect_size.y
	#$ChildrenList.rect_position.y = 117.001
	#$MainBody.rect_position.y = 55
	#$MainBody.rect_position.y = $MainBody.rect_position.y - $ChildrenList.rect_size.y

