// Used for co-ordinating factions in a round, what factions should be in operation, etc
/datum/game_mode
	var/name = "invalid"
	var/config_tag = null
	var/votable = 1
	var/playable_mode = 1
	var/probability = 0
	var/modeset = null        // if game_mode in modeset
	var/station_was_nuked = 0 //see nuclearbomb.dm and malfunction.dm
	var/explosion_in_progress = 0 //sit back and relax
	var/nar_sie_has_risen = 0 //check, if there is already one god in the world who was summoned (only for tomes)
	var/completion_text = ""
	var/mode_result = "undefined"
	var/list/datum/mind/modePlayer = new // list of current antags.
	var/list/restricted_jobs = list()	// Jobs it doesn't make sense to be.  I.E chaplain or AI cultist
	var/list/protected_jobs = list("Velocity Officer", "Velocity Chief", "Velocity Medical Doctor")	// Jobs that can't be traitors because

	// Specie flags that for any amount of reasons can cause this role to not be available.
	// TO-DO: use traits? ~Luduk
	var/list/restricted_species_flags = list()

	var/required_players = 0 // Minimum number of players, if game mode is forced
	var/required_players_bundles = 0 //Minimum number of players for that game mode to be chose in Secret|BS12|TauClassic
	var/required_enemies = 0
	var/recommended_enemies = 0
	var/list/datum/mind/antag_candidates = list()	// List of possible starting antags goes here
	var/list/restricted_jobs_autotraitor = list("Cyborg", "Security Officer", "Warden", "Velocity Officer", "Velocity Chief", "Velocity Medical Doctor")
	var/autotraitor_delay = 15 MINUTES // how often to try to add new traitors.
	var/role_type = null
	var/newscaster_announcements = null
	var/ert_disabled = 0
	var/const/waittime_l = 600
	var/const/waittime_h = 1800 // started at 1800
	var/check_ready = TRUE

	var/antag_hud_type
	var/antag_hud_name

	var/uplink_welcome = "Syndicate Uplink Console:"
	var/uplink_uses = 20
	var/uplink_items = {"Highly Visible and Dangerous Weapons;
/obj/item/weapon/gun/projectile/revolver/syndie:6:Revolver;
/obj/item/ammo_box/a357:2:Ammo-357;
/obj/item/weapon/gun/energy/crossbow:5:Energy Crossbow;
/obj/item/weapon/melee/energy/sword:4:Energy Sword;
/obj/item/weapon/storage/box/syndicate:10:Syndicate Bundle;
/obj/item/weapon/storage/box/emps:3:5 EMP Grenades;
Whitespace:Seperator;
Stealthy and Inconspicuous Weapons;
/obj/item/weapon/pen/paralysis:3:Paralysis Pen;
/obj/item/weapon/soap/syndie:1:Syndicate Soap;
/obj/item/weapon/cartridge/syndicate:3:Detomatix PDA Cartridge;
Whitespace:Seperator;
Stealth and Camouflage Items;
/obj/item/weapon/storage/box/syndie_kit/chameleon:3:Chameleon Kit;
/obj/item/clothing/shoes/syndigaloshes:2:No-Slip Syndicate Shoes;
/obj/item/weapon/card/id/syndicate:2:Agent ID card;
/obj/item/clothing/mask/gas/voice:4:Voice Changer;
/obj/item/device/chameleon:4:Chameleon-Projector;
Whitespace:Seperator;
Devices and Tools;
/obj/item/weapon/card/emag:3:Cryptographic Sequencer;
/obj/item/weapon/storage/toolbox/syndicate:1:Fully Loaded Toolbox;
/obj/item/weapon/storage/box/syndie_kit/space:3:Space Suit;
/obj/item/clothing/glasses/thermal/syndi:3:Thermal Imaging Glasses;
/obj/item/device/encryptionkey/binary:3:Binary Translator Key;
/obj/item/weapon/aiModule/freeform/syndicate:7:Hacked AI Upload Module;
/obj/item/weapon/plastique:2:C-4 (Destroys walls);
/obj/item/device/powersink:5:Powersink (DANGER!);
/obj/item/device/radio/beacon/syndicate:7:Singularity Beacon (DANGER!);
/obj/item/weapon/circuitboard/teleporter:20:Teleporter Circuit Board;
Whitespace:Seperator;
Implants;
/obj/item/weapon/storage/box/syndie_kit/imp_freedom:3:Freedom Implant;
/obj/item/weapon/storage/box/syndie_kit/imp_uplink:10:Uplink Implant (Contains 5 Telecrystals);
/obj/item/weapon/storage/box/syndie_kit/imp_explosive:6:Explosive Implant (DANGER!);
/obj/item/weapon/storage/box/syndie_kit/imp_compress:4:Compressed Matter Implant;Whitespace:Seperator;
(Pointless) Badassery;
/obj/item/toy/syndicateballoon:10:For showing that You Are The BOSS (Useless Balloon);"}

//Distress call variables.
	var/list/datum/emergency_call/all_calls = list() //initialized at round start and stores the datums.
	var/datum/emergency_call/picked_call = null //Which distress call is currently active
	var/on_distress_cooldown = FALSE
	var/waiting_for_candidates = FALSE
	var/distress_cancelled = FALSE

/datum/game_mode/proc/announce() //to be calles when round starts
	to_chat(world, "<B>Notice</B>: [src] did not define announce()")


// can_start()
// Checks to see if the game can be setup and ran with the current number of players or whatnot.
/datum/game_mode/proc/can_start()
	var/playerC = 0
	for(var/mob/dead/new_player/player in new_player_list)
		if(player.client && (!check_ready || player.ready))
			playerC++
	// no antag_candidates need
	if (playerC == 0 && required_players == 0)
		return TRUE
	// check for minimal player on server
	if((modeset && modeset == ("secret" || "tau classic" || "bs12") && playerC < required_players_bundles) || playerC < required_players)
		return FALSE
	// get list of all antags possiable
	antag_candidates = get_players_for_role(role_type)
	if(antag_candidates.len < required_enemies)
		return FALSE
	// assign_outsider_antag_roles use antag_candidates list
	// fill antag_candidates before return
	return TRUE

	// The name of the gamemode, e.g. Changelings
	var/name
	// Use only for config, without SSticker.mode.config_name == "malf", please
	var/config_name
	// What factions will the gamemode start with, or attempt to start with
	var/list/factions_allowed = list()
	// Minimum required players to start the gamemode
	var/minimum_player_count
	// Minimum number of players for that gamemode to be chose in Secret|Team Based|Mix
	var/minimum_players_bundles
	var/probability = 100 // this is the weight

	var/newscaster_announcements = null
	// How likely it is to roll this gamemode
	var/probability = 100

	// This is the html of all information about the current mode
	var/completition_text = ""

	// What factions are currently in operation in the gamemode
	var/list/factions = list()
	// List of faction-less roles currently in the gamemode
	var/list/orphaned_roles = list()

/datum/game_mode/proc/announce()
	return

/datum/game_mode/proc/get_player_count(check_ready = TRUE)
	var/players = 0
	for(var/mob/dead/new_player/P as anything in new_player_list)
		if(P.client && (!check_ready || P.ready))
			players++

	return players

/datum/game_mode/proc/get_ready_players(check_ready = TRUE)
	var/list/players = list()
	for(var/mob/dead/new_player/P as anything in new_player_list)
		if(P.client && (!check_ready || P.ready))
			players.Add(P)

	return shuffle(players)

/datum/game_mode/proc/can_start(check_ready = TRUE)
	if(minimum_player_count == 0 && get_player_count(check_ready)) // For debug, minimum_player_count = 0 is very bad
		log_mode("[name] start because `minimum_player_count = 0`")
		return TRUE
	if(get_player_count(check_ready) < minimum_player_count)
		log_mode("[name] not start because number of players who Ready is less than minimum number of players.")
		return FALSE
	if(config.is_bundle_by_name(master_mode) && get_player_count(check_ready) < minimum_players_bundles)
		log_mode("[name] not start because number of players who Ready is less than minimum number of players in bundle.")
		return FALSE
	if(!CanPopulateFaction(check_ready))
		log_mode("[name] not start because pre-filling of the faction failed.")
		return FALSE
	return TRUE

/datum/game_mode/proc/potential_runnable()
	if(!can_start(FALSE))
		return FALSE
	return TRUE

//For when you need to set factions and factions_allowed not on compile
/datum/game_mode/proc/SetupFactions()
	return

// Infos on the mode.
/datum/game_mode/proc/AdminPanelEntry()
	return

/datum/game_mode/proc/Setup()
	if(!can_start(TRUE))
		return FALSE
	SetupFactions()
	var/FactionSuccess = CreateFactions()
	if(!FactionSuccess)
		DropAll()
	return FactionSuccess

// it is necessary in those rare cases when the gamemode did not start for those reasons
// that cannot be detected BEFORE the creation of a human
/datum/game_mode/proc/DropAll()
	for(var/f in factions)
		var/datum/faction/faction = f
		faction.Dismantle()
	for(var/r in orphaned_roles)
		var/datum/role/role = r
		role.Drop()

/*===FACTION RELATED STUFF===*/

/datum/game_mode/proc/CreateFactions()
	var/player_count = get_player_count(FALSE)
	for(var/faction_type in factions_allowed)
		if(isnum(factions_allowed[faction_type]))
			for(var/i in 1 to factions_allowed[faction_type])
				CreateFaction(faction_type, player_count)
		else
			CreateFaction(faction_type, player_count)
	return PopulateFactions()

/datum/game_mode/proc/CreateFaction(faction_type, player_count, override = FALSE)
	var/datum/faction/F = new faction_type
	if(F.can_setup(player_count) || override)
		factions += F
		log_mode("[F] was normally created.")
		return F

	log_mode("Faction ([F]) could not set up properly with given population.")
	qdel(F)
	return null

/datum/game_mode/proc/CanPopulateFaction(check_ready = TRUE)
	var/list/L = get_ready_players(check_ready)
	for(var/type in factions_allowed)
		var/datum/faction/F = new type()
		var/can_be = L.len
		for(var/mob/M in L)
			if(!F.can_join_faction(M))
				can_be--
		if(can_be < F.min_roles)
			log_mode("[F] cannot be filled completely. Possible members is [can_be], minimum [F.min_roles]")
			return FALSE
		qdel(F)
	return TRUE

/datum/game_mode/proc/PopulateFactions()
	if(!factions.len)
		message_admins("No faction was created in [type].")
		log_mode("No faction was created in [type].")
		return FALSE
	var/list/available_players = get_ready_players()
	for(var/datum/faction/F in factions)
		for(var/mob/dead/new_player/P in available_players)
			if(F.max_roles && F.members.len >= F.max_roles)
				break
			if(!F.can_join_faction(P))
				log_mode("[P] failed [F] can_join_faction!")
				continue
			if(!F.HandleNewMind(P.mind, FALSE))
				log_mode("[P] failed [F] HandleNewMind!")
				continue
			available_players -= P // One player cannot be a borero-ninja-malf
		if(F.members.len < F.min_roles)
			log_mode("Not enought players for [F]!")
			return FALSE
	return TRUE

/*=====ROLE RELATED STUFF=====*/
/datum/game_mode/proc/CreateRole(role_type, mob/P)
	var/datum/role/newRole = new role_type

	if(!newRole)
		log_mode("Role killed itself or was otherwise missing!")
		return null

	if(!newRole.AssignToRole(P.mind))
		log_mode("Role refused mind and dropped!")
		newRole.Drop()
		return null

	return newRole

/datum/game_mode/proc/latespawn(mob/mob) //Check factions, see if anyone wants a latejoiner
	var/list/possible_factions = list()
	for(var/datum/faction/F in factions)
		F.latespawn(mob)
		if(!F.accept_latejoiners)
			continue
		if(F.max_roles && F.members.len >= F.max_roles)
			continue
		if(!F.can_join_faction(mob))
			continue
		possible_factions += F
	if(possible_factions.len)
		var/datum/faction/F = pick(possible_factions)
		add_faction_member(F, mob, TRUE)

/datum/game_mode/proc/PostSetup()
	addtimer(CALLBACK(GLOBAL_PROC, .proc/display_roundstart_logout_report), ROUNDSTART_LOGOUT_REPORT_TIME)
	addtimer(CALLBACK(src, .proc/send_intercept), rand(INTERCEPT_TIME_LOW , INTERCEPT_TIME_HIGH))

	var/list/exclude_autotraitor_for = list(/datum/game_mode/extended)
	if(!(type in exclude_autotraitor_for))
		CreateFaction(/datum/faction/traitor/auto, num_players())

	SSticker.start_state = new /datum/station_state()
	SSticker.start_state.count(TRUE)

	for(var/datum/faction/F in factions)
		for(var/datum/role/R in F.members)
			R.Greet()
		F.forgeObjectives()
		F.AnnounceObjectives()
		F.OnPostSetup()
	for(var/datum/role/R in orphaned_roles)
		R.Greet()
		R.forgeObjectives()
		R.AnnounceObjectives()
		R.OnPostSetup()

	if(establish_db_connection("erro_round"))
		var/DBQuery/query_round_game_mode = dbcon.NewQuery("UPDATE erro_round SET game_mode = '[sanitize_sql(SSticker.mode)]' WHERE id = [global.round_id]")
		query_round_game_mode.Execute()

	feedback_set_details("round_start","[time2text(world.realtime)]")
	feedback_set_details("game_mode","[SSticker.mode]")
	feedback_set_details("server_ip","[sanitize_sql(world.internet_address)]:[sanitize_sql(world.port)]")

/datum/game_mode/proc/GetScoreboard()
	completition_text = "<h2>Factions & Roles</h2>"
	var/exist = FALSE
	for(var/datum/faction/F in factions)
		F.calculate_completion()
		SSStatistics.add_faction(F)
		if (F.members.len > 0)
			exist = TRUE
			completition_text += "<div class='Section'>"
			completition_text += F.GetFactionHeader()
			completition_text += F.GetScoreboard()
			completition_text += "</div>"
	if (orphaned_roles.len > 0)
		completition_text += "<FONT size = 2><B>Independents:</B></FONT><br>"
	for(var/datum/role/R in orphaned_roles)
		R.calculate_completion()
		SSStatistics.add_orphaned_role(R)
		exist = TRUE
		completition_text += "<div class='Section'>"
		completition_text += R.GetScoreboard()
		completition_text += "</div>"
	if (!exist)
		completition_text += "(none)"
	completition_text += "<BR>"
	count_survivors()

	return completition_text

/datum/game_mode/process()
	for(var/datum/faction/F in factions)
		F.process()
	for(var/datum/role/R in orphaned_roles)
		R.process()

/datum/game_mode/proc/check_finished()
	for(var/datum/faction/F in factions)
		if (F.check_win())
			return TRUE
	for(var/datum/role/R in orphaned_roles)
		if (R.check_win())
			return TRUE
	if(SSticker.station_was_nuked || SSshuttle.location == SHUTTLE_AT_CENTCOM)
		return TRUE
	return FALSE

<<<<<<< HEAD
/datum/game_mode/proc/num_players()
	. = 0
	for(var/mob/dead/new_player/P in new_player_list)
		if(P.client && P.ready)
			. ++


///////////////////////////////////
//Keeps track of all living heads//
///////////////////////////////////
/datum/game_mode/proc/get_living_heads()
	var/list/heads = list()
	for(var/mob/living/carbon/human/player in human_list)
		if(player.stat != DEAD && player.mind && (player.mind.assigned_role in command_positions))
			heads += player.mind
	return heads


////////////////////////////
//Keeps track of all heads//
////////////////////////////
/datum/game_mode/proc/get_all_heads()
	var/list/heads = list()
	for(var/mob/player in mob_list)
		if(player.mind && (player.mind.assigned_role in command_positions))
			heads += player.mind
	return heads

/datum/game_mode/proc/check_antagonists_topic(href, href_list[])
	return 0

/datum/game_mode/New()
	newscaster_announcements = pick(newscaster_standard_feeds)
	initialize_emergency_calls()

//////////////////////////
//Reports player logouts//
//////////////////////////
/proc/display_roundstart_logout_report()
	var/msg = "<span class='notice'><b>Roundstart logout report</b>\n\n</span>"
	for(var/mob/living/L in living_list)

		if(L.ckey)
			var/found = 0
			for(var/client/C in clients)
				if(C.ckey == L.ckey)
					found = 1
					break
			if(!found)
				msg += "<b>[L.name]</b> ([L.ckey]), the [L.job] (<font color='#ffcc00'><b>Disconnected</b></font>)\n"


		if(L.ckey && L.client)
			if(L.client.inactivity >= (ROUNDSTART_LOGOUT_REPORT_TIME / 2))	//Connected, but inactive (alt+tabbed or something)
				msg += "<b>[L.name]</b> ([L.ckey]), the [L.job] (<font color='#ffcc00'><b>Connected, Inactive</b></font>)\n"
				continue //AFK client
			if(L.stat)
				if(L.suiciding)	//Suicider
					msg += "<b>[L.name]</b> ([L.ckey]), the [L.job] (<font color='red'><b>Suicide</b></font>)\n"
					continue //Disconnected client
				if(L.stat == UNCONSCIOUS)
					msg += "<b>[L.name]</b> ([L.ckey]), the [L.job] (Dying)\n"
					continue //Unconscious
				if(L.stat == DEAD)
					msg += "<b>[L.name]</b> ([L.ckey]), the [L.job] (Dead)\n"
					continue //Dead

			continue //Happy connected client
		for(var/mob/dead/observer/D in observer_list)
			if(D.mind && (D.mind.original == L || D.mind.current == L))
				if(L.stat == DEAD)
					if(L.suiciding)	//Suicider
						msg += "<b>[L.name]</b> ([ckey(D.mind.key)]), the [L.job] (<font color='red'><b>Suicide</b></font>)\n"
						continue //Disconnected client
					else
						msg += "<b>[L.name]</b> ([ckey(D.mind.key)]), the [L.job] (Dead)\n"
						continue //Dead mob, ghost abandoned
				else
					if(D.can_reenter_corpse)
						msg += "<b>[L.name]</b> ([ckey(D.mind.key)]), the [L.job] (<font color='red'><b>This shouldn't appear.</b></font>)\n"
						continue //Lolwhat
					else
						msg += "<b>[L.name]</b> ([ckey(D.mind.key)]), the [L.job] (<font color='red'><b>Ghosted</b></font>)\n"
						continue //Ghosted while alive



	for(var/client/M in admins)
		if(M.holder)
			to_chat(M, msg)


/proc/get_nt_opposed()
	var/list/dudes = list()
	for(var/mob/living/carbon/human/man in human_list)
		if(man.client)
			if(man.client.prefs.nanotrasen_relation == "Opposed")
				dudes += man
			else if(man.client.prefs.nanotrasen_relation == "Skeptical" && prob(50))
				dudes += man
	if(dudes.len == 0) return null
	return pick(dudes)

///////////////////////////
//Misc stuff and TG ports//
///////////////////////////

/datum/game_mode/proc/printplayer(datum/mind/ply)
	var/role = "[ply.special_role]"
	var/text = "<br><b>[ply.name]</b>(<b>[ply.key]</b>) as \a <b>[role]</b> ("
	if(ply.current)
		if(ply.current.stat == DEAD)
			text += "died"
		else
			text += "survived"
		if(ply.current.real_name != ply.name)
			text += " as <b>[ply.current.real_name]</b>"
	else
		text += "body destroyed"
	text += ")"

	return text

/datum/game_mode/proc/printobjectives(datum/mind/ply)
	var/text = ""
	var/count = 1
	var/result
	for(var/datum/objective/objective in ply.objectives)
		result = objective.check_completion()
		switch(result)
			if(OBJECTIVE_WIN)
				text += "<br><b>Objective #[count]</b>: [objective.explanation_text] <span style='color: green; font-weight: bold;'>Success!</span>"
			if(OBJECTIVE_LOSS)
				text += "<br><b>Objective #[count]</b>: [objective.explanation_text] <span style='color: red; font-weight: bold;'>Fail.</span>"
			if(OBJECTIVE_HALFWIN)
				text += "<br><b>Objective #[count]</b>: [objective.explanation_text] <span style='color: orange; font-weight: bold;'>Half success.</span>"

		count++
	return text

//Used for printing player with there icons in round ending staticstic
/datum/game_mode/proc/printplayerwithicon(datum/mind/ply)
	var/text = ""
	var/tempstate = end_icons.len
	if(ply.current)
		var/icon/flat = getFlatIcon(ply.current,exact=1)
		end_icons += flat
		tempstate = end_icons.len
		text += {"<br><img src="logo_[tempstate].png"> <b>[ply.key]</b> was <b>[ply.name]</b> ("}
		if(ply.current.stat == DEAD)
			text += "died"
			flat.Turn(90)
			end_icons[tempstate] = flat
		else
			text += "survived"
		if(ply.current.real_name != ply.name)
			text += " as [ply.current.real_name]"
	else
		var/icon/sprotch = icon('icons/effects/blood.dmi', "gibbearcore")
		end_icons += sprotch
		tempstate = end_icons.len
		text += {"<br><img src="logo_[tempstate].png"> <b>[ply.key]</b> was <b>[ply.name]</b> ("}
		text += "body destroyed"
	text += ")"
	return text

//Used for printing antag logo
/datum/game_mode/proc/printlogo(logoname, antagname)
	var/icon/logo = icon('icons/mob/mob.dmi', "[logoname]-logo")
	end_icons += logo
	var/tempstate = end_icons.len
	var/text = ""
	text += {"<img src="logo_[tempstate].png"> <b>The [antagname] were:</b> <img src="logo_[tempstate].png">"}
	return text

// Adds the specified antag hud to the player. Usually called in an antag datum file
/datum/proc/add_antag_hud(antag_hud_type, antag_hud_name, mob/living/mob_override)
	var/datum/atom_hud/antag/hud = global.huds[antag_hud_type]
	hud.join_hud(mob_override)
	set_antag_hud(mob_override, antag_hud_name)

// Removes the specified antag hud from the player. Usually called in an antag datum file
/datum/proc/remove_antag_hud(antag_hud_type, mob/living/mob_override)
	var/datum/atom_hud/antag/hud = global.huds[antag_hud_type]
	hud.leave_hud(mob_override)
	set_antag_hud(mob_override, null)

/datum/game_mode/proc/declare_completion()
	return GetScoreboard()

/datum/game_mode/proc/get_mode_result()
	if(factions_allowed.len)
		for(var/type in factions_allowed)
			var/list/datum/faction/game_mode_factions = find_factions_by_type(type)
			for(var/datum/faction/faction in game_mode_factions)
				if(!faction.IsSuccessful())
					return "lose"
	return "win"

//1 = station, 2 = centcomm
/datum/game_mode/proc/ShuttleDocked(state)
	for(var/datum/faction/F in factions)
		F.ShuttleDocked(state)
	for(var/datum/role/R in orphaned_roles)
		R.ShuttleDocked(state)
