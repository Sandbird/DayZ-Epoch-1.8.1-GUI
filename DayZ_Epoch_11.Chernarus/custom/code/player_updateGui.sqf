private ["_display","_ctrlBloodOuter","_ctrlBlood","_ctrlBleed","_bloodVal","_ctrlFood","_ctrlThirst","_thirstVal","_foodVal","_ctrlTemp","_ctrlFoodBorder","_ctrlThirstBorder","_ctrlTempBorder","_tempVal","_array","_ctrlEar","_ctrlEye","_ctrlFracture","_visual","_audible","_uiNumber","_bloodText","_blood","_thirstLvl","_foodLvl","_tempImg","_bloodLvl","_tempLvl","_thirst","_food","_temp","_playerUID"];
disableSerialization;

_foodVal = 1 - (dayz_hunger / SleepFood);
_thirstVal = 1 - (dayz_thirst / SleepWater);
_tempVal = 1 - ((dayz_temperatur - dayz_temperaturmin)/(dayz_temperaturmax - dayz_temperaturmin));

if (uiNamespace getVariable ['DZ_displayUI', 0] == 1) exitWith {
	_array = [_foodVal,_thirstVal];
	_array
};

_display = uiNamespace getVariable 'DAYZ_GUI_display';

_ctrlBloodOuter = _display displayCtrl 1200;
_ctrlBloodOuter ctrlSetTextColor [1,1,1,1];
_ctrlBlood = _display displayCtrl 1300;
_ctrlBleed = _display displayCtrl 1303;
_bloodVal = r_player_blood / r_player_bloodTotal;
_ctrlBlood ctrlSetTextColor [(Dayz_GUI_R + (0.3 * (1-_bloodVal))),(Dayz_GUI_G * _bloodVal),(Dayz_GUI_B * _bloodVal), 1];



_ctrlFoodBorder = _display displayCtrl 1201;
_ctrlFoodBorder ctrlSetTextColor [1,1,1,1];
_ctrlFood = _display displayCtrl 1301;
_ctrlFood ctrlSetTextColor [(Dayz_GUI_R + (0.3 * (1-_foodVal))),(Dayz_GUI_G * _foodVal),(Dayz_GUI_B * _foodVal), 1];



_ctrlThirstBorder = _display displayCtrl 1202;
_ctrlThirstBorder ctrlSetTextColor [1,1,1,1];
_ctrlThirst = _display displayCtrl 1302;
_ctrlThirst ctrlSetTextColor [(Dayz_GUI_R + (0.3 * (1-_thirstVal))),(Dayz_GUI_G * _thirstVal),(Dayz_GUI_B * _thirstVal), 1];



_ctrlTempBorder = _display displayCtrl 1208;
_ctrlTempBorder ctrlSetTextColor [1,1,1,1];
_ctrlTemp = _display displayCtrl 1306;
_ctrlTemp ctrlSetTextColor [(Dayz_GUI_R + (0.3 * (1-_tempVal))), (Dayz_GUI_G * _tempVal), _tempVal, 1];


_ctrlEar = _display displayCtrl 1304;

_ctrlEye = _display displayCtrl 1305;

_ctrlFracture = _display displayCtrl 1203;


_blood = "";
_thirst = "";
_food = "";
_temp = "";
_tempImg = 0;

player setVariable["USEC_BloodQty", r_player_blood, true];

_bloodLvl = round((r_player_blood / 2) / 1000);
_thirstLvl = round(_thirstVal / 0.25);
_foodLvl = round(_foodVal / 0.25);
_tempLvl = round(dayz_temperatur);


