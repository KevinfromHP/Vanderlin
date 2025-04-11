/datum/supply_pack/weapons
	group = "Weapons"
	crate_name = "merchant guild's crate"
	crate_type = /obj/structure/closet/crate/chest/merchant
	small_item = TRUE

/datum/supply_pack/weapons/shortsword
	name = "Iron Short Sword"
	cost = 25
	purchase_flags = PURCHASE_MERCHANT | PURCHASE_SMUGGLER
	contains = /obj/item/weapon/sword/short

/datum/supply_pack/weapons/sword_iron
	name = "Iron Arming Sword"
	cost = 27
	purchase_flags = PURCHASE_MERCHANT | PURCHASE_SMUGGLER
	contains = /obj/item/weapon/sword/iron

/datum/supply_pack/weapons/sword
	name = "Steel Arming Sword"
	cost = 30
	contains = /obj/item/weapon/sword

/datum/supply_pack/weapons/greatsword
	name = "Iron Zweihander"
	cost = 55
	contains = /obj/item/weapon/sword/long/greatsword/zwei

/datum/supply_pack/weapons/mace
	name = "Iron Mace"
	cost = 28
	purchase_flags = PURCHASE_MERCHANT | PURCHASE_SMUGGLER
	contains = /obj/item/weapon/mace

/datum/supply_pack/weapons/smace
	name = "Steel Mace"
	cost = 28
	contains = /obj/item/weapon/mace/steel

/datum/supply_pack/weapons/greatmace
	name = "Iron Warclub"
	cost = 26
	purchase_flags = PURCHASE_MERCHANT | PURCHASE_SMUGGLER
	contains = /obj/item/weapon/mace/goden

/datum/supply_pack/weapons/axe
	name = "Iron Axe"
	cost = 26
	purchase_flags = PURCHASE_MERCHANT | PURCHASE_SMUGGLER
	contains = /obj/item/weapon/axe

/datum/supply_pack/weapons/saxe
	name = "Steel Axe"
	cost = 29
	contains = /obj/item/weapon/axe/steel

/datum/supply_pack/weapons/halberd
	name = "Halberd"
	cost = 51
	contains = /obj/item/weapon/polearm/halberd

/datum/supply_pack/weapons/huntingknife
	name = "Iron Hunting Knife"
	cost = 17
	purchase_flags = PURCHASE_MERCHANT | PURCHASE_SMUGGLER
	contains = /obj/item/weapon/knife/hunting

/datum/supply_pack/weapons/dagger
	name = "Iron Dagger"
	cost = 22
	purchase_flags = PURCHASE_MERCHANT | PURCHASE_SMUGGLER
	contains = /obj/item/weapon/knife/dagger

/datum/supply_pack/weapons/sdagger
	name = "Steel Dagger"
	cost = 26
	purchase_flags = PURCHASE_MERCHANT | PURCHASE_SMUGGLER
	contains = /obj/item/weapon/knife/dagger/steel

/datum/supply_pack/weapons/hackknife
	name = "Hack-Knife"
	cost = 35
	purchase_flags = PURCHASE_SMUGGLER
	contains = /obj/item/weapon/knife/cleaver/combat

/datum/supply_pack/weapons/tossblade_belt
	name = "Tossblade Belt"
	cost = 20
	purchase_flags = PURCHASE_SMUGGLER
	contains = /obj/item/storage/belt/leather/knifebelt

/datum/supply_pack/weapons/tossblade_iron
	name = "Iron Tossblade"
	cost = 8
	purchase_flags = PURCHASE_SMUGGLER
	contains = /obj/item/weapon/knife/throwingknife

/datum/supply_pack/weapons/tossblade_steel
	name = "Steel Tossblade"
	cost = 13
	purchase_flags = PURCHASE_SMUGGLER
	contains = /obj/item/weapon/knife/throwingknife/steel

/datum/supply_pack/weapons/spear
	name = "Iron Spear"
	cost = 22
	contains = /obj/item/weapon/polearm/spear

