
/obj/effect/mapping_helpers/business_creator
	var/default_name = "New Business"
	var/list/business_areas = list()
	var/list/job_positions = list()
	late = TRUE

/obj/effect/mapping_helpers/business_creator/LateInitialize()
	. = ..()
	if(!SSeconomy.initialized)
		debug_world_log("SSEconomy was not initialized. Business [default_name] could not be created.")
		return
	if(!default_name)
		return
	if(!length(job_positions))
		return
