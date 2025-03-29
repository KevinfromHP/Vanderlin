/datum/advclass/thief/rogue
	name = "Stealth Archer"
	tutorial = ""
	outfit = /datum/outfit/job/thief/rogue
	category_tags = list(CTAG_THIEF)
	maximum_possible_slots = 2


/datum/outfit/job/thief/rogue
	head = /obj/item/clothing/head/helmet/leather/headscarf
	neck = /obj/item/clothing/neck/chaincoif/iron
	cloak = /obj/item/clothing/cloak/cape/thief
	armor = /obj/item/clothing/armor/leather/jacket
	shirt = /obj/item/clothing/armor/chainmail/iron //override
	gloves = /obj/item/clothing/gloves/leather
	backr = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow
	backpack_contents = list(/obj/item/key/thieves_guild, /obj/item/weapon/knife/dagger/steel)
	beltr = /obj/item/ammo_holder/quiver/bolts

/datum/outfit/job/thief/rogue/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.mind)
		H.mind.adjust_skillrank(/datum/skill/combat/axesmaces, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/bows, 1, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/crossbows, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/knives, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/unarmed, 1, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/wrestling, 1, TRUE)
		H.mind.adjust_skillrank(/datum/skill/craft/crafting, 1, TRUE)
		H.mind.adjust_skillrank(/datum/skill/craft/traps, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/climbing, 4, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/lockpicking, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/reading, 1, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/sewing, 1, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/sneaking, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/stealing, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/swimming, 3, TRUE)
	H.change_stat(STATKEY_PER, 3)
	H.change_stat(STATKEY_END, 1)
	H.change_stat(STATKEY_STR, 1)
	ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)

/datum/outfit/job/thief/rogue/color_clothing(mob/living/carbon/human/H, thiefColor)
	. = ..()
	if(H)
		var/obj/item/clothing/thiefHead = H.get_item_by_slot(SLOT_HEAD)
		thiefHead?.color = thiefColor
		thiefHead?.update_icon()

		var/obj/item/clothing/thiefCloak = H.get_item_by_slot(SLOT_CLOAK)
		thiefCloak?.color = thiefColor
		thiefCloak?.update_icon()
