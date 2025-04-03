/obj/structure/closet/crate
	name = "crate"
	desc = ""
	icon = 'icons/obj/crates.dmi'
	icon_state = "crate"
	w_class = WEIGHT_CLASS_BULKY
	can_weld_shut = FALSE
	horizontal = TRUE
	allow_objects = TRUE
	allow_dense = FALSE
	dense_when_open = TRUE
	climbable = TRUE
	climb_time = 10 //real fast, because let's be honest stepping into or onto a crate is easy
	climb_stun = 0 //climbing onto crates isn't hard, guys
	delivery_icon = "deliverycrate"
	open_sound = 'sound/blank.ogg'
	close_sound = 'sound/blank.ogg'
	open_sound_volume = 35
	close_sound_volume = 50
	drag_slowdown = 0
	var/base_icon_state

/obj/structure/closet/crate/Initialize()
	. = ..()
	if(!base_icon_state)
		base_icon_state = initial(icon_state)
	if(icon_state == "[base_icon_state]open")
		opened = TRUE
	update_icon()

/obj/structure/closet/crate/CanPass(atom/movable/mover, turf/target)
	if(!istype(mover, /obj/structure/closet))
		var/obj/structure/closet/crate/locatedcrate = locate(/obj/structure/closet/crate) in get_turf(mover)
		if(locatedcrate) //you can walk on it like tables, if you're not in an open crate trying to move to a closed crate
			if(opened) //if we're open, allow entering regardless of located crate openness
				return TRUE
			if(!locatedcrate.opened) //otherwise, if the located crate is closed, allow entering
				return TRUE
	return !density

/obj/structure/closet/crate/update_icon()
	icon_state = "[base_icon_state][opened ? "open" : ""]"

/obj/structure/closet/crate/attack_hand(mob/user)
	. = ..()
	if(.)
		return

/obj/structure/closet/crate/open(mob/living/user)
	. = ..()

/obj/structure/closet/crate/coffin
	name = "casket"
	desc = "Death basket."
	icon_state = "casket"
	resistance_flags = FLAMMABLE
	max_integrity = 70
	icon = 'icons/roguetown/misc/structure.dmi'
	material_drop_amount = 5
	open_sound = 'sound/blank.ogg'
	close_sound = 'sound/blank.ogg'
	open_sound_volume = 25
	close_sound_volume = 50

/obj/structure/closet/crate/coffin/vampire
	name = "sleep casket"
	desc = "A fancy coffin."
	icon_state = "vcasket"
	resistance_flags = FLAMMABLE
	max_integrity = 70
	icon = 'icons/roguetown/misc/structure.dmi'
	material_drop_amount = 5
	open_sound = 'sound/blank.ogg'
	close_sound = 'sound/blank.ogg'
	open_sound_volume = 25
	close_sound_volume = 50

/// chest used for fence tram.
/obj/structure/closet/crate/dinghy
	name = "dinghy"
	desc = ""

	icon = 'icons/roguetown/misc/dinghy.dmi'
	base_icon_state = "dinghy"
	icon_state = "dinghyopen"
	pixel_x = -32

	density = FALSE
	dense_when_open = FALSE

	max_integrity = 1200
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	anchored = TRUE


	open_sound = 'sound/foley/cartdump.ogg'
	close_sound = 'sound/foley/cartadd.ogg'

//second half of the dinghy. Not a storage container.
/obj/structure/fake_dinghy
	name = "dinghy"
	desc = ""

	density = TRUE
	climbable = TRUE
	max_integrity = 1200
	anchored = TRUE

	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
