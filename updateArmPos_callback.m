function updateArmPos_callback (hObject,eventData)
% Author - Aamir Abbasi

global sBASE;
global sARM;
global reach_position_R;
global reach_position_L;
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

end