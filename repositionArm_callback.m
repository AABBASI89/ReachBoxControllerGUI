function repositionArm_callback (hObject,eventData)
% Author - Aamir Abbasi
global fh;
global reach_position_R;
global reach_position_L;
global currentFile;
global subF;

if fh.cbk1.Value == 1 || fh.cbk2.Value == 1 || fh.cbk3.Value == 1
    
    %% READ PARAMS FILE
    if fh.cbk1.Value == 1
        params_f = [fileparts(currentFile),'\paramsReachBox_1.txt'];
        fid = fopen(params_f);
        A = textscan(fid,'%s %s %s');
        fclose(fid);
    elseif fh.cbk2.Value == 1
        params_f = [fileparts(currentFile),'\paramsReachBox_2.txt'];
        fid = fopen(params_f);
        A = textscan(fid,'%s %s %s');
        fclose(fid);
    elseif fh.cbk3.Value == 1
        params_f = [fileparts(currentFile),'\paramsReachBox_3.txt'];
        fid = fopen(params_f);
        A = textscan(fid,'%s %s %s');
        fclose(fid);
    end
    
    %% READ CURRENT POSITION AND DISPLAY ON A NEW GUI WINDOW
    % Each of the relevant positions are stored in an arry because the first
    % item in the array is the position for the base motor (sBASE) and the
    % second position is for the arm (sARM).
    reach_position_R = [str2double(A{1}{3}) str2double(A{2}{3})];
    reach_position_L = [str2double(A{1}{4}) str2double(A{2}{4})];
    
    %% LAUNCH A NEW UIFIGURE FOR ADJUSTING PELLET MOTOR POSITIONS IN REAL-TIME
    % FIGURE WINDOW
    fig_pos = [1000 150 200 200];
    subF.fig = figure('Position',fig_pos,...
        'MenuBar','none',...
        'NumberTitle','off',...
        'CloseRequestFcn',@fig_close,...
        'Name','ADJUST PALLET ARM POSITION');
    
    % TEXT FIELD FOR RIGHT HAND (RH)
    subF.tRH = uicontrol(subF.fig,'Style','text',...
    'String','RH',...
    'Position',[10 110 30 40]);

    % TEXT FIELD FOR LEFT HAND (LH)
    subF.tLH = uicontrol(subF.fig,'Style','text',...
    'String','LH',...
    'Position',[10 50 30 40]);

    % TEXT FIELD FOR BASE MOTOR (sBASE)
    subF.tsBase = uicontrol(subF.fig,'Style','text',...
    'String','sBASE',...
    'Position',[30 150 60 30]);

    % TEXT FIELD FOR ARM MOTOR (sARM)
    subF.tsARM = uicontrol(subF.fig,'Style','text',...
    'String','sARM',...
    'Position',[110 150 60 30]);

    % EDITABLE TEXT FIELD DISPLAYING CURRENT MOTOR POSITIONS
    % sBASE RH
    subF.editB_RH = uicontrol(subF.fig,'Style','edit',...
        'String',num2str(reach_position_R(1)),...
        'Position',[40 130 30 30]);
    % sBASE LH
    subF.editB_LH = uicontrol(subF.fig,'Style','edit',...
        'String',num2str(reach_position_L(1)),...
        'Position',[40 70 30 30]);    
    
    % sARM RH
    subF.editA_RH = uicontrol(subF.fig,'Style','edit',...
        'String',num2str(reach_position_R(2)),...
        'Position',[120 130 30 30]);
    
    % sARM LH
    subF.editA_LH = uicontrol(subF.fig,'Style','edit',...
        'String',num2str(reach_position_L(2)),...
        'Position',[120 70 30 30]);      
    
    % PUSH BUTTONS TO INCREMENT/DECREMENT MOTOR POSITIONS
    % sBASE RH +
    subF.incRHsBase = uicontrol(subF.fig,...
        'Style','pushbutton',...
        'String','+',...
        'Position',[70 130 20 20],...
        'Callback',@increment_RH_sBASE_callback);    
    
    % sBASE RH - 
    subF.decRHsBase = uicontrol(subF.fig,...
        'Style','pushbutton',...
        'String','-',...
        'Position',[70 110 20 20],...
        'Callback',@decrement_RH_sBASE_callback);     
    
    % sBASE LH +
    subF.incLHsBase = uicontrol(subF.fig,...
        'Style','pushbutton',...
        'String','+',...
        'Position',[70 70 20 20],...
        'Callback',@increment_LH_sBASE_callback);      
    
    % sBASE LH -
    subF.decLHsBase = uicontrol(subF.fig,...
        'Style','pushbutton',...
        'String','-',...
        'Position',[70 50 20 20],...
        'Callback',@decrement_LH_sBASE_callback);       
    
    % sARM RH +
    subF.incRHsArm = uicontrol(subF.fig,...
        'Style','pushbutton',...
        'String','+',...
        'Position',[150 130 20 20],...
        'Callback',@increment_RH_sARM_callback);      
    
    % sARM RH -
    subF.decRHsArm = uicontrol(subF.fig,...
        'Style','pushbutton',...
        'String','-',...
        'Position',[150 110 20 20],...
        'Callback',@decrement_RH_sARM_callback);    
    
    % sARM LH +
    subF.incLHsArm = uicontrol(subF.fig,...
        'Style','pushbutton',...
        'String','+',...
        'Position',[150 70 20 20],...
        'Callback',@increment_LH_sARM_callback);     
    
    % sARM LH -
    subF.decLHsArm = uicontrol(subF.fig,...
        'Style','pushbutton',...
        'String','-',...
        'Position',[150 50 20 20],...
        'Callback',@decrement_LH_sARM_callback);     
    
    % UPDATE FINAL MOTOR POSITIONS BUTTON 
    subF.update = uicontrol(subF.fig,...
        'Style','pushbutton',...
        'String','UPDATE',...
        'Position',[102 10 45 25],...
        'Callback',@updateArmPos_callback);
            
else
    msgbox('First initialize the reach boxes by checking on the appropiate box');
end

end