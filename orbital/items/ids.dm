/obj/item/weapon/card/id/orbital
	name = "orbital ID card"
	desc = "ID card issued to PLACEHOLDER personnel."

/obj/item/weapon/card/id/orbital/read()
	set name = "Read ID Card"
	set category = "Object"
	set src in usr

	to_chat(usr, "Такие карты не используются на других станциях. Только на нашей они до сих пор в ходу.")

/obj/item/weapon/card/id/orbital/attack_self(mob/user)
	visible_message("[user] глупо машет своей карточкой.")

/obj/item/weapon/card/id/orbital/captain
	name = "captain's ID card"
	desc = "An ID card, issued to PLACEHOLDER's captain."
	icon_state = "gold"
	item_state = "gold_id"
	access = list(access_captain, access_heads, access_brig, access_engine, access_tox, access_medical, access_cargo)

/obj/item/weapon/card/id/orbital/security
	name = "security ID card"
	desc = "An ID card, issued to Marshall and Pilot."
	icon_state = "sec"
	item_state = "sec_id"
	access = list(access_heads, access_brig)

/obj/item/weapon/card/id/orbital/science
	name = "science ID card"
	desc = "An ID card, issued to RD and Specialist."
	icon_state = "sci"
	item_state = "sci_id"
	access = list(access_tox)

/obj/item/weapon/card/id/orbital/engineering
	name = "engineering ID card"
	desc = "An ID card, issued to CE and Engineer."
	icon_state = "eng"
	item_state = "eng_id"
	access = list(access_engine)

/obj/item/weapon/card/id/orbital/medical
	name = "medical ID card"
	desc = "An ID card, issued to CMO and Psy-therapist."
	icon_state = "med"
	item_state = "med_id"
	access = list(access_medical)

/obj/item/weapon/card/id/orbital/logistics
	name = "logistics ID card"
	desc = "An ID card, issued to LO and, maybe, Assistant?."
	icon_state = "cargp"
	item_state = "cargo_id"
	access = list(access_cargo)
