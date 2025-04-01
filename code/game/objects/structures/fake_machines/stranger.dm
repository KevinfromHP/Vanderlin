/obj/structure/fake_machine/smugglervend
	name = "STRANGER"
	desc = "Ode to greed."
	icon = 'icons/roguetown/misc/machines.dmi'
	icon_state = "feedinghole"
	density = FALSE
	blade_dulling = DULLING_BASH
	max_integrity = 0
	anchored = TRUE
	layer = BELOW_OBJ_LAYER
	var/list/held_items = list()
	var/locked = TRUE
	var/budget = 0
	var/upgrade_flags
	var/current_cat = "1"
	var/lockid = "smuggler"


/obj/structure/fake_machine/smugglervend/Initialize()
	. = ..()
	update_icon()


/obj/structure/fake_machine/smugglervend/update_icon()
	cut_overlays()
	if(obj_broken)
		set_light(0)
		return
	set_light(1, 1, 1, l_color =  "#1b7bf1")
	add_overlay(mutable_appearance(icon, "vendor-merch"))


/obj/structure/fake_machine/smugglervend/attackby(obj/item/P, mob/user, params)
	if(istype(P, /obj/item/key))
		var/obj/item/key/K = P
		if(K.lockid == lockid)
			locked = !locked
			playsound(loc, 'sound/misc/beep.ogg', 100, FALSE, -1)
			update_icon()
			return attack_hand(user)
		else
			playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
			to_chat(user, "<span class='warning'>Wrong key.</span>")
			return
	if(istype(P, /obj/item/storage/keyring))
		var/obj/item/storage/keyring/K = P
		for(var/obj/item/key/KE in K.contents)
			if(KE.lockid == lockid)
				locked = !locked
				playsound(loc, 'sound/misc/beep.ogg', 100, FALSE, -1)
				update_icon()
				return attack_hand(user)
	if(istype(P, /obj/item/coin))
		budget += P.get_real_price()
		qdel(P)
		update_icon()
		playsound(loc, 'sound/misc/machinevomit.ogg', 100, TRUE, -1)
		return attack_hand(user)
	..()

/obj/structure/fake_machine/smugglervend/Topic(href, href_list)
	. = ..()
	if(!ishuman(usr))
		return
	if(!usr.canUseTopic(src, BE_CLOSE) || locked)
		return
	if(href_list["buy"])
		var/path = text2path(href_list["buy"])
		if(!ispath(path, /datum/supply_pack))
			message_admins("MERCHANT [usr.key] IS TRYING TO BUY A [path] WITH THE GOLDFACE. THIS IS AN EXPLOIT.")
			return
		var/datum/supply_pack/picked_pack = new path
		var/cost = picked_pack.cost
		if(budget >= cost)
			budget -= cost
		else
			say("Not enough mammon, stranger!" )
			return
		if(ispath(picked_pack.contains))
			var/obj/item/packitem = picked_pack.contains
			new packitem(get_turf(usr))
		else
			for(var/in_pack in picked_pack.contains)
				var/obj/item/packitem = in_pack
				new packitem(get_turf(usr))
		qdel(picked_pack)
	if(href_list["change"])
		if(budget > 0)
			budget2change(budget, usr)
			budget = 0
	if(href_list["changecat"])
		current_cat = href_list["changecat"]
	return attack_hand(usr)

/obj/structure/fake_machine/smugglervend/attack_hand(mob/living/user)
	. = ..()
	if(.)
		return
	if(!ishuman(user))
		return
	if(locked)
		to_chat(user, "<span class='warning'>It's locked. Of course.</span>")
		return
	user.changeNext_move(CLICK_CD_MELEE)
	playsound(loc, 'sound/misc/beep.ogg', 100, FALSE, -1)
	var/canread = user.can_read(src, TRUE)
	var/contents
	contents = "<center>STRANGER<BR>\
				<center><i>\"What're ya buyin'?\"</i><BR>"
	contents += "<a href='byond://?src=[REF(src)];change=1'>MAMMON LOADED:</a> [budget]<BR>"

	var/mob/living/carbon/human/H = user
	if(H.job == "Smuggler")
		if(canread)
			contents += "<a href='byond://?src=[REF(src)];secrets=1'>Secrets</a>"
		else
			contents += "<a href='byond://?src=[REF(src)];secrets=1'>[stars("Secrets")]</a>"

	contents += "</center><BR>"

	var/list/unlocked_cats = list("Apparel","Armor","Consumable", "Disguises","Narcotics", "Tools","Seeds","Weapons")

	if(current_cat == "1")
		contents += "<center>"
		for(var/X in unlocked_cats)
			contents += "<a href='byond://?src=[REF(src)];changecat=[X]'>[X]</a><BR>"
		contents += "</center>"
	else
		contents += "<center>[current_cat]<BR></center>"
		contents += "<center><a href='byond://?src=[REF(src)];changecat=1'>\[RETURN\]</a><BR><BR></center>"
		var/list/pax = list()
		for(var/pack in SSmerchant.supply_packs)
			var/datum/supply_pack/picked_pack = SSmerchant.supply_packs[pack]
			if(picked_pack.group == current_cat && picked_pack.purchase_flags & PURCHASE_SMUGGLER)
				pax += picked_pack
		for(var/datum/supply_pack/picked_pack in sortList(pax))
			var/costy = picked_pack.cost
			contents += "[picked_pack.name] - ([costy])<a href='byond://?src=[REF(src)];buy=[picked_pack.type]'>BUY</a><BR>"

	if(!canread)
		contents = stars(contents)

	var/datum/browser/popup = new(user, "VENDORTHING", "", 370, 400)
	popup.set_content(contents)
	popup.open()

/obj/structure/fake_machine/smugglervend/obj_break(damage_flag)
	..()
	budget2change(budget)
	set_light(0)
	update_icon()
	icon_state = "feedinghole"

/obj/structure/fake_machine/smugglervend/Destroy()
	set_light(0)
	return ..()

/obj/structure/fake_machine/smugglervend/Initialize()
	. = ..()
	update_icon()
