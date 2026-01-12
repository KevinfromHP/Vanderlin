/datum/action/cooldown/spell/appraise
	name = "Secular Appraise"
	desc = "Check how much someone has."
	button_icon_state = "appraise"
	has_visual_effects = FALSE
	cast_range = 2
	associated_skill = /datum/skill/misc/reading
	charge_required = FALSE
	cooldown_time = 5 SECONDS
	spell_cost = 0

/datum/action/cooldown/spell/appraise/is_valid_target(atom/cast_on)
	. = ..()
	if(!.)
		return
	return ishuman(cast_on)

/datum/action/cooldown/spell/appraise/cast(mob/living/carbon/human/cast_on)
	. = ..()
	var/mammons_on_person = get_mammons_in_atom(cast_on)
	var/mammons_in_bank = 0
	if(cast_on.has_dna())
		var/datum/bank_account/account = SSeconomy.bank_accounts[cast_on.dna.unique_identity]
		mammons_in_bank = account?.account_balance || 0
	to_chat(owner, (span_notice("[cast_on] has [mammons_on_person] mammons on them, [mammons_in_bank] in their meister, for a total of [mammons_on_person + mammons_in_bank] mammons.")))

/datum/action/cooldown/spell/appraise/holy
	name = "Appraise"

	spell_type = SPELL_MIRACLE
	antimagic_flags = MAGIC_RESISTANCE_HOLY
	associated_skill = /datum/skill/magic/holy
