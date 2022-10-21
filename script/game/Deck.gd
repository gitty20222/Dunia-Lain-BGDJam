extends Node
class_name Deck

var content: Array

func init(events: Array):
	for event in events:
		content.append(event)
		
	content.sort_custom(self, 'weight_cmp')

func weight_cmp(a: Event, b: Event) -> bool:
	return a.weight < b.weight
