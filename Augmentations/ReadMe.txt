[h1]You never asked for this.[/h1]

This mods lets you research and apply augmentations to your soldiers.

After you research Hybrid Materials a new category called 'Cybernetics' will be unlocked.

Once researched you can build Cybernetic upgrades in the proving ground.

Higher tier parts also require higher armor research like plated armor or power armor.

As soon as you have built a part you can augment a soldier by clicking on the new "Augmentations" menu item in the soldier menu.

When augmenting a body part it gets replaced by the new cosmetics this mod provided (this behavior can be disabled in the ini).

The cosmetics are fully tintable and patterns can be applied. The color of emissive parts like eyes can be changed via the eye color menu.

Its safe to add this mod mid-campaign

Details of the augmentations so far (more to come in the future)

[url=https://docs.google.com/spreadsheets/d/11FbXHnBZIf1MA1wiMtkTUNHTk0r3azRjG3e9zf8vD0k/edit?usp=sharing]Google Sheet[/url]

[h1]New wound mechanic[/h1]

Augmenting soldiers will reduce their healing time when they are wounded.

However when your soldier gets gravely wounded he gets assigned a body part randomly 
which needs to be augmented in order to heal again at all.
E.g his legs are critically wounded beyond repair and need to be replaced.

Looking for early augmenations to get your gravely wounded soldiers out there on the field again?
Checkout RealityMachina's excellent [url=http://steamcommunity.com/sharedfiles/filedetails/?id=1294744824]Mark Zero Augments[/url] mod.

[h1]Why the vest slot dependency?[/h1]

Cybernetic torsos provide a free vest slot to your soldiers. Normal soldiers do *not* get a free vest slot with this mod active.

[h1]Disabling the automatic cosmetic changing[/h1]
open the ini file with a text editor. 

Its located here:
%Steam%\SteamApps\workshop\content\268500\1293725945\Config\XComAugmentations.ini

and change 

[code]
bAddCosmeticOnAugmentation=true
[/code]
to
[code]
bAddCosmeticOnAugmentation=false
[/code]

[h1]FAQ[/h1]

[b]Can this be used in the Character Pool?[/b]
Yes the visual cosmetics are just that: cosmetics. They can be used in the CP as well as normal cosmetics on soldiers that aren't augmented.
The augmentation items can only be applied in game after researching cybernetic and building them in the foundry.

[b]Is this mod compatible with mod XY?[/b]
Should be compatible with all mods. If you have an issue let me know.

[b]Is there a way to disable the mandatory upgrades on Grave Wounds?[/b]
yes, set 
[code]
bUseGravelyWoundedMechanic = false
[/code]

[b]Can you do a LW2 or Vanilla version?[/b]
No i can't. I don't have both modding tools installed because they take up heaps of hd space and its too much effort to maintain multiple versions of a mod.


[h1]Credits[/h1]
[url=http://steamcommunity.com/id/MusashiKensai]Musashi[/url] - Gameplay design and coding
[url=http://steamcommunity.com/id/Robojumper]Robojumper[/url] - Custom Slot support in the Highlander (without this mod would not exist)
[url=http://steamcommunity.com/id/ObelixDk]ObelixDK[/url] - Claws Weapon animation, Rigging and Weight painting
[url=http://steamcommunity.com/id/nekoworkshop]Nekoworkshop[/url] - Textures
[url=http://steamcommunity.com/id/ShinyDiver]ShinyDiver[/url] - Localization
[url=http://steamcommunity.com/id/InternetExploder]InternetExploder[/url] - Tech Images
[url=http://steamcommunity.com/id/christhethinmint]Chris The Thin Mint[/url] - Concept work on the augmentations