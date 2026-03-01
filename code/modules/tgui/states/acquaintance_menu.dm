/*!
 * Copyright (c) 2020 Aleksej Komarov
 * SPDX-License-Identifier: MIT
 */

/**
 * tgui state: acquaintance_menu_state
 */

GLOBAL_DATUM_INIT(acquaintance_menu_state, /datum/ui_state/acquaintance_menu, new)

/datum/ui_state/acquaintance_menu/can_use_topic(src_object, mob/user)
	. = UI_CLOSE
	if(check_rights_for(user.client, R_ADMIN))
		. = UI_INTERACTIVE
	else if(istype(src_object, /datum/language_menu))
		var/datum/acquaintance_holder/acquaintances = src_object
		if(acquaintances.owner.current == user)
			. = UI_INTERACTIVE
