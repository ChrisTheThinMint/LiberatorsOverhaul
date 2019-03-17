// This is an Unreal Script
class X2Ability_LiberatorsOperativePerks extends XMBAbility config(GameData_SoldierSkills);

var config int SPRINTER_MOBILITY;
var config int WALK_FIRE_COOLDOWN;
var config int WALK_FIRE_AMMO_COST;
var config int WALK_FIRE_SHRED;
var config int WALK_FIRE_AIM_BONUS;
var config int WALK_FIRE_CRIT_MALUS;
var config float WALK_FIRE_DAMAGE_PERCENT_MALUS;
var config int SENTINEL_LW_USES_PER_TURN;
var config array<name> SENTINEL_LW_ABILITYNAMES;
var config array<name> FULL_KIT_ITEMS;
var config int FULL_KIT_BONUS;
var config int TACTICAL_SENSE_DEF_BONUS_PER_ENEMY;
var config int TACTICAL_SENSE_MAX_DEF_BONUS;
var config bool TS_SQUADSIGHT_ENEMIES_APPLY;
var config int BOMBARDIER_BONUS_RANGE_TILES;
var config int BOOSTED_CORES_DAMAGE;
var config int COMBAT_FITNESS_HP;
var config int COMBAT_FITNESS_OFFENSE;
var config int COMBAT_FITNESS_MOBILITY;
var config int COMBAT_FITNESS_DODGE;
var config int COMBAT_FITNESS_WILL;
var config int EXECUTIONER_AIM_BONUS;
var config int AGGRESSION_CRIT_BONUS_PER_ENEMY;
var config int AGGRESSION_MAX_CRIT_BONUS;
var config bool AGG_SQUADSIGHT_ENEMIES_APPLY;
var config int HEAVY_IMPACT_PIERCE;
var config int HEAVY_IMPACT_SHRED;
var config int DGG_AIM_BONUS;
var config int DGG_DEF_BONUS;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;
    	
	Templates.AddItem(WalkFire());
	Templates.AddItem(Allrounder());
	Templates.AddItem(GrenadeSlot());
	Templates.AddItem(WellProtected());
	Templates.AddItem(Sprinter());
	Templates.AddItem(Sentinel());
	Templates.AddItem(FullKit());
	Templates.AddItem(TacticalSense());
	Templates.AddItem(Opportunist());
	Templates.AddItem(Bombardier());
	Templates.AddItem(BoostedCores());
	Templates.AddItem(CombatFitness());
	Templates.AddItem(DamnGoodGround());
	Templates.AddItem(HeavyImpact());
	Templates.AddItem(Aggression());
	Templates.AddItem(Executioner());
	Templates.AddItem(Steadfast());

	return Templates;
}

static function X2AbilityTemplate WalkFire()
{
	local X2AbilityTemplate Template;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;

	// Create the template using a helper function
	Template = Attack('Lib_WalkFire', "img:///UILibrary_LW_PerkPack.LW_Ability_WalkingFire", false, none, class'UIUtilities_Tactical'.const.CLASS_CAPTAIN_PRIORITY, eCost_WeaponConsumeAll, default.WALK_FIRE_AMMO_COST);

	// Add a cooldown.
	AddCooldown(Template, default.WALK_FIRE_COOLDOWN);

	// Add a secondary ability to provide bonuses on the shot
	AddSecondaryAbility(Template, WalkFireBonuses());
	//Template.AdditionalAbilities.AddItem('LW2WotC_WalkFire_Bonuses');

	return Template;
}

// This is part of the Walk Fire effect, above
static function X2AbilityTemplate WalkFireBonuses()
{
	local X2AbilityTemplate Template;
	local XMBEffect_ConditionalBonus Effect;
	local XMBCondition_AbilityName Condition;

	// Create a conditional bonus effect
	Effect = new class'XMBEffect_ConditionalBonus';
	Effect.EffectName = 'LW2WotC_WalkFire_Bonuses';

	// The bonus increases hit chance
	Effect.AddToHitModifier(default.WALK_FIRE_AIM_BONUS, eHit_Success);

	// The bonus reduces Crit chance
	Effect.AddToHitModifier(-1 * default.WALK_FIRE_CRIT_MALUS, eHit_Crit);

	// The bonus reduces damage by a percentage
	Effect.AddPercentDamageModifier(-1 * default.WALK_FIRE_DAMAGE_PERCENT_MALUS);

	Effect.AddShredModifier(default.WALK_FIRE_SHRED);

	// The bonus only applies to the Walk Fire ability
	Condition = new class'XMBCondition_AbilityName';
	Condition.IncludeAbilityNames.AddItem('Lib_WalkFire');
	Effect.AbilityTargetConditions.AddItem(Condition);

	// Create the template using a helper function
	Template = Passive('LW2WotC_WalkFire_Bonuses', "img:///UILibrary_LW_PerkPack.LW_Ability_WalkingFire", false, Effect);

	// Walk Fire will show up as an active ability, so hide the icon for the passive damage effect
	HidePerkIcon(Template);

	return Template;
}

