/obj/structure/dock_bell
	name = "Dock Bell"
	desc = "A loud bell that carries its sound to the nearby ports. Signals to merchants that the dock has wares to sell."


	icon = 'icons/roguetown/misc/tallstructure.dmi'
	icon_state = "dock_bell"


	var/static/approved_jobs = list(/datum/job/merchant, /datum/job/grabber, /datum/job/steward, /datum/job/gaffer)
	max_integrity = 999999

/obj/structure/dock_bell/examine(mob/user)
	. = ..()
	. += span_info("The dock bell can be rung by sanctioned workers after [ceil(COOLDOWN_TIMELEFT(SSmerchant, ring_bell)/10)] seconds.")
	. += span_info("The dock bell can be rung by outsiders after [ceil(COOLDOWN_TIMELEFT(SSmerchant, outsider_ring_bell)/10)] seconds.")

/obj/structure/dock_bell/attack_hand(mob/user)
	. = ..()
	if(!COOLDOWN_FINISHED(SSmerchant, ring_bell))
		return
	var/datum/job/user_job = SSjob.GetJob(user.job)
	if(user_job && !(initial(user_job.type) in approved_jobs))
		if(!COOLDOWN_FINISHED(SSmerchant, outsider_ring_bell))
			return
	if(!do_after(user, 5 SECONDS, src))
		return
	if(!COOLDOWN_FINISHED(SSmerchant, ring_bell))
		return
	visible_message(span_notice("[user] starts ringing the dock bell."))
	playsound(get_turf(src), 'sound/misc/handbell.ogg', 50, 1, 20)
	if(!SSmerchant.cargo_docked && SSmerchant.cargo_boat.check_living())
		SSmerchant.send_cargo_ship_back()
	else if(SSmerchant.cargo_docked)
		SSmerchant.prepare_cargo_shipment()
	COOLDOWN_START(SSmerchant, ring_bell, 30 SECONDS)
	COOLDOWN_START(SSmerchant, outsider_ring_bell, 20 MINUTES)
