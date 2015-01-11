if (isDedicated or !hasInterface) exitWith {};

[] spawn {
	waitUntil {!isNull player && player == player;};
	waitUntil {!isNil "BIS_fnc_init";};
	waitUntil {!isNull (findDisplay 46);};

	chicken_enabled = false;
	chicken_player_vehicle = vehicle player;

	chicken_event_handler_id = 0;
	chicken_veh_event_handler_id = 0;

	comment "Create a set number of recyclable chickens.";
	comment "Creating a chicken on-the-fly has a delay between";
	comment "firing and actual physics simulation of the created chicken.";
	chicken_array = [];
	chicken_group = createGroup civilian;
	chicken_create_code = {
		comment "Find a location on land to spawn the chickens.";
		_chicken_spawn = switch (worldName) do {
			case "Altis":   { [11521, 8900, 0.1] };
			case "Stratis": { [ 3231, 4083, 0.1] };
			default         { [    0,    0, 0.1] };
		};
		for "_x" from 0 to 39 do {
			comment "There are only two types of chicken.";
			_chicken_type = ["Hen_random_F", "Cock_random_F"] call BIS_fnc_selectRandom;
			_chicken = chicken_group createUnit [
				_chicken_type, _chicken_spawn, [], 0, "CAN_COLLIDE"
			];
			chicken_array set [_x, _chicken];
		};
	};

	chicken_projectile = compile loadFile "CG_ChickenGun\chicken_projectile.sqf";
	chicken_vehicle_weapon = compile loadFile "CG_ChickenGun\chicken_vehicle_weapon.sqf";

	chicken_action_enable_func = {
		chicken_action_enable = player addAction ["Enable ChickenGun", {
			player removeAction chicken_action_enable;
			[] call chicken_create_code;
			comment "Move the first chicken close to the player.";
			(chicken_array select 0) setPos (player modelToWorld [0, -250, 0]);
			chicken_enabled = true;
			chicken_event_handler_id = player addEventHandler ["Fired", chicken_projectile];
			systemChat "ChickenGun Enabled";
			[] spawn chicken_action_disable_func;
			[] spawn chicken_vehicle_weapon;
		}];
	};

	chicken_action_disable_func = {
		chicken_action_disable = player addAction ["Disable ChickenGun", {
			player removeAction chicken_action_disable;
			chicken_enabled = false;
			player removeEventHandler ["Fired", chicken_event_handler_id];
			chicken_player_vehicle removeEventHandler ["Fired", chicken_veh_event_handler_id];
			{deleteVehicle _x;} forEach chicken_array;
			chicken_array = [];
			systemChat "ChickenGun Disabled";
			[] spawn chicken_action_enable_func;
		}];
	};

	[] spawn chicken_action_enable_func;

	systemChat "ChickenGun Initialized";
};

comment "Make sure the scrollmenu actions persist after player respawn.";
player addEventHandler ["Respawn", {
	if (chicken_enabled) then {
		[] spawn chicken_action_disable_func;
	} else {
		[] spawn chicken_action_enable_func;
	};
}];
