/obj/structure/fake_machine/atm
	name = "MEISTER"
	desc = "Stores and withdraws currency for accounts managed by the Kingdom."
	icon = 'icons/roguetown/misc/machines.dmi'
	icon_state = "meister"
	base_icon_state = "meister"
	density = FALSE
	blade_dulling = DULLING_BASH
	SET_BASE_PIXEL(0, 32)

	/// the real name of the person who is logged in
	var/login_user

	COOLDOWN_DECLARE(use_cooldown)


/obj/structure/fake_machine/atm/examine(mob/user)
	. += ..()
	if(user.can_read(src))
		. += span_info("The current tax rates:")
		for(var/tax_group in SSeconomy.tax_groups)
			. += span_info("\t[tax_group]: [SSeconomy.tax_groups[tax_group]]")

/obj/structure/fake_machine/atm/update_icon_state()
	. = ..()
	var/suffix = ""
	if(obj_broken)
		suffix = "_broken"
	else if(login_user)
		suffix = "_bloody"
	icon_state = "[base_icon_state][suffix]"

/obj/structure/fake_machine/atm/attack_hand(mob/user)
	if(!COOLDOWN_FINISHED(src, use_cooldown))
		return
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	if(HAS_TRAIT(user, TRAIT_MATTHIOS_CURSE) && prob(33))
		to_chat(H, span_warning("The idea repulses me!"))
		H.cursed_freak_out()
		return
	if(login_user)
		withdraw()
		return
	COOLDOWN_START(src, use_cooldown, 1 SECONDS)
	var/list/response_args = login(H.has_hand_for_held_index(H.active_hand_index))
	if(response_args)
		addtimer(CALLBACK(src, PROC_REF(respond), response_args[1], response_args[2], response_args[3]), 0.3 SECONDS)
	update_appearance(UPDATE_ICON_STATE)

/obj/structure/fake_machine/atm/attackby(obj/item/P, mob/user, params)
	if(user.cmode || !ishuman(user))
		return ..()
	if(!COOLDOWN_FINISHED(src, use_cooldown))
		return
	COOLDOWN_START(src, use_cooldown, 1 SECONDS)
	if(!login_user)
		if(isbodypart(P))
			var/list/response_args = login(P)
			if(response_args)
				addtimer(CALLBACK(src, PROC_REF(respond), response_args[1], response_args[2], response_args[3]), 0.3 SECONDS)
			update_appearance(UPDATE_ICON_STATE)
			return
		if(istype(P, /obj/item/coin) && !istype(P, /obj/item/coin/inqcoin))
			deposit(P)
			return
		say("Submit your fingers for inspection.")
		playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
		return

	if(!istype(P, /obj/item/coin))
		say("Invalid deposit.")
		playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
		return
	if(istype(P, /obj/item/coin/inqcoin))
		say("Unrecognized currency.")
		playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
		return
	var/mob/living/carbon/human/H = user
	if(HAS_TRAIT(user, TRAIT_MATTHIOS_CURSE) && prob(33))
		to_chat(H, span_warning("The idea repulses me!"))
		H.cursed_freak_out()
		return
	var/datum/bank_account/account = SSeconomy.bank_accounts[login_user]
	if(!account || account.frozen)
		say("This account is unavailable.")
		playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
		return
	deposit(P, user)

