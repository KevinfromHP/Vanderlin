/datum/job/thief
	title = "Blackguard"
	var/base_tutorial = "<br>Maybe you were an orphan taken in by the matron. Maybe you're an ex-bandit looking to lie low. Maybe you're a freedom-fighter trying to undermine noble oppression. Whatever the reason, it's landed you in the sewers - the Thieves Guild to be precise.<br><br> \
	Plenty of people in this town need something they can't get anywhere else, be it barred by church or state. Someone beat up, something stolen, something bought, something fenced. This need is what you thrive off of. The possibilities for profit are nearly endless... so long as you're not caught.<br>"
	flag = THIEF
	department_flag = PEASANTS
	job_flags = (JOB_SHOW_IN_CREDITS | JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE)
	display_order = JDO_THIEF
	faction = FACTION_STATION
	total_positions = 4
	spawn_positions = 4
	var/max_positions = 4
	min_pq = 10

	shows_in_list = FALSE
	allowed_races = ALL_PLAYER_RACES_BY_NAME
	advclass_cat_rolls = list(CTAG_THIEF = 20)


	outfit = /datum/outfit/job/thief
	cmode_music = 'sound/music/cmode/adventurer/CombatRogue.ogg'

/datum/job/thief/New()
	. = ..()
	tutorial = base_tutorial + "<br>(The max number of thieves in a round depends on total players)<br>"
	var/datum/callback/cb = CALLBACK(src, TYPE_PROC_REF(/datum/job/thief, calculate_slots))
	SSticker.OnPreRoundSetup(cb)

/datum/job/thief/proc/calculate_slots()
	var/allowed_slots = min(max_positions, 1 + CEILING(SSgamemode.get_correct_popcount() / 20, 1))
	src.spawn_positions = allowed_slots
	src.total_positions = allowed_slots
	tutorial = base_tutorial //so the extra info won't show in chat when they join.

/datum/outfit/job/thief
	pants = /obj/item/clothing/pants/trou/leather
	shoes = /obj/item/clothing/shoes/boots
	backr = /obj/item/storage/backpack/satchel
	belt = /obj/item/storage/belt/leather
	beltl = /obj/item/storage/belt/pouch/coins/poor

/datum/job/thief/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
	. = ..()
	if(ishuman(L))
		var/mob/living/carbon/human/H = L
		H.advsetup = 1
		H.invisibility = INVISIBILITY_MAXIMUM
		H.become_blind("advsetup")
		ADD_TRAIT(H, TRAIT_THIEVESGUILD, TRAIT_GENERIC)
		ADD_TRAIT(H, TRAIT_LIGHT_STEP, TRAIT_GENERIC)
		H.grant_language(/datum/language/thievescant)
		to_chat(H, "<span class='info'>I can gesture in thieves' cant with ,t before my speech.</span>")


/datum/outfit/job/thief/proc/get_thief_color(mob/living/carbon/human/H)
	var/list/thief_colors = list("Bleached White"	="#FFFFFF")
	thief_colors |= GLOB.peasant_dyes
	thief_colors |= GLOB.noble_dyes
	var/color_selection = input(H,"What color was I again?","Thief Color","Ash Grey") in thief_colors
	return thief_colors[color_selection]
