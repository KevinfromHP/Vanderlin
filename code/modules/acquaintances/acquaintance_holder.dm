/datum/acquaintance_holder
	/// the mind which possesses these known people
	var/datum/mind/owner
	/// the list of other people we know
	var/list/datum/acquaintance/relations = list()


/datum/acquaintance_holder/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		ui = new(user, src, "AcquaintanceMenu")
		ui.open()

/datum/acquaintance_holder/ui_data(mob/user)
	var/list/data = list()

	for(var/datum/acquaintance/acquaintance as anything in relations)
		UNTYPED_LIST_ADD(data["acquaintances"], acquaintance.ui_data(user))

	data["admin_mode"] = check_rights_for(user.client, R_ADMIN)
	return data

/datum/acquaintance_holder/ui_state(mob/user)
	return GLOB.acquaintance_menu_state

/datum/acquaintance_holder/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	var/mob/user = owner.current

	var/list/acquaintance = params["relationships"]

	//switch(action)
	//	  // like Topic