static function X2AbilityTemplate Allrounder()
{
	//Does nothing for now, the bonus perk system will check for it
	return Passive('Lib_Allrounder', "img:///UILibrary_PerkIcons.UIPerk_one_for_all", false, none);
}

static function X2AbilityTemplate GrenadeSlot()
{
	// Create the template using a helper function - XComGameData.ini sets this perk as unlocking the grenade pocket
	return Passive('Lib_GrenadeSlot', "img:///UILibrary_LW_PerkPack.LW_AbilityFullKit", false, none);
}

static function X2AbilityTemplate WellProtected()
{
	// Create the template using a helper function - XComVestSlot.ini sets this perk as unlocking the vest pocket
	return Passive('Lib_WellProtected', "img:///UILibrary_FavidsPerkPack.Perk_Ph_WellProtected", false, none);
}

static function X2AbilityTemplate Sprinter()
{
	local X2Effect_PersistentStatChange			StatEffect;
	local X2AbilityTemplate 					Template;

	StatEffect = new class'X2Effect_PersistentStatChange';
	StatEffect.AddPersistentStatChange(eStat_Mobility, float(default.SPRINTER_MOBILITY));

	Template = Passive('Lib_Sprinter', "img:///UILibrary_LW_PerkPack.LW_AbilityExtraConditioning", false, StatEffect);;
	Template.SetUIStatMarkup(class'XLocalizedData'.default.MobilityLabel, eStat_Mobility, default.SPRINTER_MOBILITY);

	return Template;
}

static function X2AbilityTemplate FullKit()
{
	local XMBEffect_AddItemCharges BonusItemEffect;

	// The number of charges and the items that are affected are gotten from the config
	BonusItemEffect = new class'XMBEffect_AddItemCharges';
	BonusItemEffect.PerItemBonus = default.FULL_KIT_BONUS;
	BonusItemEffect.ApplyToNames = default.FULL_KIT_ITEMS;
	BonusItemEffect.ApplyToSlots.AddItem(eInvSlot_Utility);
	BonusItemEffect.ApplyToSlots.AddItem(eInvSlot_GrenadePocket);

	// Create the template using a helper function
	return Passive('Lib_FullKit', "img:///UILibrary_PerkIcons.UIPerk_aceinthehole", false, BonusItemEffect);
}

static function X2AbilityTemplate Sentinel()
{
	local X2AbilityTemplate                 Template;	
	local X2Effect_LW2WotC_Sentinel			PersistentEffect;

	// Sentinel effect
	PersistentEffect = new class'X2Effect_LW2WotC_Sentinel';

	// Create the template using a helper function
	Template = Passive('Lib_Sentinel', "img:///UILibrary_LW_PerkPack.LW_AbilitySentinel", false, PersistentEffect);
	Template.bIsPassive = false;

	return Template;
}

static function X2AbilityTemplate TacticalSense()
{
	local X2Effect_LW2WotC_TacticalSense		DefenseEffect;

	// Effect granting tactical sense defense bonuses
	DefenseEffect = new class 'X2Effect_LW2WotC_TacticalSense';

	// Create the template using a helper function
	return Passive('Lib_TacticalSense', "img:///UILibrary_LW_PerkPack.LW_AbilityTacticalSense", false, DefenseEffect);
}

static function X2AbilityTemplate Opportunist()
{
	local X2AbilityTemplate Template;
	local XMBEffect_ConditionalBonus LowCoverBonusEffect;
	local XMBEffect_ConditionalBonus FullCoverBonusEffect;

	Template = Passive('Lib_Opportunist', "img:///UILibrary_FavidsPerkPack.UIPerk_Opportunist", false, none);

    // Bonus for when targets are in low cover
	LowCoverBonusEffect = new class'XMBEffect_ConditionalBonus';
	LowCoverBonusEffect.AbilityTargetConditions.AddItem(default.HalfCoverCondition);
	LowCoverBonusEffect.AbilityTargetConditions.AddItem(default.ReactionFireCondition);
	LowCoverBonusEffect.AddToHitModifier(class'X2AbilityToHitCalc_StandardAim'.default.LOW_COVER_BONUS / 2);
    AddSecondaryEffect(Template, LowCoverBonusEffect);
    
    // Bonus for when targets are in full cover
	FullCoverBonusEffect = new class'XMBEffect_ConditionalBonus';
	FullCoverBonusEffect.AbilityTargetConditions.AddItem(default.FullCoverCondition);
	FullCoverBonusEffect.AbilityTargetConditions.AddItem(default.ReactionFireCondition);
	FullCoverBonusEffect.AddToHitModifier(class'X2AbilityToHitCalc_StandardAim'.default.HIGH_COVER_BONUS / 2);
    AddSecondaryEffect(Template, FullCoverBonusEffect);

    return Template;
}

static function X2AbilityTemplate Bombardier()
{
	local X2Effect_LW2WotC_Bombardier	BombardierEffect;

    // Effect that grants additional throw range with grenades
	BombardierEffect = new class 'X2Effect_LW2WotC_Bombardier';

	// Create the template using a helper function
	return Passive('Lib_Bombardier', "img:///UILibrary_LW_PerkPack.LW_AbilityBombard", false, BombardierEffect);
}

