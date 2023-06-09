/atom/examine(mob/user, distance = -1)
	. = ..()

	if(get_dist(src, user) > 1)
		return
	if(!HAS_TRAIT(user, TRAIT_PSIONIC))
		return

	if(length(fingerprintshidden) < 1)
		return

	var/static/regex/fingerprint2real_name_regex = new(@"Real name: (.*),")

	var/n = min(length(fingerprintshidden), 3)
	var/list/last_n_fingerprints = list()

	for(var/i in 1 to n)
		var/fingerprint = fingerprintshidden[length(fingerprintshidden) - i + 1]
		if(!fingerprint2real_name_regex.Find(fingerprint))
			continue
		if(!fingerprint2real_name_regex.group[1])
			continue
		last_n_fingerprints += fingerprint2real_name_regex.group[1]

	if(length(last_n_fingerprints) < 1)
		return

	last_n_fingerprints = shuffle(last_n_fingerprints)

	var/last_touched_message = "<span class='shadowling'>You feel the touches of:\n"
	for(var/real_name in last_n_fingerprints)
		last_touched_message += "- [real_name]\n"
	last_touched_message += "</span>"

	to_chat(user, last_touched_message)
