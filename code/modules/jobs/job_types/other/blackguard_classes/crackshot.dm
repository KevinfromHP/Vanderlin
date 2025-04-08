/datum/advclass/thief/crackshot
	name = "Blackguard Crackshot"
	tutorial = ""
	outfit = /datum/outfit/job/thief/crackshot
	category_tags = list(CTAG_THIEF)
	maximum_possible_slots = 3


/datum/outfit/job/thief/crackshot
	head = /obj/item/clothing/head/helmet/leather/headscarf
	neck = /obj/item/clothing/neck/chaincoif/iron
	cloak = /obj/item/clothing/cloak/cape/drifter
	armor = /obj/item/clothing/armor/leather/hide
	shirt = /obj/item/clothing/shirt/shortshirt/merc
	gloves = /obj/item/clothing/gloves/leather
	backr = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow
	backpack_contents = list(/obj/item/key/thief, /obj/item/storage/belt/pouch/coins/poor)
	beltl = /obj/item/weapon/knife/dagger/steel
	beltr = /obj/item/ammo_holder/quiver/bolts

/datum/outfit/job/thief/crackshot/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.mind)
		H.mind.adjust_skillrank(/datum/skill/combat/axesmaces, pick(1, 1, 2), TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/bows, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/crossbows, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/knives, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/unarmed, 1, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/wrestling, 1, TRUE)
		H.mind.adjust_skillrank(/datum/skill/craft/traps, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/climbing, 4, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/lockpicking, 1, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/reading, 1, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/sewing, 1, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/sneaking, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/stealing, 1, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/swimming, 3, TRUE)
	H.change_stat(STATKEY_PER, 3)
	H.change_stat(STATKEY_END, 1)
	H.change_stat(STATKEY_STR, 1)
	ADD_TRAIT(H, TRAIT_DODGEEXPERT, TRAIT_GENERIC)

/datum/outfit/job/thief/crackshot/color_clothing(mob/living/carbon/human/H, thiefColor)
	if(H)
		var/obj/item/clothing/thiefHead = H.get_item_by_slot(SLOT_HEAD)
		thiefHead?.color = thiefColor
		thiefHead?.update_icon()

		var/obj/item/clothing/thiefCloak = H.get_item_by_slot(SLOT_CLOAK)
		thiefCloak?.color = thiefColor
		thiefCloak?.update_icon()
	..()
