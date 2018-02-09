class X2StrategyElement_AugmentationSlots extends CHItemSlotSet config (Augmentations);

var localized string strAugmentationFirstLetter;

var config array<name> CharacterTemplateBlacklist;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;
	Templates.AddItem(CreateAugmentationSlotTemplate('AugmentationHead', eInvSlot_AugmentationHead));
	Templates.AddItem(CreateAugmentationSlotTemplate('AugmentationTorso', eInvSlot_AugmentationTorso));
	Templates.AddItem(CreateAugmentationSlotTemplate('AugmentationArms', eInvSlot_AugmentationArms));
	Templates.AddItem(CreateAugmentationSlotTemplate('AugmentationLegs', eInvSlot_AugmentationLegs));
	return Templates;
}

static function X2DataTemplate CreateAugmentationSlotTemplate(name TemplateName, EInventorySlot InventorySlot)
{
	local CHItemSlot Template;

	`CREATE_X2TEMPLATE(class'CHItemSlot', Template, TemplateName);

	Template.InvSlot = InventorySlot;
	// Unused for now
	Template.IsUserEquipSlot = true;
	// Uses unique rule
	Template.IsEquippedSlot = true;
	// Does not bypass unique rule
	Template.BypassesUniqueRule = false;
	Template.IsMultiItemSlot = false;
	Template.IsSmallSlot = false;

	Template.CanAddItemToSlotFn = CanAddItemToAugmentationSlot;
	Template.UnitHasSlotFn = HasAugmentationSlot;
	Template.GetPriorityFn = AugmentationGetPriority;
	Template.ShowItemInLockerListFn = ShowAugmentationItemInLockerList;
	Template.ValidateLoadoutFn = AugmentationValidateLoadout;
	Template.UnitShowSlotFn = UnitShowAugmentationSlot;
	Template.GetSlotUnequipBehaviorFn = AugmentationSlotGetUnequipBehavior;

	return Template;
}

function ECHSlotUnequipBehavior AugmentationSlotGetUnequipBehavior(CHItemSlot Slot, ECHSlotUnequipBehavior DefaultBehavior, XComGameState_Unit Unit, XComGameState_Item ItemState, optional XComGameState CheckGameState)
{
	return eCHSUB_DontAllow;
}

static function bool UnitShowAugmentationSlot(CHItemSlot Slot, XComGameState_Unit UnitState, optional XComGameState CheckGameState)
{
	return false;
}

static function bool CanAddItemToAugmentationSlot(CHItemSlot Slot, XComGameState_Unit Unit, X2ItemTemplate Template, optional XComGameState CheckGameState, optional int Quantity = 1, optional XComGameState_Item ItemState)
{
	local string strDummy;
	local int Index;
	local LWTuple Tuple;
	local bool bOverrideCanAddItemToAugmentationSlot, bCanAddItemToAugmentationSlot;

	`log(GetFuncName() @ "called" @ Template.DataName @ Template.ItemCat,, 'Augmentations');

	Tuple = new class'LWTuple';
	Tuple.Id = 'OverrideCanAddItemToAugmentationSlot';
	Tuple.Data.Add(7);
	Tuple.Data[0].kind = LWTVBool;
	Tuple.Data[0].b = bOverrideCanAddItemToAugmentationSlot;
	Tuple.Data[1].kind = LWTVBool;
	Tuple.Data[1].b = bCanAddItemToAugmentationSlot;
	Tuple.Data[2].kind = LWTVObject;
	Tuple.Data[2].o = Slot;
	Tuple.Data[3].kind = LWTVObject;
	Tuple.Data[3].o = Template;
	Tuple.Data[4].kind = LWTVObject;
	Tuple.Data[4].o = CheckGameState;
	Tuple.Data[5].kind = LWTVObject;
	Tuple.Data[5].o = ItemState;
	Tuple.Data[6].kind = LWTVInt;
	Tuple.Data[6].i = Quantity;

	`XEVENTMGR.TriggerEvent('OverrideCanAddItemToAugmentationSlot', Tuple, Unit);
	
	bOverrideCanAddItemToAugmentationSlot = Tuple.Data[0].b;
	bCanAddItemToAugmentationSlot = Tuple.Data[1].b;

	if (bOverrideCanAddItemToAugmentationSlot)
	{
		return bCanAddItemToAugmentationSlot;
	}

	if (!Unit.IsSoldier() || default.CharacterTemplateBlacklist.Find(Unit.GetMyTemplateName()) != INDEX_NONE)
	{
		return false;
	}

	if (!Slot.UnitHasSlot(Unit, strDummy, CheckGameState) || Unit.GetItemInSlot(Slot.InvSlot, CheckGameState) != none)
	{
		return false;
	}

	Index = class'X2Item_Augmentations'.default.SlotConfig.Find('InvSlot', Slot.InvSlot);
	if (Index != INDEX_NONE)
	{
		return Template.ItemCat == class'X2Item_Augmentations'.default.SlotConfig[Index].Category;
	}
	return false;
}

static function bool HasAugmentationSlot(CHItemSlot Slot, XComGameState_Unit UnitState, out string LockedReason, optional XComGameState CheckGameState)
{
	//`log(GetFuncName() @ "called",, 'Augmentations');
	return UnitState.IsSoldier() && default.CharacterTemplateBlacklist.Find(UnitState.GetMyTemplateName()) == INDEX_NONE;
}

