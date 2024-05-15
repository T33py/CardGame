class_name Util_functions

func remove_from_list(item, list: Array):
	for i in range(len(list)):
		if list[i] == item:
			list.remove_at(i)
			break
	return
