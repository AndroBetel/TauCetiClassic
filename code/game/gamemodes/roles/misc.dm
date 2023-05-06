/datum/role/nanotrasen_agent
	name = NANOTRASEN_AGENT
	id = NANOTRASEN_AGENT

	logo_state = "nano-logo"

/datum/role/nanotrasen_agent/Greet(greeting, custom)
	. = ..()
	to_chat(antag.current, "<span class = 'info'><B>�� - <font color='blue'>������ ����� �����������</font>!</B></span>")
	to_chat(antag.current, "������ ������� ����� ������������� ����������� ���������, ��� ���� ��������� ������ [station_name_ru()] �������� �����������, ����������� �� ��������.")
	to_chat(antag.current, "<B>�� ������ ���������� ����, ��� ���� �������� �����������.</B></span>")

/datum/role/nanotrasen_agent/forgeObjectives()
	if(!..())
		return FALSE
	var/list/heads = get_living_heads()

	for(var/datum/mind/head_mind in heads)
		var/datum/objective/target/assassinate/A = AppendObjective(/datum/objective/target/assassinate, TRUE)
	return TRUE
