
/datum/bank_account
	var/account_holder = "King Assripper"
	var/account_balance = 0
	var/account_status = ACCOUNT_STATUS_OPEN
	/// will this add to SStreasury?
	var/add_to_accounts = TRUE

	var/paycheck = 0
	var/paycheck_department = ACCOUNT_OTHER

	/// The tax group as defined on SStreasury
	var/tax_group = TAX_FOREIGN
	/// An override from the tax group to ignore taxes
	var/tax_exempt = FALSE
	///goes up if you underflow during deposits
	var/unpaid_taxes = 0

/datum/bank_account/New(newname, _paycheck)
	if(add_to_accounts)
		SSeconomy.bank_accounts += src
	account_holder = newname
	paycheck = _paycheck

/datum/bank_account/Destroy()
	if(add_to_accounts)
		SSeconomy.bank_accounts -= src
	return ..()

/datum/bank_account/proc/_adjust_money(amt)
	account_balance += amt

/datum/bank_account/proc/has_money(amt)
	return account_balance >= amt

/// returns the taxed value of the deposit
/datum/bank_account/proc/deposit_money(amt)
	var/tax_percent = SStreasury.deposit_taxes[tax_group] || 0
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
	if((amt < 0 && has_money(-amt)) || amt > 0)
		_adjust_money(amt)
		return TRUE
	return FALSE

/datum/bank_account/proc/transfer_money(datum/bank_account/from, amount)
	if(from.has_money(amount))
		adjust_money(amount)
		from.adjust_money(-amount)
		return TRUE
	return FALSE

/datum/bank_account/proc/payday(amt_of_paychecks, free = FALSE)
	var/money_to_transfer = paycheck * amt_of_paychecks
	if(free)
		adjust_money(money_to_transfer)
		return TRUE
	var/datum/bank_account/D = SStreasury.department_accounts[paycheck_department]
	if(!D)
		return FALSE
	return transfer_money(D, round(money_to_transfer*(D.account_balance*0.01),1))

/datum/bank_account/department
	account_holder = "Department"
	add_to_accounts = FALSE
	var/pay_sum = 0

/datum/bank_account/department/New(dep_id, _pay_sum)
	account_holder = dep_id
	paycheck_department = dep_id
	pay_sum = _pay_sum
	SStreasury.department_accounts[dep_id] = src

/datum/bank_account/remote // Bank account not belonging to the local station
	add_to_accounts = FALSE
