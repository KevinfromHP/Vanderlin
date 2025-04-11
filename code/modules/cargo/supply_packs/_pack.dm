/datum/supply_pack
	var/name = "Crate"
	var/group = ""
	var/hidden = FALSE
	var/contraband = FALSE
	var/cost = 700 // Minimum cost, or infinite points are possible.
	var/access = FALSE
	var/access_any = FALSE
	//what machines can order these.
	var/purchase_flags = PURCHASE_MERCHANT
	var/list/contains = null
	var/crate_name = "crate"
	var/desc = ""//no desc by default
	var/crate_type = /obj/structure/closet/crate
	var/dangerous = FALSE // Should we message admins?
	var/special = FALSE //Event/Station Goals/Admin enabled packs
	var/special_enabled = FALSE
	var/DropPodOnly = FALSE//only usable by the Bluespace Drop Pod via the express cargo console
	var/admin_spawned = FALSE
	var/small_item = FALSE //Small items can be grouped into a single crate.
	var/static_cost = FALSE
	var/randomprice_factor = 0.07

/datum/supply_pack/New()
	..()
	var/lim = round(cost * 0.3)
	cost = rand(cost-lim, cost+lim)
	if(cost < 1)
		cost = 1

	#ifdef TESTSERVER
	cost = 1
#else
	if(cost)
		if(cost == initial(cost) && !static_cost)
			var/na = max(round(cost * randomprice_factor, 1), 1)
			cost = max(rand(cost-na, cost+na), 1)
#endif

/datum/supply_pack/proc/generate(atom/A)
	var/atom/loc = A
	if(!(small_item && istype(A, /obj/structure/closet/crate)))
		var/obj/structure/closet/crate/C = new crate_type(A)
		C.name = crate_name
	for(var/item in contains)
		var/atom/I = new item()
		if(admin_spawned)
			I.flags_1 |= ADMIN_SPAWNED_1
	return loc
