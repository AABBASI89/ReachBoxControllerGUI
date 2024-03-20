function repositionArm_callback (hObject,eventData)

global fh;
global sBASE;
global sARM;
global reach_position_R;
global reach_position_L;
global currentFile;

if fh.cbk1.Value == 1 || fh.cbk2.Value == 1 || fh.cbk3.Value == 1
    
    %% READ PARAMS FILE
    if fh.cbk1.Value == 1
        params_f = [fileparts(currentFile),'\paramsReachBox_1.txt'];
        A = readcell(params_f);
    elseif fh.cbk2.Value == 1
        params_f = [fileparts(currentFile),'\paramsReachBox_2.txt'];
        A = readcell(params_f);
    elseif fh.cbk3.Value == 1
        params_f = [fileparts(currentFile),'\paramsReachBox_3.txt'];
        A = readcell(params_f);
    end
    
    %% ASSIGN NEW ARM POSITION
    % Each of the relevant positions are stored in an arry because the first
    % item in the array is the position for the base motor (sBASE) and the
    % second position is for the arm (sARM).
    reach_position_R = [A{3,1} A{3,1}];
    reach_position_L = [A{4,1} A{4,1}];
    
    %% WRITE NEW ARM POSITION
    % Reach left routine
    disp('REACH LEFT POSITION')
    writePosition(sBASE,reach_position_L(1));
    writePosition(sARM,reach_position_L(2));
    
    % Pause for 2.5 seconds after reach left position
    pause(2.5) % [seconds]
    
    % Reach right routine
    disp('REACH POSITION')
    writePosition(sBASE,reach_position_R(1));
    writePosition(sARM,reach_position_R(2));
    disp('ADJUSTED REACH POSITIONS FOR BASE AND ARM MOTOR');
    
else
    msgbox('First initialize the reach boxes by checking on the appropiate box');
end

end