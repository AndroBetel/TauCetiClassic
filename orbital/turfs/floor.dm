#define TRAIT_MAINT_WALKER    "maint_walker"

/turf/simulated/floor/plating/orbital/CanPass(atom/A, turf/T)
	if(ishuman(A))
		var/mob/living/carbon/human/H = A
		if(!H.lying  && !HAS_TRAIT(H, TRAIT_MAINT_WALKER))
			to_chat(H, "<span class='warning'>Стоя тут не пролезть.</span>")
			return FALSE
		else
			return TRUE
