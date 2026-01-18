/datum/bank_account
	var/identifier
	var/id_prefix = "ba"

	var/account_holder = "No Owner"
	var/account_balance = 0

	/// Has the steward frozen our account?
	var/frozen = FALSE
	/// The tax group as defined on SStreasury
	var/tax_group = TAX_FOREIGN
	/// An override from the tax group to ignore taxes
	var/tax_exempt = FALSE
	///goes up if you underflow during deposits
	var/unpaid_taxes = 0


/datum/bank_account/New(account_holder, tax_group=TAX_FOREIGN)
	if(account_holder)
		src.account_holder = account_holder
	src.tax_group = tax_group
	src.tax_exempt = (tax_group == TAX_LORD)
	identifier = "[id_prefix][SSeconomy.accounts_created]"
	SSeconomy.accounts_created++
	LAZYADDASSOC(SSeconomy.bank_accounts, identifier, src)

/datum/bank_account/Destroy(force, ...)
	. = ..()
	//we keep the identifier so we at least knew it existed
	LAZYSET(SSeconomy.bank_accounts, identifier, null)

/datum/bank_account/proc/_adjust_money(amt)
	account_balance += amt

/datum/bank_account/proc/has_money(amt)
	return account_balance >= amt

/// returns the taxed value of the deposit
/datum/bank_account/proc/deposit_money(amt)
	var/tax_percent = SSeconomy.tax_groups[tax_group] || 0
	if(tax_exempt || tax_percent <= 0)
		_adjust_money(amt)
		return 0
	var/amount_to_tax = (amt + unpaid_taxes) * tax_percent
	//hold onto the decimal and remember they owe this for next time
	unpaid_taxes = amount_to_tax % 1
	amount_to_tax = floor(amount_to_tax)
	_adjust_money(amt - amount_to_tax)
	return amount_to_tax

/datum/bank_account/proc/adjust_money(amt)
	if(amt != 0)
		_adjust_money(amt)
		return TRUE
	return FALSE

/datum/bank_account/proc/transfer_money(datum/bank_account/from, amount)
	if(frozen || from.frozen)
		return FALSE
	if(from.has_money(amount))
		adjust_money(amount)
		from.adjust_money(-amount)
		return TRUE
	return FALSE

/datum/bank_account/proc/withdraw_money(amount, forced=FALSE)
	if(frozen)
		return
	if(!forced && !SSeconomy.withdrawals_enabled)
		return
	if(amount > account_balance)
		return
	if(amount > SStreasury.treasury_value)
		return
	if(!adjust_money(-amount))
		return
	SStreasury.treasury_value -= amount
	return TRUE
	//log

/datum/bank_account/personal
	id_prefix = "usr"
	//Do not rely on or really use this. This is only for registering a consistent cryo deletion.
	VAR_PROTECTED/mob/living/carbon/human/associated_mob


/datum/bank_account/personal/New(account_holder, tax_group, mob/living/carbon/associated_mob)
	. = ..()
	LAZYADDASSOC(SSeconomy.personal_accounts, identifier, src)
	associate_mob(associated_mob)

/datum/bank_account/personal/Destroy(force, ...)
	. = ..()
	LAZYSET(SSeconomy.personal_accounts, identifier, null)
	if(associated_mob)
		UnregisterSignal(associated_mob, COMSIG_PARENT_QDELETING)
		associated_mob = null
	UnregisterSignal(SSdcs, COMSIG_GLOB_HUMAN_ENTER_CRYO)


//personal accounts delete themselves when their owner leaves
/datum/bank_account/personal/proc/on_owner_cryo(datum/source, mob/living/carbon/human/cryoer)
	SIGNAL_HANDLER
	if((cryoer && cryoer == associated_mob))
		//log
		qdel(src)

/datum/bank_account/personal/proc/on_owner_delete(datum/source)
	SIGNAL_HANDLER
	UnregisterSignal(source, COMSIG_PARENT_QDELETING)
	UnregisterSignal(SSdcs, COMSIG_GLOB_HUMAN_ENTER_CRYO)
	associated_mob = null

/datum/bank_account/personal/proc/associate_mob(mob/living/carbon/human/association)
	if(associated_mob)
		UnregisterSignal(associated_mob, COMSIG_PARENT_QDELETING)
		UnregisterSignal(SSdcs, COMSIG_GLOB_HUMAN_ENTER_CRYO)
	if(istype(association)) // we do a little abysmal dogshit sometimes
		associated_mob = association
		RegisterSignal(SSdcs, COMSIG_GLOB_HUMAN_ENTER_CRYO, PROC_REF(on_owner_cryo))
		RegisterSignal(associated_mob, COMSIG_PARENT_QDELETING, PROC_REF(on_owner_delete))


