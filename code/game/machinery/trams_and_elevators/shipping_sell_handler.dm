/// a handler for exporting items. Made for trams but could be used for other things.
/datum/shipping_sell_handler
	var/sell_blacklist = list(/obj/item/paper/scroll/cargo, /obj/item/coin, /obj/structure/closet/crate/chest)

	var/sell_modifer = 1
	var/total_coin_value = 0

	var/list/sold_items = list()
	var/list/sold_count = list()

/**
 * atom_to_sell `</atom/movable/A>`: The item you want to sell. Includes contents. \
 **/
/datum/shipping_sell_handler/proc/sell_atom(atom/movable/atom_to_sell)
	if(ismob(atom_to_sell)) //don't try to sell shit on a mob
		return
	for(var/atom/movable/inside in atom_to_sell.get_all_contents())
		if(inside == atom_to_sell)
			continue
		sell_atom(inside) //recursive call!
	for(var/B as anything in sell_blacklist)
		if(istype(atom_to_sell, B))
			return
	if(!atom_to_sell.sellprice)
		return

	total_coin_value += FLOOR(atom_to_sell.sellprice * sell_modifer * SSmerchant.return_sell_modifier(atom_to_sell.type), 1)
	var/old_price = FLOOR(atom_to_sell.sellprice * sell_modifer * SSmerchant.return_sell_modifier(atom_to_sell.type), 1)
	if(!(initial(atom_to_sell.name) in sold_items))
		sold_items |= initial(atom_to_sell.name)
		sold_count |= initial(atom_to_sell.name)
		sold_count[initial(atom_to_sell.name)] = 1
		sold_items[initial(atom_to_sell.name)] = FLOOR(atom_to_sell.sellprice * sell_modifer * SSmerchant.return_sell_modifier(atom_to_sell.type), 1)
	else
		sold_count[initial(atom_to_sell.name)]++
		sold_items[initial(atom_to_sell.name)] += FLOOR(atom_to_sell.sellprice * sell_modifer * SSmerchant.return_sell_modifier(atom_to_sell.type), 1)
	SSmerchant.handle_selling(atom_to_sell.type)
	var/new_price = FLOOR(atom_to_sell.sellprice * sell_modifer * SSmerchant.return_sell_modifier(atom_to_sell.type), 1)
	if(old_price != new_price)
		SSmerchant.changed_sell_prices(atom_to_sell.type, old_price, new_price)

	if(istype(atom_to_sell, /obj/item/clothing/head/mob_holder))
		var/obj/item/clothing/head/mob_holder/holder = atom_to_sell
		for(var/obj/item/item in holder.held_mob.get_equipped_items())
			item.forceMove(get_turf(holder))
		to_chat(holder.held_mob, span_boldwarning("You have been sold."))
		qdel(holder.held_mob) //so long my friend
	qdel(atom_to_sell)

/**
 * location `</turf/T>`: Where the scrolls should spawn. \
 * scroll_content_max:  How many sell entries should be included on a single scroll. \
 **/
/datum/shipping_sell_handler/proc/generate_manifest(turf/location, scroll_content_max = 12)
	var/scrolls_to_spawn = CEILING(length(sold_items) / scroll_content_max, 1)
	for(var/i = 1 to scrolls_to_spawn)
		var/list/items = list()
		var/list/count = list()
		var/current_count = 0
		for(var/b = 1 to length(sold_items))
			if(current_count >= scroll_content_max)
				continue
			current_count++
			var/first_item = sold_items[1]
			items |= first_item
			items[first_item] = sold_items[first_item]
			sold_items -= first_item

			var/first_count = sold_count[1]
			count |= first_item
			count[first_count] = sold_count[first_count]
			sold_items -= first_count

		var/obj/item/paper/scroll/sold_manifest/manifest = new /obj/item/paper/scroll/sold_manifest(location)
		manifest.count = count.Copy()
		manifest.items = items.Copy()
		manifest.rebuild_info()
