/datum/bank_account
	var/account_holder = "No Owner"
	var/account_balance = 0

	var/frozen = FALSE

	var/paycheck = 0
	var/paycheck_department = ACCOUNT_OTHER

	/// The tax group as defined on SStreasury
	var/tax_group = TAX_FOREIGN
	/// An override from the tax group to ignore taxes
	var/tax_exempt = FALSE
	///goes up if you underflow during deposits
	var/unpaid_taxes = 0

/datum/bank_account/New(account_holder, paycheck_department=ACCOUNT_OTHER, paycheck=0, tax_group=TAX_FOREIGN)
	src.account_holder = account_holder
	src.paycheck_department = paycheck_department
	src.paycheck = paycheck
	src.tax_group = tax_group
	src.tax_exempt = (tax_group == TAX_LORD)

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

/datum/bank_account/proc/payday()
	if(frozen)
		return FALSE
	var/datum/bank_account/department/D = SSeconomy.payroll_accounts[paycheck_department]
	if(D && D.do_paydays)
		return transfer_money(D, round(D.paycheck * paycheck))
	return FALSE

/datum/bank_account/department
	var/business_name = "Business Account"
	var/do_paydays = FALSE

/datum/bank_account/department/New(business_name, paycheck=0)
	src.business_name = business_name
	src.paycheck = paycheck
	src.paycheck_department = business_name

