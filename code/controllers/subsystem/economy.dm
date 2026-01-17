/**
 * Think of this as the banking app.
 * The treasury subsystem is where the money actually is. None of the money that's in here is actually real.
 */
SUBSYSTEM_DEF(economy)
	name = "Economy"
	wait = 5 MINUTES
	init_order = INIT_ORDER_ECONOMY
	runlevels = RUNLEVEL_GAME

	var/accounts_created = 0
	/// a list of all bank accounts.
	var/list/datum/bank_account/bank_accounts = list()
	/// All existing personal accounts.
	var/list/datum/bank_account/personal/personal_accounts = list()
	/// All existing business accounts.
	var/list/datum/bank_account/business/business_accounts = list()
	/// An associative list of identities (fingerprints) tied to bank account id's, and the perms of access
	var/list/list/access_permissions = list()

	var/withdrawals_enabled = TRUE
	var/list/tax_groups = list(
		TAX_FOREIGN	= 0.3,
		TAX_CITIZEN	= 0.15,
		TAX_LORD = 0
	)
	var/list/bank_logs = list()


/datum/controller/subsystem/economy/Initialize(timeofday)
	return ..()

/datum/controller/subsystem/economy/fire(resumed = 0)
	return

/*
* These procs are all called directly from
* things outside of the system.
*/
/datum/controller/subsystem/economy/proc/create_personal_account(identity, initial_deposit, account_holder, paycheck, tax_group)
	if(!identity)
		return
	var/datum/bank_account/personal/account = new(account_holder, tax_group, paycheck)
	LAZYORASSOCLIST(access_permissions, identity, list(account.identifier = ACCOUNT_PERMS_OWNER))
	account.account_balance += initial_deposit
	return account

/// Returns a list of accessible datum accounts and their account permissions as an associative list.
/datum/controller/subsystem/economy/proc/get_user_accounts(identity)
	if(!identity)
		return
	var/list/accessible_accounts
	for(var/bank_id in LAZYACCESS(access_permissions, identity))
		if(access_permissions[identity][bank_id] < ACCOUNT_PERMS_TRUSTED)
			continue
		var/datum/bank_account/account = LAZYACCESS(bank_accounts, bank_id)
		if(!account)
			continue
		LAZYADDASSOC(accessible_accounts, account, access_permissions[identity][bank_id])
	return accessible_accounts

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
	amt = round(amt)

	var/datum/bank_account/account = bank_accounts[target]
	if(!account?.adjust_money(amt))
		return FALSE
	//todo logs
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

/datum/controller/subsystem/economy/proc/log_to_steward(log)
	SStreasury.log_to_steward(log)
