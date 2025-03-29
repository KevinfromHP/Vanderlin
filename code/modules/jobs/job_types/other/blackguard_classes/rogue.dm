/datum/advclass/thief/rogue
	name = "Stealth Archer"
	tutorial = ""
	outfit = /datum/outfit/job/thief/rogue
	category_tags = list(CTAG_THIEF)
	maximum_possible_slots = 2

/datum/outfit/job/thief/rogue/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.mind)
		H.mind.adjust_skillrank(/datum/skill/combat/axesmaces, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/bows, 3, TRUE)
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
	shirt = /obj/item/clothing/shirt/undershirt/black
	armor = /obj/item/clothing/armor/leather
	wrists = /obj/item/clothing/wrists/bracers/leather
	gloves = /obj/item/clothing/gloves/fingerless
	backpack_contents = list(/obj/item/key/thieves_guild, /obj/item/weapon/knife/dagger/steel)
	backl = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow
	beltr = /obj/item/ammo_holder/quiver/bolts

	H.change_stat(STATKEY_PER, 3)
	H.change_stat(STATKEY_END, 1)
	H.change_stat(STATKEY_SPD, 1)
	ADD_TRAIT(H, TRAIT_DODGEEXPERT, TRAIT_GENERIC)

/datum/outfit/job/thief/rogue/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	if(H)
		// Give them their cloak- as well as the ability to choose what color they want.
		var/obj/item/clothing/cloak/cape/thief/thiefcape = new()
		thiefcape.color = get_thief_color(H)
		H.equip_to_slot(thiefcape, SLOT_CLOAK, TRUE)

		var/obj/item/clothing/head/roguehood/thiefhood = new()
		thiefhood.color = thiefcape.color
		H.equip_to_slot(thiefhood, SLOT_HEAD, TRUE)

		var/obj/item/clothing/face/shepherd/clothmask/thiefmask = new()
		thiefmask.color = thiefcape.color
		H.equip_to_slot(thiefmask, SLOT_WEAR_MASK, TRUE)
		thiefmask.AdjustClothes(H)
