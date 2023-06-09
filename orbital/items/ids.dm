/obj/item/weapon/card/id/orbital
	name = "Mercury ID card"
	desc = "It's an ID card issued to Mercury Personnel."

//procs below are redefined cuz we don't need'em!
/obj/item/weapon/card/id/orbital/read()
	set name = "Read ID Card"
	set category = "Object"
	set src in usr

	to_chat(usr, "<span class='notice'>Такие карточки уже не используются на всех станциях, кроме нашей. И нас всё устраивает.</span>")

/obj/item/weapon/card/id/orbital/attack_self(mob/user)
	return

/obj/item/weapon/card/id/orbital/captain
	name = "captain's ID card"
	desc = "An ID issued to Mercury's Captain."
	icon_state = "gold"
	item_state = "gold_id"
	access = list(access_captain, access_heads, access_cargo, access_engine, access_medical, access_research)

/obj/item/weapon/card/id/orbital/logistics
	name = "logistics ID card"
	desc = "These are for LO and pilot."
	icon_state = "cargo"
	item_state = "cargo_id"
	access = list(access_cargo)

/obj/item/weapon/card/id/orbital/engineering
	name = "engineering ID card"
	desc = "These are for CE and engineer."
	icon_state = "eng"
	item_state = "eng_id"
	access = list(access_engine)

/obj/item/weapon/card/id/orbital/medical
	name = "medical ID card"
	desc = "These are for CMO and psy-therapist."
	icon_state = "med"
	item_state = "med_id"
	access = list(access_medical)

/obj/item/weapon/card/id/orbital/science
	name = "science ID card"
	desc = "These are for RD and cyberspec."
	icon_state = "sci"
	item_state = "sci_id"
	access = list(access_research)

/obj/item/weapon/card/id/orbital/security
	name = "security ID card"
	desc = "This one is for marshal."
	icon_state = "sec"
	item_state = "sec_id"
	access = list(access_security, access_heads)
