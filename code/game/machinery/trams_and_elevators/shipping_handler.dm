/// a handler for exporting items. Made for trams but could be used for other things.
/datum/shipping_handler
	var/sell_blacklist = list(
		/obj/item/paper/scroll/mercantile/trade_request,
		/obj/item/paper/scroll/cargo,
		/obj/item/coin,
		/obj/structure/closet/crate/chest)

	var/sell_modifer = 1
	var/total_coin_value = 0

	var/list/items_to_sell = list()
	var/list/sold_items = list()
	var/list/sold_count = list()

	///If there's a trade request here, functionality differs to cater to it.
	var/obj/item/paper/scroll/mercantile/trade_request/trade_request
	var/list/request_collector = list()

/// needs to be called to use the trade request system. Note that a shipping handler can only support one trade request at a time.
/datum/shipping_handler/proc/find_trade_request(atom/movable/A)
	if(ishuman(A)) //don't grab a trade request off a person
		return
	if(istype(A, /obj/item/paper/scroll/mercantile/trade_request))
		trade_request = A
	for(var/atom/movable/inside in A.get_all_contents())
		if(trade_request) // breaks through recursive call or the check above
			break
		if(inside == A)
			continue
		find_trade_request(inside) //recursive call!
		for(var/requestType in trade_request.requests)
			request_collector[requestType] = list()

/datum/shipping_handler/proc/gather_sellable(atom/movable/atom_to_sell)
	if(!atom_to_sell.sellprice) //This will exclude most mobs and the possessions
		return
	for(var/atom/movable/inside in atom_to_sell.get_all_contents())
		if(inside == atom_to_sell)
			continue
		gather_sellable(inside) //recursive call!
	if(atom_to_sell.type in sell_blacklist)
		return

	if(trade_request)
		var/aType = atom_to_sell.type
		var/list/subCollection = request_collector[aType]
		//if the type is in the requests, it's not already in the list, and the list for this item isn't full yet
		//on the off chance someone has tried to sell unrelated items in the same crate, this will default it to normal selling.
		if(aType in request_collector && !(atom_to_sell in subCollection) && subCollection.len <  trade_request.requests[aType])
			//if it's a bottle, check to see it's filled enough
			if(istype(atom_to_sell, /obj/item/reagent_containers/glass/bottle))
				var/obj/item/reagent_containers/glass/bottle/input_bottle = atom_to_sell
				if(initial(input_bottle.list_reagents))
					var/passed = FALSE
					var/list/input_reagents = initial(input_bottle.list_reagents)
					for(var/datum/reagent/reagent as anything in initial(input_bottle.list_reagents))
						var/obj/item/reagent_containers/glass/bottle/bottle = atom_to_sell
						if(bottle.reagents.has_reagent(reagent, input_reagents[reagent] * 0.5))
							passed = TRUE
					if(!passed)
						return
			subCollection |= atom_to_sell
			return
	items_to_sell |= atom_to_sell

/**
 * atom_to_sell `</atom/movable/A>`: The item you want to sell. Includes contents. \
 **/
/datum/shipping_handler/proc/sell_items()
	if(trade_request)
		validate_request()
	for(var/atom/movable/atom_to_sell in items_to_sell)
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

		//due to the recursive gathering items on them will always be sold
		if(ismob(atom_to_sell))
			to_chat(atom_to_sell, span_boldwarning("You have been sold."))
			qdel(atom_to_sell)
		if(istype(atom_to_sell, /obj/item/clothing/head/mob_holder))
			var/obj/item/clothing/head/mob_holder/holder = atom_to_sell
			for(var/obj/item/item in holder.held_mob.get_equipped_items())
				item.forceMove(get_turf(holder))
			to_chat(holder.held_mob, span_boldwarning("You have been sold."))
			qdel(holder.held_mob) //so long my friend
		qdel(atom_to_sell)

///If there's a shipping request, this is called to handle selling it.
/datum/shipping_handler/proc/validate_request()
	PROTECTED_PROC(TRUE)
	for(var/requestType in request_collector)
		var/list/subCollection = request_collector[requestType]
		if(subCollection.len < trade_request.requests[requestType])
			return
	// the request was successfully fulfilled, move it all over. Note these items won't be sold at all if it fails, a safety catch for fucking up your request.
	for(var/requestType in request_collector)
		for(var/atom_to_sell in request_collector[requestType])
			qdel(atom_to_sell)
	total_coin_value += trade_request.reward
	if(trade_request.triumphs)
		for(var/datum/mind/merchantMind in get_minds(/datum/job/merchant::title))
			var/mob/H = merchantMind.current
			if(H && ishuman(H) && !isdead(H))
				to_chat(H, span_blue("The Mercator's Guild is pleased."))
				adjust_triumphs(H, trade_request.triumphs)
	qdel(trade_request)

/**
 * location `</turf/T>`: Where the scrolls should spawn. \
 * scroll_content_max:  How many sell entries should be included on a single scroll. \
 **/
/datum/shipping_handler/proc/generate_manifest(turf/location, scroll_content_max = 12)
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