switch true do {
	case (r_player_bloodpersec <= -50): { _uiNumber = -3 };										
	case ((r_player_bloodpersec <= -25) and (r_player_bloodpersec > -50)): { _uiNumber = -2 };	
	case ((r_player_bloodpersec < 0) and (r_player_bloodpersec > -25)): { _uiNumber = -1 };	
	case (r_player_bloodpersec == 0): { _uiNumber = 0 };										
	case ((r_player_bloodpersec > 0) and (r_player_bloodpersec < 25)): { _uiNumber = 1 };		
	case ((r_player_bloodpersec >= 25) and (r_player_bloodpersec < 50)): { _uiNumber = 2 };		
	case (r_player_bloodpersec >= 50): { _uiNumber = 3 };
	default { _uiNumber = 0 };
};

_bloodText = "\z\addons\dayz_code\gui\status\status_blood_border";

if (r_player_infected) then {
	switch true do {
		case (_uiNumber < 0): { _bloodText = _bloodText + "_down" + str(_uiNumber * -1) + "_sick_ca.paa" };
		case (_uiNumber > 0): { _bloodText = _bloodText + "_up" + str(_uiNumber) + "_sick_ca.paa" };
		default { _bloodText = _bloodText + "_sick_ca.paa" };
	};
} else {
		switch true do {
			case (_uiNumber < 0): { _bloodText = _bloodText + "_down" + str(_uiNumber * -1) + "_ca.paa" };
			case (_uiNumber > 0): { _bloodText = _bloodText + "_up" + str(_uiNumber) + "_ca.paa" };
			default { _bloodText = _bloodText + "_ca.paa" };
		};
};

_ctrlBloodOuter ctrlSetText _bloodText;

if (_bloodLvl <= 0) then {
	_blood = "\z\addons\dayz_code\gui\status\status_blood_inside_1_ca.paa";
} else {
	_blood = "\z\addons\dayz_code\gui\status\status_blood_inside_" + str(_bloodLvl) + "_ca.paa";
};

if (_thirstLvl < 0) then { _thirstLvl = 0 };
_thirst = "\z\addons\dayz_code\gui\status\status_thirst_inside_" + str(_thirstLvl) + "_ca.paa";

if (_foodLvl < 0) then { _foodLvl = 0 };
_food = "\z\addons\dayz_code\gui\status\status_food_inside_" + str(_foodLvl) + "_ca.paa";

switch true do {
	case (_tempLvl >= 36): { _tempImg = 4 };
	case (_tempLvl > 33 and _tempLvl < 36): { _tempImg = 3 };
	case (_tempLvl >= 30 and _tempLvl <= 33): { _tempImg = 2 };
	case (_tempLvl > 28 and _tempLvl < 30): { _tempImg = 1 };
	default { _tempImg = 0 };
};

_temp = "\z\addons\dayz_code\gui\status\status_temp_" + str(_tempImg) + "_ca.paa";

_ctrlBlood ctrlSetText _blood;
_ctrlThirst ctrlSetText _thirst;
_ctrlFood ctrlSetText _food;
_ctrlTemp ctrlSetText _temp;


_visual = (dayz_disVisual / 185) min 1;
if (_visual < 0.2) then {_visual = 0.2;};
_ctrlEye  ctrlSetTextColor [1, 1, 1, _visual];


_audible = (dayz_disAudial / 40) min 1;
if (_audible < 0.2) then {_audible = 0.2;};
_ctrlEar ctrlSetTextColor [1, 1, 1, _audible];


if (!(canStand player) and !(ctrlShown _ctrlFracture)) then {
	r_fracture_legs = true;
	_ctrlFracture ctrlShow true;
};


if (_bloodVal < 0.2) then { _ctrlBlood call player_guiControlFlash; };
if (_thirstVal < 0.2) then { _ctrlThirst call player_guiControlFlash; };
if (_foodVal < 0.2) then { _ctrlFood call player_guiControlFlash; };
if (_tempVal > 0.8) then { _ctrlTemp call player_guiControlFlash; } else { _ctrlTemp ctrlShow true; };
if (r_player_injured) then { _ctrlBleed call player_guiControlFlash; };


_targetControl = _display displayCtrl 1199;
_string = "";


_array = [_foodVal,_thirstVal];
_array