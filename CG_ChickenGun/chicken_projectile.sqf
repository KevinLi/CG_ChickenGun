comment "Replace projectile with chicken.";

comment "Get and remove a chicken from the chicken array.";
_chicken = chicken_array deleteAt 0;

comment "Set the direction of the chicken to the direction of the projectile.";
_chicken setDir (getDir (_this select 6));

comment "Get the velocity of the original projectile.";
_velocity = velocity (_this select 6);

comment "setVelocity does not work if the chicken has just been setPos'd out of water.";
comment "Avoid letting chickens touch water.";

comment "Set chicken position and velocity depending on the weapon fired.";
comment "This does not affect smoke screens.";
switch (true) do {
	case ((_this select 1) == "Throw"): {
		comment "Thrown chicken.";
		_chicken setPos ((_this select 6) modelToWorld [0, 0.66, -0.15]);
		_chicken setVelocity [
			(_velocity select 0) / 2,
			(_velocity select 1) / 2,
			(_velocity select 2) / 2
		];
	};
	case ((_this select 5) in ["Titan_AA", "Titan_AT", "NLAW_F"]): {
		comment "Rocket chicken.";
		_chicken setPos ((_this select 6) modelToWorld [0, 0.66, -0.15]);
		_chicken setVelocity [
			(_velocity select 0) / 3,
			(_velocity select 1) / 3,
			(_velocity select 2) / 3
		];
	};
	case ((_this select 5) in ["RPG32_F", "RPG32_HE_F"]): {
		comment "Alamut rocket chicken.";
		_chicken setPos ((_this select 6) modelToWorld [0, 0.66, -0.15]);
		_chicken setVelocity [
			(_velocity select 0) / 5,
			(_velocity select 1) / 5,
			(_velocity select 2) / 5
		];
	};
	case ((_this select 4) in ["R_230mm_HE"]): {
		comment "Multiple launch chicken system chicken.";
		_chicken setPos ((_this select 6) modelToWorld [0, 1.50, -0.15]);
		_chicken setVelocity [
			(_velocity select 0) / 12,
			(_velocity select 1) / 12,
			(_velocity select 2) / 12
		];
	};
	case ((_this select 1) in ["cannon_105mm", "cannon_120mm", "LMG_M200", "HMG_127_MBT"]): {
		comment "Tank chicken.";
		_chicken setPos ((_this select 6) modelToWorld [0, 1.66, -0.15]);
		_chicken setVelocity [
			(_velocity select 0) / 34,
			(_velocity select 1) / 34,
			(_velocity select 2) / 34
		];
	};
	case ((_this select 1) in ["mortar_155mm_AMOS"]): {
		comment "Artillery chicken.";
		_chicken setPos ((_this select 6) modelToWorld [0, 2, -0.15]);
		_chicken setVelocity [
			(_velocity select 0) / 4,
			(_velocity select 1) / 4,
			(_velocity select 2) / 4
		];
	};
	case ((_this select 1) in ["gatling_30mm"]): {
		comment "Gatling chicken.";
		_chicken setPos ((_this select 6) modelToWorld [0, 1.25, -0.25]);
		_chicken setVelocity [
			(_velocity select 0) / 40,
			(_velocity select 1) / 40,
			(_velocity select 2) / 40
		];
	};
	default {
		comment "Rifle chicken.";
		_chicken setPos ((_this select 6) modelToWorld [0, 0.66, -0.15]);
		_chicken setVelocity [
			(_velocity select 0) / 30,
			(_velocity select 1) / 30,
			(_velocity select 2) / 30
		];
	};
};
comment "To-do: https://community.bistudio.com/wiki/Arma_3_CfgWeapons_Vehicle_Weapons";

comment "Recycle the chicken. Put the chicken object at the end of the array.";
chicken_array set [39, _chicken];

comment "Remove the original non-chicken projectile.";
deleteVehicle (_this select 6);

comment "Replace the next chicken if it's dead.";
comment "Move the next chicken close to the player if necessary.";
if (!alive (chicken_array select 0)) then {
	comment "Create a new chicken.";
	_chicken_type = ["Hen_random_F", "Cock_random_F"] call BIS_fnc_selectRandom;
	_chicken = chicken_group createUnit [
		_chicken_type, (player modelToWorld [0, -250, 0]), [], 0, "CAN_COLLIDE"
	];

	comment "Delete the dead chicken from the scene.";
	deleteVehicle (chicken_array select 0);

	comment "Overwrite the dead chicken with the new alive chicken.";
	chicken_array set [0, _chicken];
} else {
	comment "If the chicken is alive, but not close by, move it near the player.";
	if (player distance (chicken_array select 0) > 250) then {
		(chicken_array select 0) setPos (player modelToWorld [0, -250, 0]);
	};
};
