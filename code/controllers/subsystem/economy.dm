/**
 * Think of this as the banking app.
 * The treasury subsystem is where the money actually is. None of the money that's in here is actually real.
 */
SUBSYSTEM_DEF(economy)
	name = "Economy"
	wait = 5 MINUTES
	init_order = INIT_ORDER_ECONOMY
	runlevels = RUNLEVEL_GAME

	var/list/bank_accounts = list()
	var/list/payroll_accounts = list()
	var/list/business_accounts = list()

	var/withdrawals_enabled = TRUE
	var/list/tax_groups = list(
		TAX_FOREIGN	= 0.3,
		TAX_CITIZEN	= 0.15,
		TAX_LORD = 0
	)

/datum/controller/subsystem/economy/Initialize(timeofday)
	// if there is no map adjustment or it's null in there, use the default
	var/list/payrolls = SSmapping.map_adjustment?.custom_payrolls || GLOB.payroll_default
	for(var/pr_id in payrolls)
		var/list/pr_args = payrolls[pr_id]
		payroll_accounts[pr_id] = new /datum/bank_account/department(pr_args[1], pr_args[2])
	return ..()

/datum/controller/subsystem/economy/fire(resumed = 0)
	return


/*
* These procs are all called directly from
* things outside of the system.
*/
/datum/controller/subsystem/economy/proc/create_bank_account(identity, initial_deposit, account_holder, paycheck_department, paycheck, tax_group)
	if(!identity)
		return
	var/datum/bank_account/account = bank_accounts[identity] //if you somehow manage to call this on an existing job it's a bug, but it'll still add the deposit
	if(!account)
		bank_accounts[identity] = new /datum/bank_account(account_holder, paycheck_department, paycheck, tax_group)
		account = bank_accounts[identity]
	account.account_balance += initial_deposit
	return account

///Deposits money into a character's bank account. Taxes are deducted from the deposit and added to the treasury.
///@param amt: The amount of money to deposit.
///@param identity: The the unique DNA identity of the account's owner.
///@return a list(original deposit, taxed amount) if the money was successfully deposited, FALSE otherwise.
/datum/controller/subsystem/economy/proc/generate_money_account(amt, identity)
	if(!amt)
		return FALSE
	if(!identity)
		return FALSE

	var/datum/bank_account/account = bank_accounts[identity]
	SStreasury.give_money_treasury(amt, account?.account_holder, account) //we still take the mammon, and only announce it if we didn't have an account
	if(!account)
		return FALSE

	var/taxed_amount = account.deposit_money(amt)
	log_to_steward("+[amt] deposited to [account.account_holder] of which taxed [taxed_amount]")
	return list(amt, taxed_amount)

//pays to an account (if it exists).
/datum/controller/subsystem/economy/proc/give_money_account(amt, target, source)
	if(!amt || !target)
		return
	amt = floor(amt)

	var/datum/bank_account/account = bank_accounts[target] || payroll_accounts[target] || business_accounts[target]
	if(!account?.adjust_money(amt))
		return FALSE
	//todo
	if (amt > 0)
		// Player received money
		if(source)
			//send_ooc_note("<b>MEISTER:</b> Your account has received [amt] mammon. ([source])", name = target_name)
			log_to_steward("+[amt] from treasury to [account.account_holder] ([source])")
		else
			//send_ooc_note("<b>MEISTER:</b> Your account has received [amt] mammon.", name = target_name)
			log_to_steward("+[amt] from treasury to [account.account_holder]")
	else if (amt < 0)
		// Player was fined
		if(source)
			//send_ooc_note("<b>MEISTER:</b> Your account was fined [abs(amt)] mammon. ([source])", name = target_name)
			log_to_steward("[abs(amt)] was fined from [account.account_holder] ([source])")
		else
			//send_ooc_note("<b>MEISTER:</b> Your account was fined [abs(amt)] mammon.", name = target_name)
			log_to_steward("[abs(amt)] was fined from [account.account_holder]")

	return TRUE

/datum/controller/subsystem/economy/proc/withdraw_money_account(amt, identity)
	if(!amt)
		return
	var/datum/bank_account/account = bank_accounts[identity]
	if(!account)
		return
	if(amt > account.account_balance)
		return
	if(amt > SStreasury.treasury_value)
		return
	account.adjust_money(-amt)
	SStreasury.treasury_value -= amt
	log_to_steward("[amt] withdrawn from [account.account_holder]")
	return TRUE


/datum/controller/subsystem/economy/proc/log_to_steward(log)
	SStreasury.log_to_steward(log)
