//--------------------------------------------------------------------------------------- 
//  FILE:    X2Effect_DamnGoodGround
//  AUTHOR:  John Lumpkin (Pavonis Interactive)
//  PURPOSE: Sets up aim and defense bonuses for DG
//--------------------------------------------------------------------------------------- 

class X2Effect_LW2WotC_DamnGoodGround extends X2Effect_Persistent;

function GetToHitModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
    local XComGameState_Item SourceWeapon;
    local ShotModifierInfo ShotInfo;

	//if (Attacker.IsImpaired(false) || Attacker.IsBurning())
//		return;

    SourceWeapon = AbilityState.GetSourceWeapon();    
    if(SourceWeapon != none)
    {
		if (Attacker.HasHeightAdvantageOver(Target, true))
		{
		    ShotInfo.ModType = eHit_Success;
            ShotInfo.Reason = FriendlyName;
			ShotInfo.Value = class'X2Ability_LiberatorsOperativePerks'.default.DGG_AIM_BONUS;
            ShotModifiers.AddItem(ShotInfo);
        }
    }    
}

function GetToHitAsTargetModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
    local ShotModifierInfo ShotInfo;

	if (Target.IsImpaired(false) || Target.IsBurning() || Target.IsPanicked())
		return;

	if (Target.HasHeightAdvantageOver(Attacker, true))
	{
		ShotInfo.ModType = eHit_Success;
		ShotInfo.Reason = FriendlyName;
		ShotInfo.Value = -class'X2Ability_LiberatorsOperativePerks'.default.DGG_DEF_BONUS;
		ShotModifiers.AddItem(ShotInfo);
	}
}

defaultproperties
{
    DuplicateResponse=eDupe_Ignore
    EffectName="LW2WotC_DamnGoodGround"
}


