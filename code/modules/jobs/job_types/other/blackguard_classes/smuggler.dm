/datum/job/smuggler
	title = "Blackguard Smuggler"
	flag = THIEF
	department_flag = PEASANTS
	job_flags = (JOB_SHOW_IN_CREDITS | JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE)
	display_order = JDO_THIEF_LEADER
	faction = FACTION_STATION
	total_positions = 1
	spawn_positions = 1
	min_pq = 12


	shows_in_list = FALSE
	//TODO:  when racelock PR gets pushed change this
	allowed_races = ALL_PLAYER_RACES_BY_NAME

	outfit = /datum/outfit/job/thief/smuggler
	cmode_music = 'sound/music/cmode/adventurer/CombatRogue.ogg'

/datum/job/smuggler/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
	. = ..()
	if(ishuman(L))
		var/mob/living/carbon/human/H = L
		ADD_TRAIT(H, TRAIT_THIEVESGUILD, TRAIT_GENERIC)
		H.grant_language(/datum/language/thievescant)
		to_chat(H, "<span class='info'>I can gesture in thieves' cant with ,t before my speech.</span>")

/datum/outfit/job/thief/smuggler
	head = /obj/item/clothing/head/roguehood/brown
	neck = /obj/item/clothing/neck/gorget
	cloak = /obj/item/clothing/cloak/cape/drifter
	armor = /obj/item/clothing/armor/leather/splint
	shirt = /obj/item/clothing/armor/gambeson/light
	gloves = /obj/item/clothing/gloves/fingerless
	backl = /obj/item/storage/backpack/backpack //override
	backpack_contents = list(/obj/item/key/thieves_guild, /obj/item/restraints/legcuffs/beartrap/crafted)
	belt = /obj/item/storage/belt/leather/knifebelt/black/steel //override
	beltl = /obj/item/weapon/knife/cleaver/combat
	beltr = /obj/item/storage/belt/pouch/coins/mid

/datum/outfit/job/thief/smuggler/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.mind)
		H.mind.adjust_skillrank(/datum/skill/combat/axesmaces, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/bows, pick(0, 0, 1), TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/crossbows, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/knives, 4, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/wrestling, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/craft/alchemy, 1, TRUE)
		H.mind.adjust_skillrank(/datum/skill/craft/bombs, 1, TRUE)
		H.mind.adjust_skillrank(/datum/skill/craft/crafting, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/craft/traps, 4, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/athletics, 4, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/climbing, 5, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/lockpicking, 4, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/reading, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/sewing, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/sneaking, 5, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/stealing, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/swimming, 4, TRUE)
	H.change_stat(STATKEY_PER, 1)
	H.change_stat(STATKEY_END, 1)
	H.change_stat(STATKEY_SPD, 2)
	ADD_TRAIT(H, TRAIT_DODGEEXPERT, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_LIGHT_STEP, TRAIT_GENERIC)

/datum/outfit/job/thief/smuggler/color_clothing(mob/living/carbon/human/H, thiefColor)
	if(H)
		var/obj/item/clothing/thiefHood = H.get_item_by_slot(SLOT_HEAD)
		thiefHood?.color = thiefColor
		thiefHood?.update_icon()

		var/obj/item/clothing/thiefCloak = H.get_item_by_slot(SLOT_CLOAK)
		thiefCloak?.color = thiefColor
		thiefCloak?.update_icon()

		var/obj/item/clothing/thiefShirt = H.get_item_by_slot(SLOT_SHIRT)
		thiefShirt?.color = thiefColor
		thiefShirt?.update_icon()
	..()
