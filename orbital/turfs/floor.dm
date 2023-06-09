#define TRAIT_MAINT_WALKER    "maint_walker"

/turf/simulated/floor/plating/orbital/CanPass(atom/A, turf/T)
	if(isliving(A))
		var/mob/living/L = A
		if(L.w_class <= SIZE_BIG || L.lying || HAS_TRAIT(L, TRAIT_MAINT_WALKER))
			return TRUE
		else
			to_chat(L, "<span class='warning'>Стоя тут не пролезть.</span>")
			return FALSE
	return ..()

/turf/simulated/floor/plating/orbital/attackby(obj/item/I, mob/user) //don't want any smartasses to fuck up our epic crawlable floors with floor tiles
	return
