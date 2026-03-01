/datum/acquaintance
	var/datum/mind/owner

	var/real_name
	var/title
	var/voice_color = "#a0a0a0"
	var/pronouns
	var/age
	var/species
	var/list/rumors = list()
	var/list/features = list()
	var/face
	var/dead

/datum/acquaintance/New(datum/mind/owner)
	. = ..()
	src.owner = owner

/datum/acquaintance/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		ui = new(user, src, "AcquaintancesSubMenu")
		ui.open()

/datum/acquaintance/ui_data(mob/user)
	var/list/data = list()

	data["name"] = real_name
	data["title"] = title
	data["voice_color"] = voice_color
	data["pronouns"] = pronouns
	data["age"] = age
	data["species"] = species
	data["features"] = features
	data["rumors"] = rumors
	if(face)
		data["icon"] = icon2base64(SScrediticons.get_credit_icon(real_name))
	data["dead"] = dead
	return data
