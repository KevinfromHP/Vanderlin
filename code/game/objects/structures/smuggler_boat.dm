/obj/structure/smuggler_boat
	name = "smuggler's dinghy"
	desc = "A dinghy brought upstream to load with goods to fence. Taken to a vessel offshore."
	layer = ABOVE_OPEN_TURF_LAYER
	anchored = TRUE
	density = TRUE
	climbable = TRUE
	max_integrity = 50000
	pixel_x = -19

	icon = 'icons/roguetown/misc/64x32.dmi'
	icon_state = "rowboat"


	var/list/stuff_shit = list()

	var/current_capacity = 0
	var/maximum_capacity = 24

/obj/structure/smuggler_boat/dump_contents()
	var/atom/L = drop_location()
	for(var/atom/movable/AM in src)
		AM.forceMove(L)
	stuff_shit = list()
	current_capacity = 0

/obj/structure/smuggler_boat/Destroy()
	dump_contents()
	return ..()

/obj/structure/smuggler_boat/MouseDrop_T(atom/movable/O, mob/living/user)
	if(!istype(O) || !isturf(O.loc) || istype(O, /atom/movable/screen))
		return
	if(!istype(user) || user.incapacitated())
		return
	if(!Adjacent(user) || !user.Adjacent(O))
		return
	if(user == O) //try to climb into or onto it
		if(!(user.mobility_flags & MOBILITY_STAND))
			if(!do_after(user, 2 SECONDS, src))
				return FALSE
			if(put_in(O))
				playsound(loc, 'sound/foley/cartadd.ogg', 100, FALSE, -1)
			return TRUE
		return ..()
	//only these intents should be able to move objects into handcarts
	if(user.used_intent.type == INTENT_HELP || user.used_intent.type == /datum/intent/grab/move)
		if(isliving(O))
			if(!do_after(user, 2 SECONDS, O))
				return FALSE
		if(put_in(O))
			playsound(loc, 'sound/foley/cartadd.ogg', 100, FALSE, -1)
		return TRUE

/obj/structure/smuggler_boat/attackby(obj/item/I, mob/user, params)
	if(!user.cmode)
		if(put_in(I, user))
			playsound(loc, 'sound/foley/cartadd.ogg', 100, FALSE, -1)
		return
	..()

/obj/structure/smuggler_boat/attack_hand(mob/living/user)
	. = ..()
	if(.)
		return
	if(user.cmode)
		return
	var/turf/T = get_turf(user)
	if(isturf(T))
		user.changeNext_move(CLICK_CD_MELEE)
		var/fou
		for(var/obj/item/I in T)
			put_in(I)
			fou = TRUE
		if(fou)
			playsound(loc, 'sound/foley/cartadd.ogg', 100, FALSE, -1)

/obj/structure/smuggler_boat/proc/put_in(atom/movable/O, mob/user)
	if(!insertion_allowed(O))
		return
	var/weight = 0
	if(isitem(O))
		var/obj/item/I = O
		if((current_capacity + I.w_class) > maximum_capacity)
			return FALSE
		weight = I.w_class
	if(isliving(O))
		return FALSE
	if(user && !user.transferItemToLoc(O, src))
		return FALSE
	else
		O.forceMove(src)
	current_capacity += weight
	stuff_shit += O
	update_icon()
	return TRUE

/obj/structure/smuggler_boat/proc/take_contents()
	var/atom/L = drop_location()
	for(var/atom/movable/AM in L)
		if(AM != src && put_in(AM)) // limit reached
			break

/obj/structure/smuggler_boat/update_icon()
	. = ..()
	if(length(stuff_shit))
		icon_state = "rowboat"
	else
		icon_state = "rowboat"

/obj/structure/smuggler_boat/attack_right(mob/user)
	. = ..()
	if(.)
		return
	user.changeNext_move(CLICK_CD_MELEE)
	if(length(stuff_shit))
		dump_contents()
		visible_message(span_info("[user] dumps out [src]!"))
		playsound(loc, 'sound/foley/cartdump.ogg', 100, FALSE, -1)
	update_icon()

/obj/structure/smuggler_boat/proc/insertion_allowed(atom/movable/AM)
	if(ismob(AM))
		if(!isliving(AM)) //let's not put ghosts or camera mobs inside closets...
			return FALSE
		var/mob/living/L = AM
		if(L.anchored || (L.buckled && L.buckled != src) || L.incorporeal_move || L.has_buckled_mobs())
			return FALSE
		if(L.mob_size > MOB_SIZE_TINY) // Tiny mobs are treated as items.
			if(L.density)
				return FALSE
		L.stop_pulling()
	else if(isobj(AM))
		if((AM.density) || AM.anchored || AM.has_buckled_mobs() || iseffect(AM))
			return FALSE
		else
			if(isitem(AM))
				var/obj/item/I = AM
				if(HAS_TRAIT(I, TRAIT_NODROP) || I.item_flags & ABSTRACT)
					return FALSE
	else // not a mob or object
		return FALSE

	return TRUE
