/datum/advclass/thief/muscle
	name = "Blackguard Muscle"
	tutorial = ""
	outfit = /datum/outfit/job/thief/muscle
	category_tags = list(CTAG_THIEF)
	maximum_possible_slots = 3


/datum/outfit/job/thief/muscle
	head = /obj/item/clothing/head/helmet/leather/headscarf
	neck = /obj/item/clothing/neck/gorget
	cloak = /obj/item/clothing/cloak/cape/thief
	armor = /obj/item/clothing/armor/cuirass/iron
	shirt = /obj/item/clothing/shirt/undershirt/black
	gloves = /obj/item/clothing/gloves/angle
	beltr = /obj/item/weapon/mace/steel/morningstar
	beltl = /obj/item/weapon/shield/tower/buckleriron
	backpack_contents = list(/obj/item/key/thieves_guild, /obj/item/storage/belt/pouch/coins/poor)

/datum/outfit/job/thief/muscle/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.mind)
		H.mind.adjust_skillrank(/datum/skill/combat/axesmaces, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/knives, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/shields, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/swords, pick(0, 0, 1), TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/craft/traps, 1, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/climbing, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/lockpicking, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/reading, 1, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/sneaking, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/stealing, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/swimming, 3, TRUE)
	ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
	H.change_stat(STATKEY_STR, 2)
	H.change_stat(STATKEY_CON, 1)
	H.change_stat(STATKEY_END, 1)

/datum/outfit/job/thief/muscle/color_clothing(mob/living/carbon/human/H, thiefColor)
	if(H)
		var/obj/item/clothing/thiefHead = H.get_item_by_slot(SLOT_HEAD)
		thiefHead?.color = thiefColor
		thiefHead?.update_icon()

		var/obj/item/clothing/thiefCloak = H.get_item_by_slot(SLOT_CLOAK)
		thiefCloak?.color = thiefColor
		thiefCloak?.update_icon()
	. = ..()
