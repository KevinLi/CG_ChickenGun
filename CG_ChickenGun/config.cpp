class CfgPatches {
	class CG_ChickenGun
	{
		units[] = {};
		weapons[] = {};
		requiredAddons[] = {};
		author[]= {"chicken_gun"};
	};
};

class CfgFunctions
{
	class CG
	{
		class CG_Functions
		{
			class CG_ChickenGun
			{
				file = "\CG_ChickenGun\init.sqf";
				postInit = 1;
			};
		};
	};
};
