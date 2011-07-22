function solenoidDiff = solenoidDiff(t, state)
    FILL_FACTOR = 0.9934; %this is the circle fill factor (not nessecary at this point)

    AWG = 18;

    CLADDING_THICKNESS = 0.0;
    CORE_DIAMETER = 1.27e-4 * (92 ^ ((36.0 - AWG) / 39.0));
    WIRE_DIAMETER = CORE_DIAMETER + 2*CLADDING_THICKNESS;
    CORE_AREA = (pi*CORE_DIAMETER*CORE_DIAMETER/4.0);

    WINDING_HEIGHT = 1e-2; %meters
    SOLENOID_WIDTH = 5e-2; % meters
    SOLENOID_HEIGHT = 5e-3; % meters
    SOLENOID_LENGTH = 5e-2; % in meters
    WINDING_AREA = SOLENOID_LENGTH * WINDING_HEIGHT;
    TURNS = floor(WINDING_AREA/(2*sqrt(2.5)*WIRE_DIAMETER*WIRE_DIAMETER))*4;
    FILL_EFFICENCY = TURNS * CORE_AREA / WINDING_AREA;

    %TODO: this needs to take into account the extra wire as the windings get thicker
    WINDING_RESISTIVITY = 1.68e-8; % ohm meters
    TURN_RESISTANCE = WINDING_RESISTIVITY*(SOLENOID_LENGTH + SOLENOID_HEIGHT + 2*WINDING_HEIGHT)/CORE_AREA;
    SOLENOID_RESISTANCE = TURN_RESISTANCE * TURNS; % ohms

    SOLENOID_AREA = SOLENOID_HEIGHT * SOLENOID_WIDTH;  % in meters squared

    %Size of the capacitor storing the kicker charge
    CAPACITOR_SIZE = 5.4e-3; % in farads
    CAPACITOR_INITIAL_CHARGE = 240; % in volts

    MU_NOT = 1.25663706e-6;
    MU_R_IRON = 5000;
    MU_R_STEEL = 300;
    MU_R_CORE = MU_R_STEEL;

    CORE_DENSITY = 7870; % kg / meters cubed
    PLUNGER_MASS = SOLENOID_AREA * SOLENOID_LENGTH * CORE_DENSITY;

    SOLENOID_CONSTANT = MU_NOT * TURNS * TURNS * SOLENOID_AREA / (SOLENOID_LENGTH * SOLENOID_LENGTH);

    ALPHA = 1;

    velocity = state(1);
    position = state(2);
    current = state(3);
    voltage = state(4);
    
    L = (TURNS ^ 2 * MU_NOT * SOLENOID_AREA * MU_R_CORE) / ((MU_R_CORE + 1) * SOLENOID_LENGTH - (MU_R_CORE - 1) * position);
    dLdx = (TURNS ^ 2 * MU_NOT * SOLENOID_AREA * MU_R_CORE * (MU_R_CORE - 1)) / (((MU_R_CORE + 1) * SOLENOID_LENGTH - (MU_R_CORE - 1) * position) ^ 2);
    
    dVelocity = (1 / (2 * PLUNGER_MASS)) * dLdx * current ^ 2;
    dPosition = velocity;
    dCurrent = (ALPHA * voltage - dLdx * velocity * current - current * SOLENOID_RESISTANCE) / L;
    dVoltage = -current / CAPACITOR_SIZE * ALPHA;
    
    solenoidDiff = [dVelocity; dPosition; dCurrent; dVoltage];
end
