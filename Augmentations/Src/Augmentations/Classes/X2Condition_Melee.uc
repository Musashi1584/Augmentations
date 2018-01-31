class X2Condition_Melee extends X2Condition;

event name CallAbilityMeetsCondition(XComGameState_Ability kAbility, XComGameState_BaseObject kTarget)
{
	if (kAbility.GetMyTemplate().IsMelee())
	{
		return 'AA_Success';
	}

	return 'AA_NoMelee';
}