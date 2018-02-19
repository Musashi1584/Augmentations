class X2StrategyElement_AugmentationTechs extends X2StrategyElement config (Augmentations);

var config int TIER1_BUILD_TIME;
var config int TIER2_BUILD_TIME;
var config int TIER3_BUILD_TIME;

var config int TIER1_SUPPLY_COST;
var config int TIER2_SUPPLY_COST;
var config int TIER3_SUPPLY_COST;

var config int TIER1_CORE_COST;
var config int TIER2_CORE_COST;
var config int TIER3_CORE_COST;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Techs;

	// Research
	Techs.AddItem(CreateAugmentationTemplate());

	// CV
	Techs.AddItem(CreateProvingGroundTemplate('AugmentationHead', 'AugmentationHead_Base_CV', 1, "img:///UILibrary_Augmentations.TECH_Augmentations_HEAD"));
	Techs.AddItem(CreateProvingGroundTemplate('AugmentationTorso', 'AugmentationTorso_Base_CV', 1, "img:///UILibrary_Augmentations.TECH_Augmentations_TORSO"));
	Techs.AddItem(CreateProvingGroundTemplate('AugmentationArms', 'AugmentationArms_Base_CV', 1, "img:///UILibrary_Augmentations.TECH_Augmentations_ARM"));
	Techs.AddItem(CreateProvingGroundTemplate('AugmentationLegs', 'AugmentationLegs_Base_CV', 1, "img:///UILibrary_Augmentations.TECH_Augmentations_LEG"));
	
	// MG
	Techs.AddItem(CreateProvingGroundTemplate('AugmentationArmsClaw', 'AugmentationArms_Claws_MG', 2, "img:///UILibrary_Augmentations.TECH_Augmentations_ARM"));
	Techs.AddItem(CreateProvingGroundTemplate('AugmentationArmsGrapple', 'AugmentationArms_Grapple_MG', 2, "img:///UILibrary_Augmentations.TECH_Augmentations_ARM"));
	Techs.AddItem(CreateProvingGroundTemplate('AugmentationLegsJumpModuleMK1', 'AugmentationLegs_JumpModule_MG', 2, "img:///UILibrary_Augmentations.TECH_Augmentations_LEG"));
	Techs.AddItem(CreateProvingGroundTemplate('AugmentationTorsoNanoCoatingMK1', 'AugmentationTorso_NanoCoating_MG', 2, "img:///UILibrary_Augmentations.TECH_Augmentations_TORSO"));
	//Techs.AddItem(CreateProvingGroundTemplate('AugmentationTorsoBodyCompartment', 'AugmentationTorso_BodyCompartment_MG', 2, "img:///UILibrary_Augmentations.TECH_Augmentations_TORSO"));
	Techs.AddItem(CreateProvingGroundTemplate('AugmentationHeadNeuralGunlink', 'AugmentationHead_NeuralGunlink_MG', 2, "img:///UILibrary_Augmentations.TECH_Augmentations_HEAD"));
	Techs.AddItem(CreateProvingGroundTemplate('AugmentationHeadWeakpointAnalyzerMK1', 'AugmentationHead_WeakpointAnalyzer_MG', 2, "img:///UILibrary_Augmentations.TECH_Augmentations_HEAD"));
	
	// BM
	Techs.AddItem(CreateProvingGroundTemplate('AugmentationLegsJumpModuleMK2', 'AugmentationLegs_JumpModule_BM', 3, "img:///UILibrary_Augmentations.TECH_Augmentations_LEG"));
	Techs.AddItem(CreateProvingGroundTemplate('AugmentationLegsSilentRunners', 'AugmentationLegs_SilentRunners_BM', 3, "img:///UILibrary_Augmentations.TECH_Augmentations_LEG"));
	Techs.AddItem(CreateProvingGroundTemplate('AugmentationHeadNeuralTacticalProcessor', 'AugmentationHead_NeuralTacticalProcessor_BM', 3, "img:///UILibrary_Augmentations.TECH_Augmentations_HEAD"));
	Techs.AddItem(CreateProvingGroundTemplate('AugmentationArmsWristLauncher', 'AugmentationArms_Launcher_BM', 3, "img:///UILibrary_Augmentations.TECH_Augmentations_ARM"));
	Techs.AddItem(CreateProvingGroundTemplate('AugmentationTorsoNanoCoatingMK2', 'AugmentationTorso_NanoCoating_BM', 3, "img:///UILibrary_Augmentations.TECH_Augmentations_TORSO"));
	Techs.AddItem(CreateProvingGroundTemplate('AugmentationHeadWeakpointAnalyzerMK2', 'AugmentationHead_WeakpointAnalyzer_BM', 3, "img:///UILibrary_Augmentations.TECH_Augmentations_TORSO"));

	if (class'X2DownloadableContentInfo_Augmentations'.static.IsModInstalled('X2DownloadableContentInfo_XCOM2RPGOverhaul'))
	{
		Techs.AddItem(CreateProvingGroundTemplate('AugmentationLegsMuscles', 'AugmentationLegs_Muscles_MG', 2, "img:///UILibrary_Augmentations.TECH_Augmentations_LEG"));
	}

	return Techs;
}

