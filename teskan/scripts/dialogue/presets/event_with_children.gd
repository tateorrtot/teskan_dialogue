tool
extends Control
var inital_size = self.get_rect().size.y

#func _enter_tree():
	#$HideChildren.connect("pressed",self,_on_HideChildren_pressed())


	#$ChildrenList.rect_position.y = 117.001
	#$MainBody.rect_position.y = 55
	#$MainBody.rect_position.y = $MainBody.rect_position.y - $ChildrenList.rect_size.y



func _on_HideChildren_pressed():
	if $ChildrenList.visible == true:
		$ChildrenList.visible = false
		self.rect_min_size.y = inital_size
		self.rect_size.y = inital_size
		
		#print(inital_size)
		#print(self.rect_size.y)
	else: 
		self.rect_min_size.y = inital_size + $ChildrenList.rect_size.y
		$ChildrenList.visible = true

func _on_ChildrenList_item_rect_changed():
	if $ChildrenList.visible == true:
		self.rect_min_size.y = inital_size + $ChildrenList.rect_size.y
