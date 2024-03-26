function updateArmPos_callback (hObject,eventData)
% Author - Aamir Abbasi

global sBASE;
global sARM;
global rest_position;
global pellet_position;
global reach_position_R;
global reach_position_L;
global sDOOR_open_position;
global sDOOR_close_position;
global hand;
global subF;
global fh;
global currentFile;

%% ASSIGN NEW ARM POSITION
% Each of the relevant positions are stored in an arry because the first
% item in the array is the position for the base motor (sBASE) and the
% second position is for the arm (sARM).
reach_position_R = [str2num(subF.editB_RH.String) str2num(subF.editA_RH.String)];
reach_position_L = [str2num(subF.editB_LH.String) str2num(subF.editA_LH.String)];

%% UPDATE THE MOTOR POSITION
% Reach left routine
if hand == 2
    disp('REACH LEFT POSITION')
    writePosition(sBASE,reach_position_L(1));
    writePosition(sARM,reach_position_L(2));
    pause(2.5);
    disp('ADJUSTED REACH POSITIONS FOR LEFT HAND');
end

if hand == 1
    % Reach right routine
    disp('REACH RIGHT POSITION')
    writePosition(sBASE,reach_position_R(1));
    writePosition(sARM,reach_position_R(2));
    pause(2.5);
    disp('ADJUSTED REACH POSITIONS FOR RIGHT HAND');
end

%% UPDATE PARAMS FILE
% Define the position identifiers
positions = {
    'Rest_position';
    'Pellet_position';
    'Reach_position_R';
    'Reach_position_L';
    'sDoor_open_position';
    'sDoor_close_position'
    };

% Define the data
data = [
    rest_position(1) rest_position(2);        % Rest_position
    pellet_position(1) pellet_position(2);    % Pellet_position
    reach_position_R(1) reach_position_R(2);  % Reach_position_R
    reach_position_L(1) reach_position_L(2);  % Reach_position_L
    sDOOR_open_position NaN;                  % sDoor_open_position (assuming NaN for missing value)
    sDOOR_close_position NaN                  % sDoor_close_position (assuming NaN for missing value)
    ];

disp('Data has been written to the file successfully.');
if fh.cbk1.Value == 1
    
    params_f = [fileparts(currentFile),'\paramsReachBox_1.txt'];
    fileID = fopen(params_f, 'w');
    for i = 1:size(data, 1)
        if isnan(data(i, 2))
            fprintf(fileID, '%.2f\t\t\t%s\n', data(i, 1), positions{i});
        else
            fprintf(fileID, '%.2f %.2f\t\t%s\n', data(i, :), positions{i});
        end
    end
    fclose(fileID);

elseif fh.cbk2.Value == 1
    
    params_f = [fileparts(currentFile),'\paramsReachBox_2.txt'];
    fileID = fopen(params_f, 'w');
    for i = 1:size(data, 1)
        if isnan(data(i, 2))
            fprintf(fileID, '%.2f\t\t\t%s\n', data(i, 1), positions{i});
        else
            fprintf(fileID, '%.2f %.2f\t\t%s\n', data(i, :), positions{i});
        end
    end
    fclose(fileID);
    
elseif fh.cbk3.Value == 1
    
    params_f = [fileparts(currentFile),'\paramsReachBox_3.txt'];
    fileID = fopen(params_f, 'w');
    for i = 1:size(data, 1)
        if isnan(data(i, 2))
            fprintf(fileID, '%.2f\t\t\t%s\n', data(i, 1), positions{i});
        else
            fprintf(fileID, '%.2f %.2f\t\t%s\n', data(i, :), positions{i});
        end
    end
    fclose(fileID);
    
end

end