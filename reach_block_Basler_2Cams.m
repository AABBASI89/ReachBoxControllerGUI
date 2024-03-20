function reach_block_Basler_2Cams()

global ARD_BOARD
global fh
global stopState
global vid_lat
global vid_lat2
global sARM
global sBASE
global pellet_position
global rest_position
global reach_position_L
global reach_position_R
global sDOOR_open_position;
global sDOOR_close_position;
global hand
global reach_vid
global reach_vid2

statusUpdate('-----------------------------') % GUI status updates
statusUpdate('Starting new set of trials...') % GUI status updates
%imaqmem(4e9) % modifies the memory limit of MATLAB

if (hand ==1)
    reach_position = reach_position_R;
end

if (hand ==2)
    reach_position = reach_position_L;
end

% get information about trial block
number_of_trials = str2double(get(fh.trials ,'String'));
Iti = str2double(get(fh.Iti,'String'));
door_open_time = str2double(get(fh.doorWait,'String'));
[y,m,d]=ymd(datetime('now'));
f_date = [num2str(y),...
    '_',num2str(m),...
    '_',num2str(d)];
f_temp=clock;
f_time=['(',num2str(f_temp(4)),'h',num2str(f_temp(5)),'m)'];

% get subject name
subJ_name = fh.NAME.String;
disp(subJ_name);

% start
trial = 1;
outcomes = [];
pelletdrops= [];
Iti_time = tic;
doorClose_callback;
time_out = 0;

path_f='F:\Reach_Videos\';
if ~isfolder(path_f)
    mkdir(path_f);
end
addpath(genpath(path_f))

% Set camera to hardware trigger mode
triggerconfig(vid_lat, 'hardware');
src = getselectedsource(vid_lat);
src.TriggerMode = 'On';

triggerconfig(vid_lat2, 'hardware');
src2 = getselectedsource(vid_lat2);
src2.TriggerMode = 'On';