// #######################################################################################
// -------------------------------- RESEARCH ---------------------------------------------
// #######################################################################################
static function X2DataTemplate CreateAugmentationTemplate()
{
	local X2TechTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, 'Augmentations');
	Template.PointsToComplete = 8400;
	Template.SortingTier = 1;
	Template.strImage = "img:///UILibrary_Augmentations.TECH_Augmentations";
	Template.bArmorTech = true;
	Template.bProvingGround = false;

	// Requirements
	Template.Requirements.RequiredTechs.AddItem('HybridMaterials');

	// Cost
	Resources.ItemTemplateName='AlienAlloy';
	Resources.Quantity = 10;
	Template.Cost.ResourceCosts.AddItem(Resources);

	return Template;
}

// #######################################################################################
// -------------------- PROVING GROUND TECHS ---------------------------------------------
// #######################################################################################
static function X2DataTemplate CreateProvingGroundTemplate(name TemplateName, name ItemReward, int Tier, string Image)
{
	local X2TechTemplate Template;
	local ArtifactCost Resources, Artifacts;

	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, TemplateName);
	
	Template.strImage = Image;

	Template.SortingTier = Tier;
	Template.Requirements.RequiredTechs.AddItem('Augmentations');

	switch (Tier)
	{
		case 1:
			Template.PointsToComplete = class'X2StrategyElement_DefaultTechs'.static.StafferXDays(1, default.TIER1_BUILD_TIME);

			// Cost
			if (default.TIER1_SUPPLY_COST > 0)
			{
				Resources.ItemTemplateName = 'Supplies';
				Resources.Quantity = default.TIER1_SUPPLY_COST;
				Template.Cost.ResourceCosts.AddItem(Resources);
			}

			if (default.TIER1_CORE_COST > 0)
			{
				Artifacts.ItemTemplateName = 'EleriumCore';
				Artifacts.Quantity = default.TIER1_CORE_COST;
				Template.Cost.ArtifactCosts.AddItem(Artifacts);
			}
			break;
		case 2:
			Template.PointsToComplete = class'X2StrategyElement_DefaultTechs'.static.StafferXDays(1, default.TIER2_BUILD_TIME);
			Template.Requirements.RequiredTechs.AddItem('PlatedArmor');

			// Cost
			if (default.TIER2_SUPPLY_COST > 0)
			{
				Resources.ItemTemplateName = 'Supplies';
				Resources.Quantity = default.TIER2_SUPPLY_COST;
				Template.Cost.ResourceCosts.AddItem(Resources);
			}

			if (default.TIER2_CORE_COST > 0)
			{
				Artifacts.ItemTemplateName = 'EleriumCore';
				Artifacts.Quantity = default.TIER2_CORE_COST;
				Template.Cost.ArtifactCosts.AddItem(Artifacts);
			}
			break;
		case 3:
			Template.PointsToComplete = class'X2StrategyElement_DefaultTechs'.static.StafferXDays(1, default.TIER3_BUILD_TIME);
			Template.Requirements.RequiredTechs.AddItem('PoweredArmor');

			// Cost
			if (default.TIER3_SUPPLY_COST > 0)
			{
				Resources.ItemTemplateName = 'Supplies';
				Resources.Quantity = default.TIER3_SUPPLY_COST;
				Template.Cost.ResourceCosts.AddItem(Resources);
			}

			if (default.TIER3_CORE_COST > 0)
			{
				Artifacts.ItemTemplateName = 'EleriumCore';
				Artifacts.Quantity = default.TIER3_CORE_COST;
				Template.Cost.ArtifactCosts.AddItem(Artifacts);
			}
			break;
	}

	Template.ResearchCompletedFn = class'X2StrategyElement_DefaultTechs'.static.GiveRandomItemReward;
	Template.ItemRewards.AddItem(ItemReward);

	Template.bProvingGround = true;
	Template.bRepeatable = true;

	return Template;
}