function reachBox1_callback(hObject,eventdata)
% Reach Box 1

clear global ARD_BOARD global sBase global sArm;
clear global rest_position;
clear global pellet_position;
clear global reach_position_R;
clear global reach_position_L;
clear global sDOOR;
clear global sDOOR_open_position;
clear global sDOOR_close_position;
clear global vid_back;
clear vid_back_src;
clear global vid_lat;
clear vid_lat_src;

global fh;
global ARD_BOARD;
global sBASE;
global sARM;
global rest_position;
global pellet_position;
global reach_position_R;
global reach_position_L;
global sDOOR;
global sDOOR_open_position_L;
global sDOOR_open_position_R;
global sDOOR_close_position;
global vid_back;
global vid_lat;
global vid_lat2;
global currentFile;

if fh.cbk1.Value == 1
    answer = questdlg('Are sure you are using Reach Box 1?','Yes','No');
    if strcmp(answer,'Yes') == 1
        disp('INITIALIZATION OF REACH BOX 1');
        
        %% READ PARAMS FILE
        params_f = [fileparts(currentFile),'\paramsReachBox_1.txt'];
        fid = fopen(params_f);
        A = textscan(fid,'%s %s %s');
        fclose(fid);
        
        % Assign motor positions
        rest_position = [str2double(A{1}{1}) str2double(A{2}{1})]; 
        pellet_position = [str2double(A{1}{2}) str2double(A{2}{2})];
        
        % Each of the relevant positions are stored in an arry because the first
        % item in the array is the position for the base motor (sBASE) and the
        % second position is for the arm (sARM).
        reach_position_R = [str2double(A{1}{3}) str2double(A{2}{3})];
        reach_position_L = [str2double(A{1}{4}) str2double(A{2}{4})];
        
        sDOOR_open_position_L = str2double(A{1}{5});
        sDOOR_open_position_R = str2double(A{1}{6});
        sDOOR_close_position = str2double(A{1}{7});    
        
        %% START INITIALIZATION
        
        % Getting Arduino (ARD_BOARD)
        try % try to get the Arduino board automatically\
            ARD_BOARD = arduino;
        catch % try to get the Arduino board explicitly
            % getting list of COM ports
            serial_port_list = seriallist;
            if ~isempty (serial_port_list)
                % getting the COM port
                COM_port_string = serial_port_list(2);
                % creating and assigning arduino object
                ARD_BOARD = arduino(COM_port_string,'Uno');
            else
                err_dlg = errordlg('Make sure that Arduino is connected properly to the computer. Check connections or Turn no USB Hub before hitting OK');
                waitfor(err_dlg);
                pause(2.5); %seconds
            end
        end
        % don't need the list of serial ports
        clear serial_port_list
        % don't need the COM port string
        clear COM_port_string
        disp('ARDUINO INITIALIZED')
        
        %% Writing to Digital Pins 3 and 4
        % TDT Out Digital Pins I/O
        % neighboring pins in 2,3,4,5
        writeDigitalPin(ARD_BOARD, 'D3', 0);
        writeDigitalPin(ARD_BOARD, 'D4', 0);
        writeDigitalPin(ARD_BOARD, 'D2', 0);
        writeDigitalPin(ARD_BOARD, 'D5', 0);
        writeDigitalPin(ARD_BOARD, 'D12', 0);
        writeDigitalPin(ARD_BOARD, 'D13', 0);
        disp('WRITING TO TDT DIGITAL PINS AND GROUNDING');
        
        %% Getting Base (sBASE) and Arm (sARM) Servos
        % BASE AND ARM SERVOS
        % creating and assigning servo Base object
        sBASE = servo(ARD_BOARD, 'D9', 'MinPulseDuration', 700*10^-6,'MaxPulseDuration', 2300*10^-6);
        % creating and assigning servo Arm object
        sARM = servo(ARD_BOARD, 'D8', 'MinPulseDuration', 700*10^-6,'MaxPulseDuration', 2300*10^-6);
        disp('SERVO FOR BASE MOTOR AND ARM INITIALIZED')
        
        %% Getting Rest and Pellet positions
        % Rest routine+
        disp('REST POSITION')
        writePosition(sBASE,rest_position(1));
        writePosition(sARM,rest_position(2));
        pause(2.5) % [seconds]
        
        % Pellet routine
        disp('PELLET POSITION')
        writePosition(sBASE,pellet_position(1));
        writePosition(sARM,pellet_position(2));
        disp('PELLET AND REST POSITIONS FOR BASE AND MOTOR AND ARM INITIALIZED')
        
        %% Getting Reach positions for right and left-handed rats      
        % Reach left routine
        disp('REACH LEFT POSITION')
        writePosition(sBASE,reach_position_L(1));
        writePosition(sARM,reach_position_L(2));
        
        % Pause for 2.5 seconds after reach left position
        pause(2.5) % [seconds]
        
        % Reach right routine
        disp('REACH RIGHT POSITION')
        writePosition(sBASE,reach_position_R(1));
        writePosition(sARM,reach_position_R(2));
        disp('HANDED REACH POSITIONS FOR BASE AND MOTOR AND ARM INITIALIZED')
        
        %% Getting Door (sDOOR) and Positions
        % DOOR SERVO
        sDOOR = servo(ARD_BOARD, 'D10', 'MinPulseDuration', 700*10^-6,...
            'MaxPulseDuration', 2300*10^-6);
        
        disp('DOOR CLOSING')
        writePosition(sDOOR,sDOOR_close_position);
        
        % Pause for 2.5 seconds after resting position
        pause(2.5) % [seconds]
        
        disp('DOOR OPENING')
        if hand == 2
            writePosition(sDOOR,sDOOR_open_position_L);
        end
        if hand == 1
            writePosition(sDOOR,sDOOR_open_position_R);
        end        
        
        %% Getting Monitor Camera
        %MONITOR CAMERA
        vid_back = videoinput('winvideo',1);
        triggerconfig(vid_back,'manual');
        set(vid_back,'ReturnedColorSpace','rgb');
        set(vid_back,'FramesPerTrigger',inf);
        set(vid_back,'loggingmode','memory');
        vid_back_src = getselectedsource(vid_back);
        vid_back_src.WhiteBalanceMode = 'auto';
        
        %% Getting Reach Camera
        % REACH CAMERA 1
        if hand == 2
            vid_lat = videoinput('gentl', 1);
            vid_lat.FramesPerTrigger = Inf;
            % % triggerconfig(vid_lat, 'hardware');
            % % src = getselectedsource(vid_lat);
            % % src.AcquisitionFrameRate = 90; %76;
            % % src.AcquisitionFrameRateEnable = 'True';
            % % src.LineSelector = 'Line1';
            % % src.LineInverter = 'False';
            % % src.TriggerMode = 'On';
        end
        
        % REACH CAMERA 2
        if hand == 1
            vid_lat2 = videoinput('gentl', 2);
            vid_lat2.FramesPerTrigger = Inf;
        end
        
        %% Finishing Camera setup and Testing
        disp('CAMERAS INITIALIZED');
        
    else
        fh.cbk1.Value = 0;
    end
end

end