while(~stopState) && (trial < number_of_trials+1)
    
    statusUpdate('--------------------------')
    statusUpdate(['TRIAL=',num2str(trial)]);
    
    if time_out == 0
        % %dispense pellet
        pellet = 0;
        
        while (pellet == 0)
            % get IR 'nopellet' baseline
            if ~exist('nopellet', 'var')
                nopellet_holder = zeros(20,1);
                for n=1:length(nopellet_holder)
                    nopellet_holder(n) = readVoltage(ARD_BOARD,'A0');
                end
                nopellet = mean(nopellet_holder);
                %disp(nopellet)
            end
            % %dispense pellet until in place
            writePosition(sBASE, pellet_position(1));
            writePosition(sARM, pellet_position(2));
            pellet_callback;
            pause(1.5); % [seconds]
            for step = 1:10
                writePosition(sBASE,pellet_position(1) + step*((rest_position(1)-pellet_position(1))/10));
                writePosition(sARM,pellet_position(2) - step*((pellet_position(2)-rest_position(2))/10));
            end
            if readVoltage(ARD_BOARD,'A0') < (nopellet-(0.2*nopellet))
                pellet = 1;
                for step = 1:30
                    
                    writePosition(sBASE,rest_position(1) + step*((reach_position(1)-rest_position(1))/30));
                    writePosition(sARM,rest_position(2) + step*((reach_position(2)-rest_position(2))/30))
                    % left handed
                end
                
                if readVoltage(ARD_BOARD,'A0') > (nopellet-(0.2*nopellet))
                    pellet = 0;
                    for step = 1:30
                        writePosition(sBASE,reach_position(1) - step*((reach_position(1)-rest_position(1))/30));
                        writePosition(sARM,reach_position(2) - step*((reach_position(2)-rest_position(2))/30));
                    end
                end
            end
        end
    end
    % wait for ITI
    while (toc(Iti_time)< Iti)
        m=floor(single(toc(Iti_time))/60);
        s=round(rem(single(toc(Iti_time)),60));
        set(fh.tick,'String',['T  ',num2str(m),'m ',num2str(s),'s']);
    end
    if trial ~= 1
        stop(vid_lat);
        stop(vid_lat2);
    end
    
    temp_trial=num2str(trial);
    
    video_name = [subJ_name,'-(',f_date,')-',f_time,'-Cam1-',num2str(trial)];
    reach_vid = VideoWriter(sprintf('%s\\%s',path_f,video_name),'Motion JPEG AVI');
    reach_vid.FrameRate=301;
    set(vid_lat,'DiskLogger',reach_vid, 'LoggingMode', 'disk');
    
    video_name2 = [subJ_name,'-(',f_date,')-',f_time,'-Cam2-',num2str(trial)];
    reach_vid2 = VideoWriter(sprintf('%s\\%s',path_f,video_name2),'Motion JPEG AVI');
    reach_vid2.FrameRate=301;
    set(vid_lat2,'DiskLogger',reach_vid2, 'LoggingMode', 'disk');
    
    % Start the cameras
    start(vid_lat);
    start(vid_lat2);
    
    %     for temp_n=1:length(temp_trial)
    %         TDTsig2_n(str2double(temp_trial(temp_n))+1);
    %         pause(0.1)
    %     end
    TDTsig_n(2);
    TDTsig2_n(1);  %START OF A TRIAL/DOOR OPEN
    trial_time = tic;
    %     pause(0.5);
    sound(1*sin(10000*(1:1500)));
    time_out = 0;
    door_close = 0;
    doorOpen_callback
    while (readVoltage(ARD_BOARD, 'A0') < (nopellet-(0.1*nopellet)) && time_out == 0)
        
        m=floor(single(toc(trial_time))/60);
        s=round(rem(single(toc(trial_time)),60));
        set(fh.tick,'String',['T  ',num2str(m),'m ',num2str(s),'s']);
        %disp("TIC MEASURE")
        %disp(toc(trial_time))
        %disp(door_open_time)
        if (toc(trial_time)> door_open_time && door_close == 0)
            door_close = 1;
            doorClose_callback
            door_closing = tic;
        end
        
        if (toc(trial_time)> door_open_time+3)
            time_out = 1;
            TDTsig_n(4);
            outcomes = [outcomes 2];
            pelletdrops= [pelletdrops NaN];
            pellet_drop = 0;
            statusUpdate('OUTCOME: 2');
        end
        
    end
    
    if time_out == 0
        TDTsig_n(1);
        %pellet_drop = toc(trial_time);
        %pelletdrops= [pelletdrops pellet_drop];
        %statusUpdate('Pellet dropped.');
    end
    
    %disp("DOOR CLOSING")
    % tic
    doorClose_callback
    % disp(['Door close time ',num2str(toc)]);
    % pause(3);
    
    if (readVoltage(ARD_BOARD,'A0') < (nopellet-(0.25*nopellet)) && time_out == 0)
        time_out = 1;
        outcomes = [outcomes 3];
        pelletdrops= [pelletdrops NaN];
        statusUpdate(sprintf('OUTCOME: 3'));
    end
    
    Iti_time = tic;
    
    if time_out == 0
        disp('Pellet removed');
        %     tmp = sprintf('%s\\%s.avi',path_f,video_name);
        %     addpath(genpath(pwd))
        %     v = VideoReader(tmp);
        %     start_index = (pellet_drop * 76)-2;
        %     video = read(v,[floor(start_index) v.numberOfFrames]);
        %     tmp = pellet_detection(video);
        %     clearvars video v
        %     outcomes = [outcomes tmp];
        %     statusUpdate(sprintf('OUTCOME: %d', tmp));
        %
        for step = 1:30
            writePosition(sBASE,reach_position(1) - step*((reach_position(1)-rest_position(1))/30));
            writePosition(sARM,reach_position(2) - step*((reach_position(2)-rest_position(2))/30));
        end
        
    end
    completed_trials = numel(find(outcomes == 0)) + numel(find(outcomes == 1));
    
    statusUpdate([sprintf('Out of %d completed trials, %d were correct',completed_trials, numel(find(outcomes == 1)))]);
    statusUpdate(['Pecentage correct...',num2str(numel(find(outcomes == 1))/completed_trials)])
    
    statusUpdate(video_name);
    statusUpdate('File saved');
    
    trial = trial + 1;
    
end

stop(vid_lat);
stop(vid_lat2);
save([path_f '\outcomes_' video_name], 'outcomes','pelletdrops');

if hand == 1
    save([path_f '\PARAMS_' video_name], 'rest_position','pellet_position','reach_position_R','sDOOR_open_position','sDOOR_close_position');
elseif hand == 2
    save([path_f '\PARAMS_' video_name], 'rest_position','pellet_position','reach_position_L','sDOOR_open_position','sDOOR_close_position');
end

end
