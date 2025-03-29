/datum/advclass/thief/cutthroat
	name = "Cutthroat"
	tutorial = ""
	outfit = /datum/outfit/job/thief/cutthroat
	category_tags = list(CTAG_THIEF)
	maximum_possible_slots = 2

/datum/outfit/job/thief/cutthroat/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.mind)
		H.mind.adjust_skillrank(/datum/skill/combat/axesmaces, 1, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/knives, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/swords, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/wrestling, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/craft/alchemy, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/craft/bombs, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/craft/cooking, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/craft/crafting, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/craft/traps, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/climbing, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/lockpicking, 1, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/medicine, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/reading, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/sewing, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/sneaking, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/stealing, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/swimming, 3, TRUE)
	neck = /obj/item/clothing/neck/phys
	gloves = /obj/item/clothing/gloves/leather/black
	backl = /obj/item/storage/backpack/satchel/surgbag/basic
	backpack_contents = list(/obj/item/key/thieves_guild, /obj/item/weapon/knife/dagger/steel)
	beltr = /obj/item/weapon/sword/sabre/cutlass
	ADD_TRAIT(H, TRAIT_EMPATH, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_NOSTINK, TRAIT_GENERIC)
	H.change_stat(STATKEY_INT, 2)
	H.change_stat(STATKEY_STR, -1)
	H.change_stat(STATKEY_PER, 1)
	if(H.age == AGE_OLD)
		H.change_stat("speed", -1)
		H.change_stat("intelligence", 1)
		H.change_stat("perception", 1)
		H.mind.adjust_skillrank(/datum/craft/alchemy, 1, TRUE)
		H.mind.adjust_skillrank(/datum/skill/craft/bombs, 1, TRUE)
		H.mind.adjust_skillrank(/datum/craft/cooking, 1, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/reading, 1, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/medicine, 1, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/sewing, 1, TRUE)

/datum/outfit/job/thief/cutthroat/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	if(H)
		var/obj/clothing/shirt/thiefShirt = null
		if(H.gender == MALE)
			thiefShirt = new /obj/clothing/shirt/tunic()
		else
			thiefShirt = new /obj/clothing/shirt/dress/gen()
		thiefShirt.color = get_thief_color(H)
		H.equip_to_slot(thiefcloak, SLOT_SHIRT, TRUE)

		var/obj/item/clothing/armor/leather/jacket/hand/thiefJacket = new()
		thiefJacket.detail_color = CLOTHING_ASH_GREY // to match the gloves
		H.equip_to_slot(thiefJacket, SLOT_ARMOR, TRUE)

		var/obj/item/clothing/face/shepherd/clothmask/thiefmask = new()
		thiefmask.color = thiefShirt.color
		H.equip_to_slot(thiefmask, SLOT_WEAR_MASK, TRUE)
		thiefmask.AdjustClothes(H)
