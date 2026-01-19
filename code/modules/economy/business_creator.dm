
/obj/effect/mapping_helpers/business_creator
	name = "Business Creator - see code for usage"
	/// Can this business be renamed using triumph buy?
	var/allow_renaming = FALSE
	/// The /area locations that will be renamed
	var/list/business_areas = list()
	/// The job type that actually owns this business when they spawn
	var/job_owner
	/// The employee positions and their starting pay. Pay is preferrably done with a define.
	var/list/employee_positions = list()
	/// Do we do a payday by default?
	var/do_paydays = FALSE
	/// Starting payday multiplier for this job
	var/payday = 0
	/// Starting balance to pay out paydays
	var/starting_balance = 50
	/// What tax group are they paying from?
	var/taxes = TAX_BUSINESS
	late = TRUE

/obj/effect/mapping_helpers/business_creator/LateInitialize()
	. = ..()
	if(!SSeconomy.initialized)
		debug_world_log("SSEconomy was not initialized. Business [name] could not be created.")
		return
	if(!ispath(job_owner, /datum/job))
		debug_world_log("Could not initialize [name]. job_owner [job_owner] is not a valid job type.")
		return
	for(var/datum/job/employee in employee_positions)
		if(!ispath(employee, /datum/job))
			debug_world_log("Could not initialize [name]. employee [employee] is not a valid job type.")
			return
		if(!isnum(employee_positions[employee]))
			debug_world_log("Could not initialize [name]. employee [employee] has invalid paycheck [employee_positions[employee]].")
			return
	register_business()

/obj/effect/mapping_helpers/business_creator/proc/register_business()
	var/datum/bank_account/business/account = new(null, name, taxes, payday, job_owner, employee_positions)
	account.adjust_money(starting_balance)



