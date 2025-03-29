/datum/job/thief/leader
	title = "Blackguard Smuggler"
	var/base_tutorial = "<br>Maybe you were an orphan taken in by the matron. Maybe you're an ex-bandit looking to lie low. Maybe you're a freedom-fighter trying to undermine noble oppression. Whatever the reason, it's landed you in the sewers - the Thieves Guild to be precise.<br><br> \
	Plenty of people in this town need something they can't get anywhere else, be it barred by church or state. Someone beat up, something stolen, something bought, something fenced. This need is what you thrive off of. The possibilities for profit are nearly endless... so long as you're not caught.<br>"
	flag = THIEF
	department_flag = PEASANTS
	job_flags = (JOB_SHOW_IN_CREDITS | JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE)
	display_order = JDO_THIEF_LEADER
	faction = FACTION_STATION
	total_positions = 1
	spawn_positions = 1
	min_pq = 12

	shows_in_list = FALSE
	allowed_races = ALL_PLAYER_RACES_BY_NAME


	outfit = /datum/outfit/job/thief/leader
	cmode_music = 'sound/music/cmode/adventurer/CombatRogue.ogg'



/datum/outfit/job/thief/leader/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.mind)
		H.mind.adjust_skillrank(/datum/skill/combat/axesmaces, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/bows, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/crossbows, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/knives, 4, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/craft/alchemy, 1, TRUE)
		H.mind.adjust_skillrank(/datum/skill/craft/bombs, 1, TRUE)
		H.mind.adjust_skillrank(/datum/skill/craft/crafting, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/craft/traps, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/climbing, 5, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/lockpicking, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/medicine, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/reading, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/sewing, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/sneaking, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/stealing, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/swimming, 3, TRUE)
	neck = /obj/item/clothing/neck/phys
	armor = /obj/item/clothing/armor/leather/jacket/apothecary
	gloves = /obj/item/clothing/gloves/leather/phys
	belt = /obj/item/storage/belt/leather/knifebelt/black/steel
	belt_l = /obj/item/storage/belt/pouch/coins/mid
	belt_r = /obj/item/weapon/knife/cleaver/combat
	backpack_contents = list(/obj/item/key/thieves_guild)
	pants = /obj/item/clothing/pants/trou/leather/advanced
	H.change_stat(STATKEY_INT, 2)
	H.change_stat(STATKEY_PER, 1)
	H.change_stat(STATKEY_END, 1)
	H.change_stat(STATKEY_SPD, 2)
	ADD_TRAIT(H, TRAIT_DODGEEXPERT, TRAIT_GENERIC)


/datum/outfit/job/thief/cutthroat/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	if(H)
		var/obj/clothing/shirt/tunic/thiefShirt = new()
		thiefShirt.color = get_thief_color(H)
		H.equip_to_slot(thiefcloak, SLOT_SHIRT, TRUE)

		var/obj/item/clothing/face/shepherd/clothmask/thiefmask = new()
		thiefmask.color = thiefShirt.color
		H.equip_to_slot(thiefmask, SLOT_WEAR_MASK, TRUE)
		thiefmask.AdjustClothes(H)
