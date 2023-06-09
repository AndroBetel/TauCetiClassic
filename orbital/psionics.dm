/atom
	var/psionic_traces

/atom/add_hiddenprint(mob/M, ignoregloves = 0)
	. = ..()
	if(!M || !M.key || isAI(M))
		return
	if(fingerprintslast == M.key)
		return
	LAZYADD(psionic_traces, M.real_name)

/atom/add_fingerprint(mob/M, ignoregloves = 0)
	. = ..()
	if(!M || !M.key || isAI(M))
		return
	if(fingerprintslast == M.key)
		return
	LAZYADD(psionic_traces, M.real_name)

/atom/transfer_fingerprints_to(atom/A)
	. = ..()
	if(!psionic_traces)
		return
	LAZYINITLIST(A.psionic_traces)
	A.psionic_traces += psionic_traces

/atom/examine(mob/user, distance = -1)
	. = ..()

	if(get_dist(src, user) > 1)
		return
	if(!HAS_TRAIT(user, TRAIT_PSIONIC))
		return
	if(length(psionic_traces) < 1)
		return

	var/n = min(length(psionic_traces), 3)
	var/list/last_n_fingerprints = list()

	for(var/i in 1 to n)
		var/fingerprint = psionic_traces[length(psionic_traces) - i + 1]
		last_n_fingerprints += fingerprint

	if(length(last_n_fingerprints) < 1)
		return

	last_n_fingerprints = shuffle(last_n_fingerprints)

	var/last_touched_message = "<span class='shadowling'>You feel the touches of:\n"
	for(var/real_name in last_n_fingerprints)
		last_touched_message += "- [real_name]\n"
	last_touched_message += "</span>"

	to_chat(user, last_touched_message)
