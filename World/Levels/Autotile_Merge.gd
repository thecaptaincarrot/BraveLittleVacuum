tool
extends TileSet

const STAIRS = 0
const SLOPE = 1

var binds = {
	STAIRS : [SLOPE],
	SLOPE : [STAIRS],
}
#
#func _is_tile_bound(drawn_id, neighbor_id):
#	if drawn_id in binds:
#		return neighbor_id in binds[drawn_id]
#	return false


func _is_tile_bound(drawn_id, neighbor_id):
	return neighbor_id in get_tiles_ids()
