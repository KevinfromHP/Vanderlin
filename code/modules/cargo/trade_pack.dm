///Used to decide the contents of a trade request.
/datum/trade_pack
	var/name = "Trade Request"
	var/faction = TRADE_FACTION_ALL
	var/blacklisted = FALSE
	/// how many mammons is this worth? Null bases off the value of the contents.
	var/reward = null
	var/list/contains = null
	var/static_reward = FALSE
	var/random_reward_factor = 0.3
	/// how many triumphs is this worth to the merchant?
	var/triumphs = 1
	///how many times can you trade for this before it stops showing up. -1 is infinite.
	var/trade_limit = -1

/datum/trade_pack/New()
	..()
	if(!reward)
		for(var/A in contains)
			var/atom/movable/temp = new A()
			var/amt = contains[A]
			reward += temp.sellprice * 1.5 * (isnum(amt) ? amt : 1)
			qdel(temp)
	if(!reward)
		reward = 30
	if(!static_reward)
		var/na = max(round(reward * random_reward_factor, 1), 1)
		reward = max(rand(reward-na, reward+na), 1)


/datum/trade_pack/cheese
	name = "Fine Cheese"
	contains = list(/obj/item/reagent_containers/food/snacks/cheddar/aged = 2)

/*
/datum/trade_pack/fruit
	name = "Fruits"
	reward = 90
	contains = list(
			/obj/item/reagent_containers/food/snacks/produce/apple = 6,
			/obj/item/reagent_containers/food/snacks/produce/pear = 6,
			/obj/item/reagent_containers/food/snacks/produce/lemon = 6,
			/obj/item/reagent_containers/food/snacks/produce/lime = 6
	)

/datum/trade_pack/vegetables
	name = "Vegetables"
	reward = 90
	contains = list(
			/obj/item/reagent_containers/food/snacks/produce/cabbage = 6,
			/obj/item/reagent_containers/food/snacks/produce/potato = 6,
			/obj/item/reagent_containers/food/snacks/produce/onion = 6,
			/obj/item/reagent_containers/food/snacks/produce/turnip = 6
	)
*/

/datum/trade_pack/mining
	name = "Mining Supplies"
	contains = list(
		/obj/item/weapon/pick/steel = 3,
		/obj/item/clothing/head/helmet/leather/minershelm = 3,
		/obj/item/rope = 3
	)
	trade_limit = 2


/datum/trade_pack/blacksteel
	name = "Set of Blacksteel Armor"
	reward = 300
	contains = list(
		/obj/item/clothing/head/helmet/blacksteel/bucket = 1,
		/obj/item/clothing/armor/plate/blkknight = 1,
		/obj/item/clothing/gloves/plate/blk = 1,
		/obj/item/clothing/pants/platelegs/blk = 1,
		/obj/item/clothing/shoes/boots/armor/blkknight = 1
	)
	trade_limit = 1
	triumphs = 2


/datum/trade_pack/royal_gown
	name = "Royal Gown"
	reward = 175
	contains = list(/obj/item/clothing/shirt/dress/gown = 1)
	trade_limit = 1

/datum/trade_pack/royal_gown/summer
	contains = list(/obj/item/clothing/shirt/dress/gown/summergown = 1)
	trade_limit = 1

/datum/trade_pack/royal_gown/fall
	contains = list(/obj/item/clothing/shirt/dress/gown/fallgown = 1)
	trade_limit = 1

/datum/trade_pack/royal_gown/winter
	contains = list(/obj/item/clothing/shirt/dress/gown/wintergown = 1)
	trade_limit = 1

/datum/trade_pack/wedding
	name = "Wedding Supplies"
	contains = list(
		/obj/item/clothing/head/peaceflower = 2,
		/obj/item/clothing/ring/silver = 2
	)
	trade_limit = 1

/datum/trade_pack/statue
	name = "Statue"
	contains = list(
		/obj/item/statue/gold = 1
	)
	triumphs = 0

/datum/trade_pack/kobold
	name = "Kobold"
	contains = list(/mob/living/carbon/human/species/kobold = 1)
	reward = 200
	triumphs = 3
	trade_limit = 1
