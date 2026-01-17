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

/datum/bank_account/personal
	id_prefix = "usr"

/datum/bank_account/personal/New(account_holder, paycheck_department, paycheck, tax_group)
	. = ..()
	LAZYADDASSOC(SSeconomy.personal_accounts, identifier, src)

/datum/bank_account/personal/Destroy(force, ...)
	. = ..()
	LAZYSET(SSeconomy.personal_accounts, identifier, null)

/datum/bank_account/business
	id_prefix = "bus"
	var/business_name = "Business Account"
	/// how much are we paying as a multiplier on payday
	var/payday = 0
	/// are we even doing paydays
	var/suspended = FALSE
	//a list of account identifiers along with their paycheck value.
	var/list/employee_database = list()

/datum/bank_account/business/New(account_holder, paycheck, tax_group, business_name)
	. = ..()
	LAZYADDASSOC(SSeconomy.business_accounts, identifier, src)
	if(business_name)
		src.business_name = business_name

/datum/bank_account/business/Destroy(force, ...)
	. = ..()
	//we keep the identifier so we at least knew it existed
	LAZYSET(SSeconomy.business_accounts, identifier, null)

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
