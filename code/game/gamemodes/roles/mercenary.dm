/datum/role/mercenary
	name = "Mercenary"
	id = "Mercenary"
	logo_state = "synd-logo"
	skillset_type = /datum/skillset/officer
	change_to_maximum_skills = TRUE

/datum/role/mercenary/forgeObjectives()
	. = ..()
	if(!.)
		return

	if(prob(50) && mode_has_antags())
		AppendObjective(/datum/objective/target/assassinate, TRUE)
	else
		AppendObjective(/datum/objective/target/protect, TRUE)
	AppendObjective(/datum/objective/escape)