//returns the sound and response of the login attempt as well as handling the login itself
/obj/structure/fake_machine/atm/proc/login(obj/item/bodypart/login_limb)
	if(!isbodypart(login_limb))
		return null
	var/datum/dna/dna
	if(login_limb.status == BODYPART_ORGANIC && !login_limb.skeletonized)
		dna = login_limb.original_owner.has_dna()
	//there is an unfortunate issue with doing this from a DNA reference from the owner.
	//if a limb is severed it doesn't have its own copy of the original DNA.
	//it references the mob's dna, so if that limb's owner's dna chain changes (like an assassin or wabbajack),
	//that arm's DNA mechanically also updates to that.
	playsound(login_limb, 'sound/combat/hits/bladed/genstab (1).ogg', 100, FALSE, -1)
	if(!dna || !(dna.species && (NOBLOOD in dna.species.species_traits)))
		return list("No blood detected.", 'sound/misc/machinequestion.ogg', -1)
	if(dna.real_name in GLOB.outlawed_players)
		COOLDOWN_START(src, use_cooldown, 5 SECONDS)
		return list("OUTLAW DETECTED! REFUSING SERVICE!", 'sound/misc/jumpscare (1).ogg', 2)

	//todo
	var/citizen_enabled = TRUE
	if(dna.real_name in SSeconomy.bank_accounts)
		var/datum/bank_account/account = SSeconomy.bank_accounts[dna.real_name]
		if(account.frozen)
			return list("Your account has been frozen.", 'sound/misc/machinequestion.ogg', -1)
	else
		var/datum/job/target_job = SSjob.GetJob(dna.holder.job)
		target_job = target_job?.parent_job || target_job
		if(!target_job || (!target_job.give_bank_account && citizen_enabled))
			return list("You are not a citizen of [SSmapping.config.map_name].", 'sound/misc/machinequestion.ogg', -1)
	login_user = dna.unique_identity

/obj/structure/fake_machine/atm/proc/respond(message, sound, extrarange)
	say(message)
	playsound(src, sound, 100, FALSE, extrarange)

/obj/structure/fake_machine/atm/proc/deposit(obj/item/P, mob/living/user)
	var/val = P.get_real_price()
	if(val < 1)
		return
	var/list/deposit_results = SSeconomy.generate_money_account(P.get_real_price(), login_user)
	playsound(src, 'sound/misc/coininsert.ogg', 100, FALSE, -1)
	if(islist(deposit_results))
		record_round_statistic(STATS_MAMMONS_DEPOSITED, deposit_results[1] - deposit_results[2])
		if(deposit_results[2] != 0)
			say("Your deposit was taxed [deposit_results[2]] mammon.")
			record_featured_stat(FEATURED_STATS_TAX_PAYERS, user, deposit_results[2])
			record_round_statistic(STATS_TAXES_COLLECTED, deposit_results[2])
	else
		say("Your donation was successful.")
	qdel(P)

/obj/structure/fake_machine/atm/proc/withdraw(mob/living/user, mob/living/carbon/dna_user)
	var/datum/bank_account/account = SSeconomy.bank_accounts[login_user]
	if(!account || account.frozen)
		say("This account is unavailable.")
		playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
		return
	if(!SSeconomy.withdrawals_enabled)
		say("Withdrawals are not allowed at this time.")
		playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
		return
	if(account.account_balance == 0)
		say("Your balance is nothing.")
		return
	if(account.account_balance < 0)
		say("Your account is in a debt of [account.account_balance * -1] mammon.")
		return

	var/list/choices = list("BRONZE" = 1)
	if(account.has_money(5))
		choices["SILVER"] = 5
		if(account.has_money(10))
			choices["GOLD"] = 10

	var/selection = input(user, "Balance: [account.account_balance]", src) as null|anything in choices
	if(!selection || QDELETED(src) || QDELETED(user))
		return
	var/mod = choices[selection]
	var/coin_amt = input(user, "You may withdraw [round(account.account_balance/mod)] [selection] COINS from your account.", src) as null|num
	if(!selection || QDELETED(src) || QDELETED(user))
		return
	coin_amt = round(coin_amt)
	if(coin_amt < 1)
		return
	if(!Adjacent(user))
		return
	if(!account.has_money(coin_amt*mod))
		playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
		return
	if(!SSeconomy.withdraw_money_account(coin_amt*mod, login_user))
		playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
		return
	record_round_statistic(STATS_MAMMONS_WITHDRAWN, coin_amt * mod)
	budget2change(coin_amt*mod, user, selection)
