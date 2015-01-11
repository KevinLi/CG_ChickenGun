comment "Fire chickens from vehicle turrets.";

_vehicle_role_prev = "";
_vehicle_role_curr = "";
if ((assignedVehicleRole player) isEqualTo []) then {
	_vehicle_role_curr = "";
} else {
	_vehicle_role_curr = (assignedVehicleRole player) select 0;
};
_player_vehicle_manual_fire = isManualFire vehicle player;
chicken_player_vehicle = vehicle player;

while {chicken_enabled} do {
	waitUntil {
		if ((assignedVehicleRole player) isEqualTo []) then {
			_vehicle_role_curr = "";
		} else {
			_vehicle_role_curr = (assignedVehicleRole player) select 0;
		};
		switch (true) do {
			case (chicken_player_vehicle != vehicle player): {
				comment "Player exit/entered vehicle.";
				switch (true) do {
					case (vehicle player == player): {
						comment "Player exited vehicle.";
						if (_vehicle_role_prev == "driver") then {
							comment "Player was the driver,";
							if (isManualFire chicken_player_vehicle) then {
								comment "And manual fire was enabled. Remove the event handler.";
								chicken_player_vehicle removeEventHandler ["Fired", chicken_veh_event_handler_id];
							};
						};
						if (_vehicle_role_prev == "Turret") then {
							comment "Player was in the turret slot. Remove the event handler.";
							chicken_player_vehicle removeEventHandler ["Fired", chicken_veh_event_handler_id];
						};
						comment "Vehicle role doesn't automatically change upon exiting.";
						unassignVehicle player;
						_vehicle_role_prev = "";
						_vehicle_role_curr = "";
					};
					case (vehicle player != player): {
						comment "Player enters vehicle.";
						_player_vehicle_manual_fire = isManualFire vehicle player;
						if (_vehicle_role_curr == "Turret") then {
							comment "Player got into gunner seat. Add the event handler.";
							chicken_veh_event_handler_id = (vehicle player) addEventHandler ["Fired", chicken_projectile];
						};
						if (_vehicle_role_curr == "driver") then {
							comment "Player got into driver seat.";
							if (isManualFire (vehicle player)) then {
								comment "Manual fire is ON. Add the event handler.";
								chicken_veh_event_handler_id = (vehicle player) addEventHandler ["Fired", chicken_projectile];
							};
							_player_vehicle_manual_fire = isManualFire (vehicle player)
						};
					};
				};
				chicken_player_vehicle = vehicle player;
				true;
			};
			case (_vehicle_role_curr != _vehicle_role_prev): {
				if (vehicle player == chicken_player_vehicle) then {
					comment "Player changed role within vehicle.";
					switch (true) do {
						case (_vehicle_role_curr == "Turret"): {
							comment "Player got into gunner seat. Add the event handler.";
							chicken_veh_event_handler_id = (vehicle player) addEventHandler ["Fired", chicken_projectile];
						};
						case (_vehicle_role_prev == "Turret"): {
							comment "Player changed out of gunner seat. Remove the event handler.";
							chicken_player_vehicle removeEventHandler ["Fired", chicken_veh_event_handler_id];
						};
					};
					_vehicle_role_prev = _vehicle_role_curr;
				};
				true;
			};
			case (!(_player_vehicle_manual_fire isEqualTo isManualFire (vehicle player))): {
				comment "Manual fire was toggled.";
				if (_vehicle_role_curr == "driver") then {
					comment "Player is in driver seat.";
					if (isManualFire (vehicle player)) then {
						comment "Manual fire is toggled ON.  Add the event handler.";
						chicken_veh_event_handler_id = (vehicle player) addEventHandler ["Fired", chicken_projectile];
					} else {
						comment "Manual fire is toggled OFF. Remove the event handler.";
						chicken_player_vehicle removeEventHandler ["Fired", chicken_veh_event_handler_id];
					};
				};
				_player_vehicle_manual_fire = isManualFire (vehicle player);
				true;
			};
			default {
				false;
			};
		};
	};
};
