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
		TAX_FOREIGN	= 0.4,
		TAX_CITIZEN	= 0.2,
		TAX_BUSINESS = 0.1,
		TAX_LORD = 0
	)
	/// Every bank log. Bank accounts individually store the indices of the logs they are relevant to
	var/list/bank_logs = list()
	/// used for logs so they still have a name
	var/list/dead_accounts = list()


/datum/controller/subsystem/economy/Initialize(timeofday)
	return ..()

/datum/controller/subsystem/economy/fire(resumed = 0)
	return

/*
* These procs are all called directly from
* things outside of the system.
*/
/// Creates a new personal account for the user.
/datum/controller/subsystem/economy/proc/create_personal_account(identity, initial_deposit, account_holder, tax_group, mob/living/associated_mob)
	if(!identity)
		return
	var/datum/bank_account/personal/account = new(account_holder, tax_group, associated_mob)
	account.account_balance += initial_deposit
	change_account_access(identity, account.identifier, ACCOUNT_PERMS_OWNER)
	return account

/// Changes the account access of a user.
/datum/controller/subsystem/economy/proc/change_account_access(identity, account_id, new_permissions=ACCOUNT_PERMS_NONE)
	if(!identity)
		return
	if(!bank_accounts[account_id])
		return
	if(new_permissions == ACCOUNT_PERMS_NONE)
		LAZYREMOVEASSOC(access_permissions, identity, account_id)
		return
	// fuck dm
	LAZYADDASSOC(access_permissions, identity, list("[account_id]" = new_permissions))

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

/// Returns the first personal account that a user has.
/datum/controller/subsystem/economy/proc/get_owned_personal_account(identity)
	var/list/their_accounts = get_user_accounts(identity)
	var/datum/bank_account/personal/account
	for(account in their_accounts)
		if(their_accounts[account] == ACCOUNT_PERMS_OWNER)
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

/datum/controller/subsystem/economy/proc/make_bank_log(to_log, list/involved_accounts)
	if(SSticker.current_state < GAME_STATE_PLAYING)
		return
	var/timestamp = "[station_time_timestamp("hh:mm")] the [thtotext(GLOB.totaldayspassed)]"
	bank_logs += "$TIME([timestamp])[to_log]"
	for(var/datum/bank_account/account in involved_accounts)
		account.log_mentions += length(bank_logs)


/datum/controller/subsystem/economy/proc/log_to_steward(log)
	SStreasury.log_to_steward(log)
