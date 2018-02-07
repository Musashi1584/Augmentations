class X2DownloadableContentInfo_Augmentations extends X2DownloadableContentInfo
	config(Augmentations);

struct SocketReplacementInfo
{
	var name TorsoName;
	var string SocketMeshString;
	var bool Female;
};

var config array<SocketReplacementInfo> SocketReplacements;

static event OnLoadedSavedGame()
{
	UpdateResearch();
}

static event OnLoadedSavedGameToStrategy()
{
	UpdateResearch();
}

static private function UpdateResearch()
{
	local XComGameStateHistory History;
	local XComGameState NewGameState;
	local X2TechTemplate TechTemplate;
	local XComGameState_Tech TechState;
	local X2StrategyElementTemplateManager	StratMgr;
	local array<Name> ResearchNames;
	local Name ResearchName;
	
	StratMgr = class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager();
	History = `XCOMHISTORY;	

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Adding Augmentations Research GameStates");

	ResearchNames.AddItem('Augmentations');
	ResearchNames.AddItem('AugmentationHead');
	ResearchNames.AddItem('AugmentationTorso');
	ResearchNames.AddItem('AugmentationArms');
	ResearchNames.AddItem('AugmentationLegs');
	ResearchNames.AddItem('AugmentationArmsClaw');
	ResearchNames.AddItem('AugmentationArmsGrapple');
	ResearchNames.AddItem('AugmentationLegsJumpModuleMK1');
	//ResearchNames.AddItem('AugmentationLegsMuscles');
	ResearchNames.AddItem('AugmentationTorsoNanoCoatingMK1');
	ResearchNames.AddItem('AugmentationHeadNeuralGunlink');
	ResearchNames.AddItem('AugmentationLegsJumpModuleMK2');
	ResearchNames.AddItem('AugmentationLegsSilentRunners');
	ResearchNames.AddItem('AugmentationHeadNeuralTacticalProcessor');
	ResearchNames.AddItem('AugmentationArmsWristLauncher');
	ResearchNames.AddItem('AugmentationTorsoNanoCoatingMK2');

	foreach ResearchNames(ResearchName)
	{
		if (!IsResearchInHistory(ResearchName))
		{
			TechTemplate = X2TechTemplate(StratMgr.FindStrategyElementTemplate(ResearchName));
			if (TechTemplate != none)
			{
				TechState = XComGameState_Tech(NewGameState.CreateNewStateObject(class'XComGameState_Tech', TechTemplate));
				NewGameState.AddStateObject(TechState);
			}
		}
	}
	if (NewGameState.GetNumGameStateObjects() > 0)
	{
		`GAMERULES.SubmitGameState(NewGameState);
	}
	else
	{
		History.CleanupPendingGameState(NewGameState);
	}
}

static function bool IsResearchInHistory(name ResearchName)
{
	local XComGameState_Tech	TechState;
	
	foreach `XCOMHISTORY.IterateByClassType(class'XComGameState_Tech', TechState)
	{
		if (TechState.GetMyTemplateName() == ResearchName)
		{
			return true;
		}
	}
	return false;
}

static function string DLCAppendSockets(XComUnitPawn Pawn)
{
	local SocketReplacementInfo SocketReplacement;
	local name TorsoName;
	local bool bIsFemale;
	local string DefaultString, ReturnString;
	local XComHumanPawn HumanPawn;

	`LOG("DLCAppendSockets" @ Pawn,, 'LegendaryGear');

	HumanPawn = XComHumanPawn(Pawn);
	if (HumanPawn == none) { return ""; }

	TorsoName = HumanPawn.m_kAppearance.nmTorso;
	bIsFemale = HumanPawn.m_kAppearance.iGender == eGender_Female;

	//`LOG("DLCAppendSockets: Torso= " $ TorsoName $ ", Female= " $ string(bIsFemale),, 'Augmentations');

	foreach default.SocketReplacements(SocketReplacement)
	{
		if (TorsoName != 'None' && TorsoName == SocketReplacement.TorsoName && bIsFemale == SocketReplacement.Female)
		{
			ReturnString = SocketReplacement.SocketMeshString;
			break;
		}
		else
		{
			if (SocketReplacement.TorsoName == 'Default' && SocketReplacement.Female == bIsFemale)
			{
				DefaultString = SocketReplacement.SocketMeshString;
			}
		}
	}
	if (ReturnString == "")
	{
		// did not find, so use default
		ReturnString = DefaultString;
	}
	`LOG("Returning mesh string: " $ ReturnString,, 'LegendaryGear');

	return ReturnString;
}

static function UpdateHumanPawnMeshMaterial(XComGameState_Unit UnitState, XComHumanPawn Pawn, MeshComponent MeshComp, name ParentMaterialName, MaterialInstanceConstant MIC)
{
	local XComLinearColorPalette Palette;
	local LinearColor ParamColor;

	//`LOG(GetFuncName() @ UnitState.GetFullName() @ MeshComp.ObjectArchetype @ ParentMaterialName @ String(MaterialInstanceConstant(MIC.Parent).Name)  @ MIC.Name,, 'Augmentations');

	//if ((InStr(Locs(string(Pawn.m_kAppearance.nmHead)), 'invis') != INDEX_NONE) &&
	//	(MaterialInstanceConstant(MIC.Parent).Name == 'Teeth' ||
	//	MaterialInstanceConstant(MIC.Parent).Name == 'Eyes'))
	//{
	//	if (SkeletalMeshComponent(MeshComp) != none)
	//	{
	//		SkeletalMeshComponent(MeshComp).SetHidden(true);
	//		return;
	//	}
	//}
	//else
	//{
	//	if (SkeletalMeshComponent(MeshComp) != none)
	//	{
	//		SkeletalMeshComponent(MeshComp).SetHidden(false);
	//	}
	//}

	if (String(MaterialInstanceConstant(MIC.Parent).Name) == "AugmentationsMaterial")
	{
		Palette = `CONTENT.GetColorPalette(ePalette_EyeColor);
		ParamColor = Palette.Entries[Pawn.m_kAppearance.iEyeColor > -1 ? Pawn.m_kAppearance.iEyeColor : 0].Primary;
		//MaterialInstanceConstant(MIC.Parent).SetVectorParameterValue('EmissiveColor', ParamColor);
		MIC.SetVectorParameterValue('EmissiveColor', ParamColor);
		`LOG(GetFuncName() @ "Setting EmissiveColor",, 'Augmentations');
	}
}