/datum/supply_pack/weapons/flail
	name = "Military Flail"
	cost = 29
	purchase_flags = PURCHASE_MERCHANT | PURCHASE_SMUGGLER
	contains = /obj/item/weapon/flail

/datum/supply_pack/weapons/sflail
	name = "Steel Flail"
	cost = 32
	contains = /obj/item/weapon/flail/sflail

/datum/supply_pack/weapons/whip
	name = "Leather Whip"
	cost = 16
	purchase_flags = PURCHASE_MERCHANT | PURCHASE_SMUGGLER
	contains = /obj/item/weapon/whip

/datum/supply_pack/weapons/shield
	name = "Wooden Shield"
	cost = 10
	purchase_flags = PURCHASE_MERCHANT | PURCHASE_SMUGGLER
	contains = /obj/item/weapon/shield/wood

/datum/supply_pack/weapons/shield/buckler
	name = "Iron Buckler"
	cost = 25
	purchase_flags = PURCHASE_MERCHANT | PURCHASE_SMUGGLER
	contains = /obj/item/weapon/shield/tower/buckleriron

/datum/supply_pack/weapons/towershield
	name = "Tower Shield"
	cost = 35
	contains = /obj/item/weapon/shield/tower

/datum/supply_pack/weapons/bomb
	name = "Bottle Bomb"
	cost = 40
	purchase_flags = PURCHASE_SMUGGLER
	contains = /obj/item/bomb/homemade

/datum/supply_pack/weapons/crossbow
	name = "Crossbow"
	cost = 45
	purchase_flags = PURCHASE_MERCHANT | PURCHASE_SMUGGLER
	contains = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow

/datum/supply_pack/weapons/bow
	name = "Hunting Bow"
	cost = 30
	purchase_flags = PURCHASE_MERCHANT | PURCHASE_SMUGGLER
	contains = /obj/item/gun/ballistic/revolver/grenadelauncher/bow

/datum/supply_pack/weapons/bow2
	name = "Longbow"
	cost = 35
	purchase_flags = PURCHASE_MERCHANT | PURCHASE_SMUGGLER
	contains = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/long

/datum/supply_pack/weapons/rbow
	name = "Imported Recurve Bow"
	cost = 30
	purchase_flags = PURCHASE_MERCHANT | PURCHASE_SMUGGLER
	contains = list(/obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve)

/datum/supply_pack/weapons/quivers
	name = "Empty Quiver"
	cost = 5
	purchase_flags = PURCHASE_MERCHANT | PURCHASE_SMUGGLER
	contains = /obj/item/ammo_holder/quiver

/datum/supply_pack/weapons/arrowquiver
	name = "Quiver of Arrows"
	cost = 25
	purchase_flags = PURCHASE_MERCHANT | PURCHASE_SMUGGLER
	contains = /obj/item/ammo_holder/quiver/arrows

/datum/supply_pack/weapons/boltquiver
	name = "Quiver of Bolts"
	cost = 35
	purchase_flags = PURCHASE_MERCHANT | PURCHASE_SMUGGLER
	contains = /obj/item/ammo_holder/quiver/bolts

/datum/supply_pack/weapons/arrows
	name = "Arrow"
	cost = 3
	purchase_flags = PURCHASE_MERCHANT | PURCHASE_SMUGGLER
	contains = /obj/item/ammo_casing/caseless/arrow

/datum/supply_pack/weapons/bolts
	name = "Crossbow Bolt"
	cost = 4
	purchase_flags = PURCHASE_MERCHANT | PURCHASE_SMUGGLER
	contains = /obj/item/ammo_casing/caseless/bolt

/datum/supply_pack/weapons/mantrap
	name = "Mantrap"
	cost = 40
	purchase_flags = PURCHASE_MERCHANT | PURCHASE_SMUGGLER
	contains = /obj/item/restraints/legcuffs/beartrap/crafted