/datum/bank_account/business
	id_prefix = "bus"
	var/business_name = "Business Account"
	/// The default job type that owns this business
	var/default_owner
	/// a list of job types that have priority ownership over this business. This is used for cryoing and latejoin stuff.
	var/list/default_employees = list()


	/// how much are we paying as a multiplier on payday
	var/payday = 0
	/// are we even doing paydays
	var/suspended = FALSE
	//a list of account identifiers along with their paycheck value.
	var/list/employee_database = list()

/datum/bank_account/business/New(account_holder, tax_group, mob/living/carbon/associated_mob, business_name, payday, do_paydays, default_owner, list/default_employees)
	. = ..()
	LAZYADDASSOC(SSeconomy.business_accounts, identifier, src)
	if(business_name)
		src.business_name = business_name
	src.payday = payday
	suspended = !do_paydays
	if(default_owner)
		src.default_owner = default_owner
	if(length(default_employees))
		src.default_employees = default_employees
	RegisterSignal(SSdcs, COMSIG_GLOB_JOB_AFTER_SPAWN, PROC_REF(on_job_spawn))

/datum/bank_account/business/Destroy(force, ...)
	. = ..()
	LAZYSET(SSeconomy.business_accounts, identifier, null)
	for(var/emp_id in employee_database)
		if(SSeconomy.bank_accounts[emp_id])
			UnregisterSignal(UnregisterSignal(SSeconomy.bank_accounts[emp_id], COMSIG_PARENT_QDELETING, PROC_REF(fire_employee)))

/// Checks for jobs that should be added to this payroll
/datum/bank_account/business/proc/on_job_spawn(datum/source, datum/job/job, mob/living/spawned, client/player_client)
	SIGNAL_HANDLER
	var/is_owner = istype(job, default_owner)
	var/paycheck = default_employees[job]
	if(!(is_owner || paycheck))
		return
	var/datum/dna/dna = spawned.has_dna()
	if(!dna || !dna.unique_identity)
		return
	var/identity = md5(dna.unique_identity)
	var/datum/bank_account/personal/account = SSeconomy.get_owned_personal_account(identity)
	if(!account)
		message_admins("[player_client.ckey] joined as [job.title]. They were supposed to be added to business [business_name], but had no bank account.")
		return
	if(is_owner)
		SSeconomy.change_account_access(identity, identifier, new_permissions = ACCOUNT_PERMS_OWNER)
	if(paycheck) // assigns payroll
		hire_employee(account, paycheck)

/datum/bank_account/business/proc/hire_employee(datum/bank_account/personal/employee, starting_pay=0)
	if(!istype(employee))
		return
	if(employee_database[employee.identifier])
		return
	RegisterSignal(employee, COMSIG_PARENT_QDELETING, PROC_REF(fire_employee))
	employee_database[employee.identifier] = starting_pay

/datum/bank_account/business/proc/fire_employee(datum/bank_account/personal/employee)
	UnregisterSignal(employee, COMSIG_PARENT_QDELETING, PROC_REF(fire_employee))
	employee_database -= employee.identifier

//todo logs
/datum/bank_account/business/proc/payday()
	if(suspended)
		return FALSE
	clean_and_sort_employees()
	if(payday <= 0 || !length(employee_database))
		return FALSE
	if(frozen)
		return FALSE
	var/total_payday = total_payday()
	//this is kinda like a more efficient round robin
	//if we fail, we still want to pay everyone a share relative to the remaining balance
	var/pay_failure_coefficient = 1
	if(account_balance < total_payday)
		//log
		pay_failure_coefficient = account_balance / total_payday
	for(var/employee_id in employee_database)
		if(employee_database[employee_id] <= 0)
			continue
		var/paycheck = round(employee_database[employee_id] * payday * pay_failure_coefficient)
		transfer_money(SSeconomy.personal_accounts[employee_id], paycheck)

//can't use values_sum due to rounding. This also assumes a clean list
/datum/bank_account/business/proc/total_payday()
	if(payday <= 0)
		return 0
	var/total = 0
	for(var/emp_id in employee_database)
		total += round(employee_database[emp_id] * payday)
	return total

/datum/bank_account/business/proc/clean_and_sort_employees()
	var/list/new_employees = list()
	//checks for accounts that don't exists
	for(var/emp_id in employee_database)
		if(istype(LAZYACCESS(SSeconomy.personal_accounts, emp_id), /datum/bank_account/personal))
			new_employees[emp_id] = max(0, employee_database[emp_id])
	// sort remaining accounts by their paycheck value
	if(length(new_employees))
		sortTim(new_employees, GLOBAL_PROC_REF(cmp_numeric_dsc), TRUE)
	employee_database = new_employees
