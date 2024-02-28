@tool
extends Control
var inital_size = self.get_rect().size.y

#func _enter_tree():
	#$HideChildren.connect("pressed",Callable(self,_on_HideChildren_pressed()))


	#$ChildrenList.position.y = 117.001
	#$MainBody.position.y = 55
	#$MainBody.position.y = $MainBody.position.y - $ChildrenList.size.y



func _on_HideChildren_pressed():
	if $ChildrenList.visible == true:
		$ChildrenList.visible = false
		self.custom_minimum_size.y = inital_size
		self.size.y = inital_size
		
		###print(inital_size)
		###print(self.size.y)
	else: 
		self.custom_minimum_size.y = inital_size + $ChildrenList.size.y
		$ChildrenList.visible = true

func _on_ChildrenList_item_rect_changed():
	if $ChildrenList.visible == true:
		self.custom_minimum_size.y = inital_size + $ChildrenList.size.y
