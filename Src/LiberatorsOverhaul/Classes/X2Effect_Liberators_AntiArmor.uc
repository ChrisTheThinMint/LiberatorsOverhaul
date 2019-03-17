//---------------------------------------------------------------------------------------
//  FILE:    X2Effect_HEATGrenades.uc
//  AUTHOR:  Amineri (Pavonis Interactive)
//  PURPOSE: Grants grenades the ability to pierce armor
//---------------------------------------------------------------------------------------
class X2Effect_Liberators_AntiArmor extends X2Effect_Persistent;

var int Pierce;
var int Shred;

function int GetExtraArmorPiercing(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData)
{
    local XComGameState_Item SourceWeapon;
    local X2WeaponTemplate WeaponTemplate;
    local X2AbilityToHitCalc_StandardAim StandardHit;
	local X2Effect_ApplyWeaponDamage WeaponDamageEffect;
    local XComGameState_Unit TargetUnit;

    SourceWeapon = AbilityState.GetSourceWeapon();
    WeaponTemplate = X2WeaponTemplate(SourceWeapon.GetMyTemplate());
    
    if(WeaponTemplate == none)
        return 0;

    SourceWeapon = AbilityState.GetSourceWeapon();
	if (class'XComGameStateContext_Ability'.static.IsHitResultHit(AppliedData.AbilityResultContext.HitResult))
	{
		if(SourceWeapon != none) 
		{
			if(	AbilityState.SourceWeapon != EffectState.ApplyEffectParameters.ItemStateObjectRef)
			{
				return 0;
			}
			if (X2WeaponTemplate(AbilityState.GetSourceWeapon().GetMyTemplate()).WeaponCat == 'grenade')
			{
				return 0;
			}
			if (AbilityState.GetMyTemplateName() == 'LW2WotC_RocketLauncher' || AbilityState.GetMyTemplateName() == 'LW2WotC_BlasterLauncher' || AbilityState.GetMyTemplateName() == 'MicroMissiles')
			{
				return 0;
			}
			StandardHit = X2AbilityToHitCalc_StandardAim(AbilityState.GetMyTemplate().AbilityToHitCalc);
			if(StandardHit != none && StandardHit.bIndirectFire) 
			{
				return 0;
			}
			WeaponDamageEffect = X2Effect_ApplyWeaponDamage(class'X2Effect'.static.GetX2Effect(AppliedData.EffectRef));
			if (WeaponDamageEffect != none)
			{
				if (WeaponDamageEffect.bIgnoreBaseDamage)
				{
					return 0;
				}
			}
			TargetUnit = XComGameState_Unit(TargetDamageable);
			if(TargetUnit != none)
			{
				return Pierce;
			}
		}
	}
    return 0;
}

function int GetExtraShredValue(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData)
{
    local XComGameState_Item SourceWeapon;
    local X2WeaponTemplate WeaponTemplate,SourceWeaponAmmoTemplate;
    local X2AbilityToHitCalc_StandardAim StandardHit;
	local X2Effect_ApplyWeaponDamage WeaponDamageEffect;
    local XComGameState_Unit TargetUnit;

    SourceWeapon = AbilityState.GetSourceWeapon();
    WeaponTemplate = X2WeaponTemplate(SourceWeapon.GetMyTemplate());
    
    if(WeaponTemplate == none)
        return 0;

    // make sure the weapon is either a grenade or a grenade launcher
    if (class'XComGameStateContext_Ability'.static.IsHitResultHit(AppliedData.AbilityResultContext.HitResult))
	{
		if(SourceWeapon != none) 
		{
			if(	AbilityState.SourceWeapon != EffectState.ApplyEffectParameters.ItemStateObjectRef)
			{
				return 0;
			}
			if (X2WeaponTemplate(AbilityState.GetSourceWeapon().GetMyTemplate()).WeaponCat == 'grenade')
			{
				return 0;
			}
			if (AbilityState.GetMyTemplateName() == 'LW2WotC_RocketLauncher' || AbilityState.GetMyTemplateName() == 'LW2WotC_BlasterLauncher' || AbilityState.GetMyTemplateName() == 'MicroMissiles')
			{
				return 0;
			}
			StandardHit = X2AbilityToHitCalc_StandardAim(AbilityState.GetMyTemplate().AbilityToHitCalc);
			if(StandardHit != none && StandardHit.bIndirectFire) 
			{
				return 0;
			}
			WeaponDamageEffect = X2Effect_ApplyWeaponDamage(class'X2Effect'.static.GetX2Effect(AppliedData.EffectRef));
			if (WeaponDamageEffect != none)
			{
				if (WeaponDamageEffect.bIgnoreBaseDamage)
				{
					return 0;
				}
			}
			TargetUnit = XComGameState_Unit(TargetDamageable);
			if(TargetUnit != none)
			{
				return Shred;
			}
		}
	}
    return 0;
}

DefaultProperties
{
    EffectName="HeatGrenadesEffect"
    DuplicateResponse = eDupe_Ignore
}
