@tool
extends Control

func _on_ChildrenList_item_rect_changed():
	###print("Child added")
	self.custom_minimum_size.y = 110 + $ChildrenList.size.y + 5
