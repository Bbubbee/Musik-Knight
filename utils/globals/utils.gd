extends Node


func does_index_exist_in_arr(arr: Array, index: int):
	if index >= 0 and index < arr.size():
		return true
	return false
