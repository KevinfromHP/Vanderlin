
/obj/effect/mapping_helpers/business_creator
	var/business_name = "New Business"
	/// Can this business be renamed using triumph buy?
	var/allow_renaming = FALSE
	/// The Typepath of the person who will be managing this business.
	var/job_owner
	/// The /area locations that will be renamed
	var/list/business_areas = list()
	/// The employee positions and their starting pay. Pay is preferrably done with a define.
	var/list/employee_positions = list()
	late = TRUE

/obj/effect/mapping_helpers/business_creator/LateInitialize()
	. = ..()
	if(!SSeconomy.initialized)
		debug_world_log("SSEconomy was not initialized. Business [business_name] could not be created.")
		return
	if(!ispath(job_owner, /datum/job))
		debug_world_log("Could not initialize [business_name]. job_owner [job_owner] is not a valid job type.")
		return
	register_business()

/obj/effect/mapping_helpers/business_creator/proc/register_business()




