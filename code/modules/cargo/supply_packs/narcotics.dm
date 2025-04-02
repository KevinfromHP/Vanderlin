/datum/supply_pack/narcotics
	group = "Narcotics"
	crate_name = "merchant guild's crate"
	crate_type = /obj/structure/closet/crate/chest/merchant
	contraband = TRUE

/datum/supply_pack/narcotics/sigs
	name = "Pipe Weed Zig"
	cost = 5
	purchase_flags = PURCHASE_MERCHANT | PURCHASE_ALCHEMIST | PURCHASE_SMUGGLER
	contains = /obj/item/clothing/face/cigarette/rollie/nicotine

/datum/supply_pack/narcotics/zigbox
	name = "Zigbox"
	cost = 30
	purchase_flags = PURCHASE_MERCHANT | PURCHASE_ALCHEMIST | PURCHASE_SMUGGLER
	contains = /obj/item/storage/fancy/cigarettes/zig

/datum/supply_pack/narcotics/zigboxempt
	name = "Empty Zigbox"
	cost = 1
	purchase_flags = PURCHASE_MERCHANT | PURCHASE_ALCHEMIST | PURCHASE_SMUGGLER
	contains = /obj/item/storage/fancy/cigarettes/zig/empty

/datum/supply_pack/narcotics/spice
	name = "Spice"
	cost = 30
	purchase_flags = PURCHASE_SMUGGLER
	contains = /obj/item/reagent_containers/powder/spice

/datum/supply_pack/narcotics/ozium
	name = "Ozium"
	cost = 15
	purchase_flags = PURCHASE_SMUGGLER
	contains = /obj/item/reagent_containers/powder/ozium

/datum/supply_pack/narcotics/moondust
	name = "Moon Dust"
	cost = 30
	purchase_flags = PURCHASE_SMUGGLER
	contains = /obj/item/reagent_containers/powder/moondust

/datum/supply_pack/narcotics/soap
	name = "Herbal Soap"
	cost = 20
	purchase_flags = PURCHASE_ALCHEMIST
	contains = /obj/item/bath/soap

/datum/supply_pack/narcotics/perfume
	name = "Perfume"
	cost = 25
	purchase_flags = PURCHASE_MERCHANT | PURCHASE_ALCHEMIST
	contains = list(/obj/item/perfume/random)

/datum/supply_pack/narcotics/poison
	name = "Poison"
	cost = 30
	purchase_flags = PURCHASE_SMUGGLER
	contains = /obj/item/reagent_containers/glass/bottle/poison

/datum/supply_pack/narcotics/spoison
	name = "Stamina Poison"
	cost = 20
	purchase_flags = PURCHASE_SMUGGLER
	contains = /obj/item/reagent_containers/glass/bottle/stampoison
