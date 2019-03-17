//--------------------------------------------------------------------------------------- 
//  FILE:    X2Effect_Executioner
//  AUTHOR:  John Lumpkin (Pavonis Interactive)
//  PURPOSE: Sets up Executioner perk effect
//--------------------------------------------------------------------------------------- 

class X2Effect_Liberators_Executioner extends X2Effect_Persistent;

function GetToHitModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
    local XComGameState_Item SourceWeapon;
    local ShotModifierInfo ShotInfo;
	local float TargetHPPerc;

    SourceWeapon = AbilityState.GetSourceWeapon();    
    if ((SourceWeapon != none) && (Target != none))
    {
		if (Target.GetCurrentStat(eStat_HP) <= (Target.GetMaxStat(eStat_HP) / 2))
		{
			TargetHPPerc = Target.GetCurrentStat(eStat_HP) / Target.GetMaxStat(eStat_HP);

			if(TargetHPPerc < 1)
			{
				ShotInfo.ModType = eHit_Success;
				ShotInfo.Reason = FriendlyName;
				ShotInfo.Value = round(class'X2Ability_LiberatorsOperativePerks'.default.EXECUTIONER_AIM_BONUS * (1 - TargetHPPerc));
				ShotModifiers.AddItem(ShotInfo);
			}
        }
    }    
}

function bool ChangeHitResultForAttacker(XComGameState_Unit Attacker, XComGameState_Unit TargetUnit, XComGameState_Ability AbilityState, const EAbilityHitResult CurrentResult, out EAbilityHitResult NewHitResult)
{
    local int RandRoll, HitChance;

    if (AbilityState.GetSourceWeapon() == Attacker.GetItemInSlot(eInvSlot_PrimaryWeapon))
    {
        if(class'XComGameStateContext_Ability'.static.IsHitResultMiss(CurrentResult))
        {
			if(TargetUnit.GetCurrentStat(eStat_HP) <= (TargetUnit.GetMaxStat(eStat_HP) / 2))
			{
				NewHitResult = eHit_Graze;
				return true;
			}
        }
    }
    return false;
}

defaultproperties
{
    DuplicateResponse=eDupe_Ignore
    EffectName="LW2WotC_Executioner"
}