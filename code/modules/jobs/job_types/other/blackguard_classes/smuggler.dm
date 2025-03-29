/datum/job/thief/leader
	title = "Blackguard Smuggler"
	display_order = JDO_THIEF_LEADER
	total_positions = 1
	spawn_positions = 1
	min_pq = 12

	advclass_cat_rolls = null

	outfit = /datum/outfit/job/thief/leader
	cmode_music = 'sound/music/cmode/adventurer/CombatRogue.ogg'

/datum/job/thief/leader/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
	. = ..()
	if(ishuman(L))
		var/mob/living/carbon/human/H = L
		ADD_TRAIT(H, TRAIT_THIEVESGUILD, TRAIT_GENERIC)
		ADD_TRAIT(H, TRAIT_LIGHT_STEP, TRAIT_GENERIC)
		H.grant_language(/datum/language/thievescant)
		to_chat(H, "<span class='info'>I can gesture in thieves' cant with ,t before my speech.</span>")

/datum/outfit/job/thief/leader
	neck = /obj/item/storage/belt/pouch/coins/mid
	armor = /obj/item/clothing/armor/leather/jacket/apothecary
	gloves = /obj/item/clothing/gloves/fingerless
	pants = /obj/item/clothing/pants/trou/leather/advanced //override
	belt = /obj/item/storage/belt/leather/knifebelt/black/steel //override
	beltr = /obj/item/weapon/knife/cleaver/combat
	backpack_contents = list(/obj/item/key/thieves_guild)

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
		H.mind.adjust_skillrank(/datum/skill/misc/lockpicking, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/medicine, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/reading, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/sewing, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/sneaking, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/stealing, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/swimming, 3, TRUE)
	H.change_stat(STATKEY_INT, 2)
	H.change_stat(STATKEY_PER, 1)
	H.change_stat(STATKEY_END, 1)
	H.change_stat(STATKEY_SPD, 2)
	ADD_TRAIT(H, TRAIT_DODGEEXPERT, TRAIT_GENERIC)

/datum/outfit/job/thief/leader/color_clothing(mob/living/carbon/human/H, thiefColor)
	..()
	if(H)
		var/obj/item/clothing/shirt/thiefShirt = H.get_item_by_slot(SLOT_SHIRT)
		thiefShirt?.color = thiefColor
		thiefShirt?.update_icon()
