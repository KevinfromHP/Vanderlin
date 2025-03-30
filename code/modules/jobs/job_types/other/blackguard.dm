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
	shirt = /obj/item/clothing/shirt/undershirt/black
	pants = /obj/item/clothing/pants/trou/leather
	shoes = /obj/item/clothing/shoes/boots
	backl = /obj/item/storage/backpack/satchel
	belt = /obj/item/storage/belt/leather

/datum/job/thief/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
	. = ..()
	if(ishuman(L))
		var/mob/living/carbon/human/H = L
		if(advclass_cat_rolls)
			H.advsetup = 1
			H.invisibility = INVISIBILITY_MAXIMUM
			H.become_blind("advsetup")

/datum/outfit/job/thief/pre_equip(mob/living/carbon/human/H)
	..()
	ADD_TRAIT(H, TRAIT_THIEVESGUILD, TRAIT_GENERIC)
	H.grant_language(/datum/language/thievescant)
	to_chat(H, "<span class='info'>I can gesture in thieves' cant with ,t before my speech.</span>")

/datum/outfit/job/thief/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	..()
	if(H)
		var/thiefColor = get_thief_color(H)
		color_clothing(H, thiefColor)


/datum/outfit/job/thief/proc/color_clothing(mob/living/carbon/human/H, thiefColor)
	var/obj/item/clothing/face/shepherd/clothmask/thiefmask = new()
	thiefmask.color = thiefColor
	H.equip_to_slot(thiefmask, SLOT_WEAR_MASK, TRUE)
	thiefmask.AdjustClothes(H)
	H.update_body()


/datum/outfit/job/thief/proc/get_thief_color(mob/living/carbon/human/H)
	var/list/thief_colors = list(/*"Bleached White"	="#FFFFFF"*/)
	thief_colors |= GLOB.peasant_dyes
	var/color_selection = input(H,"What color was I again?","VANDERLIN","Soot Black") in thief_colors
	return thief_colors[color_selection]