static function int AugmentationGetPriority(CHItemSlot Slot, XComGameState_Unit UnitState, optional XComGameState CheckGameState)
{
	`log(GetFuncName() @ "called",, 'Augmentations');
	return 120; // Ammo Pocket is 110 
}

static function bool ShowAugmentationItemInLockerList(CHItemSlot Slot, XComGameState_Unit Unit, XComGameState_Item ItemState, X2ItemTemplate ItemTemplate, XComGameState CheckGameState)
{
	local int Index;
	`log(GetFuncName() @ "called",, 'Augmentations');
	Index = class'X2Item_Augmentations'.default.SlotConfig.Find('InvSlot', Slot.InvSlot);
	if (Index != INDEX_NONE)
	{
		return ItemTemplate.ItemCat == class'X2Item_Augmentations'.default.SlotConfig[Index].Category;
	}
	return false;
}

static function string GetAugmentationDisplayLetter(CHItemSlot Slot)
{
	`log(GetFuncName() @ "called",, 'Augmentations');
	return default.strAugmentationFirstLetter;
}

static function AugmentationValidateLoadout(CHItemSlot Slot, XComGameState_Unit Unit, XComGameState_HeadquartersXCom XComHQ, XComGameState NewGameState)
{
	local XComGameState_Item EquippedAugmentation;
	local string strDummy;
	local bool HasSlot;
	EquippedAugmentation = Unit.GetItemInSlot(Slot.InvSlot, NewGameState);
	HasSlot = Slot.UnitHasSlot(Unit, strDummy, NewGameState);
	//`log(GetFuncName() @ "called",, 'Augmentations');
	if(EquippedAugmentation == none && HasSlot)
	{
		//EquippedSecondaryWeapon = GetBestSecondaryWeapon(NewGameState);
		//AddItemToInventory(EquippedSecondaryWeapon, eInvSlot_SecondaryWeapon, NewGameState);
	}
	else if(EquippedAugmentation != none && !HasSlot)
	{
		EquippedAugmentation = XComGameState_Item(NewGameState.ModifyStateObject(class'XComGameState_Item', EquippedAugmentation.ObjectID));
		Unit.RemoveItemFromInventory(EquippedAugmentation, NewGameState);
		XComHQ.PutItemInInventory(NewGameState, EquippedAugmentation);
		EquippedAugmentation = none;
	}

}

static function array<X2EquipmentTemplate> GetBestAugmentationTemplates()
{

}