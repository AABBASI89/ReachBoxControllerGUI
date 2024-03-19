%% Author: Shakthi Visagan
%% getting Reach box arduino board
% Try not to run this code more than once on the same board

% clear all has to be run to clear any previous remaining 
% arduino boards
clear all;
% getting list of COM ports
serial_port_list = seriallist;
disp("List of available COM ports: ")
% displaying list of COM ports for the user
disp(serial_port_list)
% getting the COM port
COM_port_string = serial_port_list(6);
% creating and assigning arduino object
global ARD_BOARD
ARD_BOARD = arduino(COM_port_string,'Uno');
 
% The arduino instantiation method doesn't have to be this explicit
% because Windows will automatically recognize the offical Arduino board.
% ARD_BOARD = arduino() will also work.

% In the case you keep getting the error where it refuses to communicate
% with a COM port, what you'll have to do is: go to the device manager,
% disable the Arduino device on the correct COM port, run this code
% section, see that the code fails for a different error this time (empty
% COM port)and then re-enable the device, and then run this code section 
% again.

% If connecting the board to a new COM port for the first time, 
% the server code on the board will have to be updated.

%% reading and writing door and base motor position
% assigning pellet arm 
p_arm = servo(ARD_BOARD,'D8');

% Moving pellet arm
writePosition(p_arm,0.2);

% assigning motor base 
arm_base = servo(ARD_BOARD,'D9');

% moving motor base
writePosition(arm_base,1)

%%
% In general, avoid making while loops run off of conditions that are
% permanently true.

% collect data every 1e-3 seconds or every 1 ms
time_resolution_of_collection = 1e-3; % [seconds]
% want to collect data for 20 seconds
time_of_collection = 20; % [seconds]
% convert this into number of time steps
num_time_steps = time_of_collection/time_resolution_of_collection;

% initial voltage collection
% an array of increasing size that will update in real time
voltages = 0;

h = animatedline;
% view a grid on our graph
grid on;
% label the x-axis with time in miliseconds
xlabel('Time [ms]')
% label the y-axis with voltage
ylabel('Voltage [V]');
% title the graph
title('Real-Time Voltage from IR sensor');
% ylim([0.05,1]);

while length(voltages) < num_time_steps     
    % collect the voltage from the arduino sensor
    value = readVoltage(ARD_BOARD,'A1');
    disp(value)
    % update our collecting array by adding the collected value
    voltages = [voltages value];
    addpoints(h, length(voltages), voltages(end));
    % update the graph in real time
    drawnow
    % pause for 1 ms before the next voltage read
    pause(1e-3);
end