static function X2AbilityTemplate BoostedCores()
{
	local X2Effect_VolatileMix				DamageEffect;

	// Effect that grants additional damage to grenades
	// This is confusing, but X2Effect_VolatileMix grants a damage bonus to grenades, and does not apply a radius bonus
	DamageEffect = new class'X2Effect_VolatileMix';
	DamageEffect.BonusDamage = default.BOOSTED_CORES_DAMAGE;

	// Create the template using a helper function
	return Passive('Lib_BoostedCores', "img:///UILibrary_LW_PerkPack.LW_AbilityHeavyFrags", true, DamageEffect);
}

static function X2AbilityTemplate CombatFitness()
{
	local X2Effect_PersistentStatChange			StatEffect;
	local X2AbilityTemplate 					Template;

	StatEffect = new class'X2Effect_PersistentStatChange';
	StatEffect.AddPersistentStatChange(eStat_HP, float(default.COMBAT_FITNESS_HP));
	StatEffect.AddPersistentStatChange(eStat_Offense, float(default.COMBAT_FITNESS_OFFENSE));
	StatEffect.AddPersistentStatChange(eStat_Mobility, float(default.COMBAT_FITNESS_MOBILITY));
	StatEffect.AddPersistentStatChange(eStat_Dodge, float(default.COMBAT_FITNESS_DODGE));
	StatEffect.AddPersistentStatChange(eStat_Will, float(default.COMBAT_FITNESS_WILL));

	Template = Passive('Lib_CombatFitness', "img:///UILibrary_LW_PerkPack.LW_AbilityExtraConditioning", true, StatEffect);

	Template.SetUIStatMarkup(class'XLocalizedData'.default.HealthLabel, eStat_HP, default.COMBAT_FITNESS_HP);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.AimLabel, eStat_Offense, default.COMBAT_FITNESS_OFFENSE);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.MobilityLabel, eStat_Mobility, default.COMBAT_FITNESS_MOBILITY);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.DodgeLabel, eStat_Dodge, default.COMBAT_FITNESS_DODGE);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.WillLabel, eStat_Will, default.COMBAT_FITNESS_WILL);

	return Template;
}

static function X2AbilityTemplate Aggression()
{
	local X2Effect_LW2WotC_Aggression			CritEffect;

	// Effect graning aggression crit bonus
	CritEffect = new class 'X2Effect_LW2WotC_Aggression';

	// Create the template using a helper function
	return Passive('Lib_Aggression', "img:///UILibrary_LW_PerkPack.LW_AbilityAggression", true, CritEffect);
}

static function X2AbilityTemplate Executioner()
{
	local X2Effect_Liberators_Executioner		AimandCritModifiers;

	// Effect granting aim and crit bonuses against targets at half or less health
	AimandCritModifiers = new class 'X2Effect_Liberators_Executioner';

	// Create the template using a helper function
	return Passive('Lib_Executioner', "img:///UILibrary_LW_PerkPack.LW_AbilityExecutioner", true, AimandCritModifiers);
}

static function X2AbilityTemplate HeavyImpact()
{
	local X2AbilityTemplate Template;
	local XMBEffect_ConditionalBonus Effect;
	local XMBCondition_AbilityName Condition;

	// Create a conditional bonus effect
	Effect = new class'XMBEffect_ConditionalBonus';
	Effect.EffectName = 'Liberators_HeavyImpact_Bonuses';

	Effect.AddShredModifier(default.HEAVY_IMPACT_SHRED);
	Effect.AddArmorPiercingModifier(default.HEAVY_IMPACT_PIERCE);

	Effect.AbilityTargetConditions.AddItem(default.MatchingWeaponCondition);

	return Passive('Lib_HeavyImpact', "img:///UILibrary_LW_PerkPack.LW_AbilitySlugShot", true, Effect);
}

static function X2AbilityTemplate DamnGoodGround()
{
	local X2Effect_LW2WotC_DamnGoodGround			AimandDefModifiers;

	// Effect granting bonus aim and defense against lower elevation targets
	AimandDefModifiers = new class 'X2Effect_LW2WotC_DamnGoodGround';

	// Create the template using a helper function
	return Passive('Lib_DamnGoodGround', "img:///UILibrary_LW_PerkPack.LW_AbilityDamnGoodGround", true, AimandDefModifiers);
}

static function X2AbilityTemplate Steadfast()
{
    local X2Effect_DamageImmunity       Effect;
    
	Effect = new class'X2Effect_DamageImmunity';
	Effect.ImmuneTypes.AddItem('Mental');
	Effect.ImmuneTypes.AddItem(class'X2Item_DefaultDamageTypes'.default.DisorientDamageType);
	Effect.ImmuneTypes.AddItem('Stun');
	Effect.ImmuneTypes.AddItem('Unconscious');
    
	return Passive('Lib_Steadfast', "img:///UILibrary_FavidsPerkPack.Perk_Ph_Steadfast", false, Effect);
}