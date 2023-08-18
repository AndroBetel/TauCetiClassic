/datum/event/feature
	var/desc = "...на станции ничего не произошло."
	var/chance_to_reveal = 50
	var/trait_to_add = null

/datum/event/feature/start()
	if(prob(chance_to_reveal))
		to_chat(world, "<span class='notice'><b>Перед сменой...</b></span>")
		to_chat(world, "<span class='notice'>[desc]</span>")
	if(trait_to_add)
		ADD_TRAIT(SSroundfeature, trait_to_add, STATION_TRAIT)

/datum/event/feature/del_tcomms
	desc = "...воксы украли телекомы!"

/datum/event/feature/del_tcomms/start()
	. = ..()
	for(var/atom/A as anything in global.telecomms_list)
		if(is_station_level(A.z))
			qdel(A)

	message_admins("RoundStart Event: Telecomms have been deleted.")
	log_game("RoundStart Event: All Telecomms have been deleted.")

/datum/event/feature/inflation
	desc = "...цены выросли из-за падения курса форона!"

/datum/event/feature/inflation/start()
	. = ..()
	message_admins("RoundStart Event: The range of vending machines has changed amount and price.")
	for(var/obj/machinery/vending/V in machines)
		for(var/datum/data/vending_product/VP in V.product_records)
			VP.amount = rand(0, VP.amount)
			VP.price *= 5
			log_game("RoundStart Event: [VP.product_name] has changed amount and price in [V] [COORD(V)].")
	for(var/supply_name in SSshuttle.supply_packs)
		var/datum/supply_pack/N = SSshuttle.supply_packs[supply_name]
		N.cost *= 5
		log_game("RoundStart Event: Supply packs are now expensive.")


/datum/event/feature/deflation
	desc = "...цены снизились из-за роста курса форона!"

/datum/event/feature/deflation/start()
	. = ..()
	message_admins("RoundStart Event: The range of vending machines has changed amount and price.")
	for(var/obj/machinery/vending/V in machines)
		for(var/datum/data/vending_product/VP in V.product_records)
			VP.price *= 0.5
			log_game("RoundStart Event: [VP.product_name] has changed amount and price in [V] [COORD(V)].")
	for(var/supply_name in SSshuttle.supply_packs)
		var/datum/supply_pack/N = SSshuttle.supply_packs[supply_name]
		N.cost *= 0.5
		log_game("RoundStart Event: Supply packs are now cheap.")

/datum/event/feature/lights_out
	desc = "...настенные лампы не работают из-за сбоя в проводке!"
	trait_to_add = STATION_TRAIT_LIGHTS_OUT
/datum/event/feature/lights_out/start()
	. = ..()
	message_admins("RoundStart Event: LIGHTS OUT!")
	for(var/obj/machinery/power/apc/A in apc_list)
		A.overload_lighting()
	for(var/mob/living/carbon/human/H in human_list)
		if(prob(50))
			H.equip_to_slot_or_del(new /obj/item/device/flashlight(H), SLOT_L_HAND)
		else if(prob(30))
			H.equip_to_slot_or_del(new /obj/item/clothing/glasses/night(H), SLOT_L_HAND)
/*
/datum/event/feature/jammed_firearms
	desc = "...агенты Синдиката сломали всё оружие!"

/datum/event/feature/jammed_firearms/start()
	message_admins("RoundStart Event:All weapons were broken.")
	for(var/obj/machinery/power/apc/A in apc_list)
		A.overload_lighting()
	for(var/mob/living/carbon/human/H in human_list)
		if(prob(50))
			H.equip_to_slot_or_del(new /obj/item/device/flashlight(H), SLOT_L_HAND)
		else if(prob(30))
			H.equip_to_slot_or_del(new /obj/item/clothing/glasses/night(H), SLOT_L_HAND)
*/

/datum/event/feature/random_identities
	desc = "...бухгалтерия направила на станцию экипаж другого объекта!"
	chance_to_reveal = 100

/datum/event/feature/random_identities/start()
	. = ..()
	for(var/mob/living/carbon/human/H in human_list)
		H.fully_replace_character_name(H.real_name, random_name(H.gender))
