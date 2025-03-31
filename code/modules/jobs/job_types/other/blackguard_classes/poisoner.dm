/datum/advclass/thief/poisoner
	name = "Blackguard Poisoner"
	tutorial = ""
	outfit = /datum/outfit/job/thief/poisoner
	category_tags = list(CTAG_THIEF)
	maximum_possible_slots = 1

/datum/outfit/job/thief/poisoner
	neck = /obj/item/clothing/neck/phys
	armor = /obj/item/clothing/armor/leather/jacket/apothecary
	shirt = /obj/item/clothing/shirt/tunic
	gloves = /obj/item/clothing/gloves/leather/phys
	backr = /obj/item/storage/backpack/satchel/surgbag/basic
	backpack_contents = list(/obj/item/key/thieves_guild, /obj/item/storage/belt/pouch/coins/poor)
	beltl = /obj/item/weapon/knife/dagger/steel
	beltr = /obj/item/weapon/sword/sabre/cutlass

/datum/outfit/job/thief/poisoner/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.mind)
		H.mind.adjust_skillrank(/datum/skill/combat/axesmaces, pick(0, 0, 1), TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/knives, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/swords, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/unarmed, 1, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/wrestling, 1, TRUE)
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
		if(H.age == AGE_OLD)
			H.mind.adjust_skillrank(/datum/skill/craft/alchemy, 1, TRUE)
			H.mind.adjust_skillrank(/datum/skill/craft/bombs, 1, TRUE)
			H.mind.adjust_skillrank(/datum/skill/craft/cooking, 1, TRUE)
			H.mind.adjust_skillrank(/datum/skill/misc/reading, 1, TRUE)
			H.mind.adjust_skillrank(/datum/skill/misc/medicine, 1, TRUE)
			H.mind.adjust_skillrank(/datum/skill/misc/sewing, 1, TRUE)
			H.mind.adjust_skillrank(/datum/skill/misc/swimming, -1, TRUE)
	ADD_TRAIT(H, TRAIT_LEGENDARY_ALCHEMIST, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_FORAGER, TRAIT_GENERIC)
	if(H.gender == MALE)
		if(H.dna?.species)
			if(H.dna.species.id == "human")
				H.dna.species.soundpack_m = new /datum/voicepack/male/zeth()
	H.change_stat(STATKEY_STR, -1)
	H.change_stat(STATKEY_PER, 1)
	if(H.age == AGE_OLD)
		H.change_stat(STATKEY_SPD, -1)
		H.change_stat(STATKEY_INT, 1)
		H.change_stat(STATKEY_PER, 1)

/datum/outfit/job/thief/poisoner/color_clothing(mob/living/carbon/human/H, thiefColor)
	if(H)
		var/obj/item/clothing/thiefShirt = H.get_item_by_slot(SLOT_SHIRT)
		thiefShirt?.color = thiefColor
		thiefShirt?.update_icon()

		var/obj/item/clothing/thiefJacket = H.get_item_by_slot(SLOT_ARMOR)
		thiefJacket?.detail_color = thiefColor
		thiefJacket?.update_icon()
		H.equip_to_slot(thiefJacket, SLOT_ARMOR, TRUE)
	..()
