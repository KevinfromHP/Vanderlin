/datum/round_event_control/trade_request
	name = "Trade Request"
	track = EVENT_TRACK_MUNDANE
	typepath = /datum/round_event/trade_request
	weight = 4
	max_occurrences = 12
	min_players = 0
	earliest_start = 5 MINUTES

	tags = list(
		TAG_TRADE,
		TAG_BOON,
		TAG_WATER,
	)

/datum/round_event/trade_request/start()
	. = ..()
	if(!SSmerchant.trade_packs.len)
		log_game("Attempted to generate a trade request, but there's no trade packs. This is a problem.")
		return FALSE
	var/trade_pack = pick(SSmerchant.trade_packs)
	var/datum/trade_pack/pack = SSmerchant.trade_packs[trade_pack]
	if(pack.trade_limit > 0)
		pack.trade_limit--
	if(pack.trade_limit == 0)
		SSmerchant.trade_packs.Remove(trade_pack)
	SSmerchant.sending_stuff |= new /obj/item/paper/scroll/mercantile/trade_request(null, pack.faction, pack.contains, pack.reward, pack)
