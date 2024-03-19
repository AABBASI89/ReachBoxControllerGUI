function reach_block()
%SHAKTHI VISAGAN
    global ARD_BOARD
    global fh
    global stopState
    global vid_lat
    global sARM
    global sBASE
    global pellet_position
    global rest_position
    global reach_position_L
    global reach_position_R
    global hand
    
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
% f_date= [num2str(year(date)),... % obsolete code that does not work
%     '_',num2str(month(date)),... % see line 34-37 instead
%     '_',num2str(day(date))];
[y,m,d]=ymd(datetime('now'));
f_date = [num2str(y),...
    '_',num2str(m),...
    '_',num2str(d)];
f_temp=clock;
f_time=['(',num2str(f_temp(4)),'h',num2str(f_temp(5)),'m)'];

% get subject name
f = figure; set(f,'Position',[686   183   300   90]);
set(f,'Menubar','none'); set(f,'NumberTitle','off');
set(f,'Name','Type in valid subject name...')
h = uicontrol('Position',[20 20 250 40],...
    'Style','edit',...
    'Callback','save_vid=0;uiresume(gcbf)');
set(h,'String','Txxx');
set(h,'FontSize',20);
uiwait(gcf);
temp_filename=get(h,'String');
close(f);

set(fh.NAME,'String',temp_filename)
pause(0.1);
subJ_name=get(fh.NAME,'String')

% wait for user to start
f = figure; set(gcf,'Position',[1100  20  521 209]);
h = uicontrol('Position',[100 70 300 120],'String','Continue',...
    'Callback','uiresume(gcbf)');
set(h,'ForegroundColor',[1 1 1],'BackgroundColor',[1 0 0], 'FontSize',20)
uiwait(gcf);
close(f);

trial = 1;
outcomes = [];
pelletdrops= [];
Iti_time = tic;
doorClose_callback;
time_out = 0;

addpath(genpath(pwd))
path_f='C:\Users\FleischerP\Desktop\Reach_Vids';
addpath(genpath(path_f))

while(~stopState) && (trial < number_of_trials+1)
    
    statusUpdate('--------------------------')
    statusUpdate(['TRIAL=',num2str(trial)]);
    
    video_name = [subJ_name,'-(',f_date,')-',f_time,'-',num2str(trial)];
    reach_vid = VideoWriter(sprintf('%s\\%s',path_f,video_name),'Motion JPEG AVI');%
    reach_vid.FrameRate=30;
    stop(vid_lat);
    set(vid_lat,'DiskLogger',reach_vid, 'LoggingMode', 'disk');
    start(vid_lat);  
    tic
    trigger(vid_lat);
    pause(2);
    stop(vid_lat);
    toc
    
    if time_out == 0
        % dispense pellet
        pellet = 0;

        while (pellet == 0)
            % get IR 'nopellet' baseline
            if ~exist('nopellet', 'var')
                nopellet_holder = zeros(20,1);
                for n=1:length(nopellet_holder)
                        nopellet_holder(n) = readVoltage(ARD_BOARD,'A1');
                end
                nopellet = mean(nopellet_holder);
                disp(nopellet)
            end
            % dispense pellet until in place
            writePosition(sBASE, pellet_position(1));
            writePosition(sARM, pellet_position(2));  
            pellet_callback;
            pause(1.5); % [seconds]
            for step = 1:10
                writePosition(sBASE,pellet_position(1) + step*((rest_position(1)-pellet_position(1))/10));
                writePosition(sARM,pellet_position(2) - step*((pellet_position(2)-rest_position(2))/10));
            end
            if readVoltage(ARD_BOARD,'A1') < (nopellet-(0.2*nopellet))
                pellet = 1;
                for step = 1:30
                   
                    writePosition(sBASE,rest_position(1) + step*((reach_position(1)-rest_position(1))/30)); 
                    writePosition(sARM,rest_position(2) + step*((reach_position(2)-rest_position(2))/30))
                    % left handed
                end
                
                if readVoltage(ARD_BOARD,'A1') > (nopellet-(0.2*nopellet))
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
    while (toc(Iti_time)<Iti)
        m=floor(single(toc(Iti_time))/60);
        s=round(rem(single(toc(Iti_time)),60));
        set(fh.tick,'String',['T  ',num2str(m),'m ',num2str(s),'s']);
    end
    
    temp_trial=num2str(trial);
    
    for temp_n=1:length(temp_trial)
        TDTsig2_n(str2double(temp_trial(temp_n))+1);
        pause(0.1)  
    end
    start(vid_lat);
    trigger(vid_lat);
    TDTsig_n(2);  %START OF A TRIAL/DOOR OPEN
    trial_time = tic;
    pause(0.5);
    sound(1*sin(10000*(1:1500)));        
    time_out = 0;
    door_close = 0;
    doorOpen_callback    
while (readVoltage(ARD_BOARD, 'A1') < (nopellet-(0.1*nopellet)) && time_out == 0)

    m=floor(single(toc(trial_time))/60);
    s=round(rem(single(toc(trial_time)),60));
    set(fh.tick,'String',['T  ',num2str(m),'m ',num2str(s),'s']);
    disp("TIC MEASURE")
    disp(toc(trial_time))
    disp(door_open_time)
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
    pellet_drop = toc(trial_time);
    pelletdrops= [pelletdrops pellet_drop];
    statusUpdate('Pellet dropped.');
end

disp("DOOR CLOSING")
doorClose_callback
pause(3);
stop(vid_lat);
    
    if (readVoltage(ARD_BOARD,'A1') < (nopellet-(0.02*nopellet)) && time_out == 0)
        time_out = 1;
        outcomes = [outcomes 3];
        pelletdrops= [pelletdrops NaN];
        statusUpdate(sprintf('OUTCOME: 3'));
    end
    
    Iti_time = tic;   
    
    if time_out == 0
        tmp = sprintf('%s\\%s.avi',path_f,video_name);
        addpath(genpath(pwd))
        v = VideoReader(tmp);
        start_index = (pellet_drop * 75)-4;
        video = read(v,[floor(start_index) v.numberOfFrames]);
        tmp = pellet_detection(video);
        clearvars video v
        outcomes = [outcomes tmp];
        statusUpdate(sprintf('OUTCOME: %d', tmp));
    
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
    
save([path_f '\outcomes_' video_name], 'outcomes','pelletdrops'); 

end

%  
%       
%             % display video after each trial/ PELLET ANALYSIS
%             subplot(fh.ax2)
%             im_drop_t=find(t_lat>t_video_drop);
%             disp(im_drop_t(1)-1);
%             imshow(im_lat(:,:,:,im_drop_t(1)-1));
%             title([num2str(vid_f_lat)]);
%             temp_o=video_pellet(im_lat,1,t_video_drop,t_lat,1);
%             if temp_o > -0.5
%                 outcomes=[outcomes temp_o]
%                 hold_outcomes=outcomes;
%             end
%             
%             statusUpdate(['------------------------------']);
%             temp_o=find(outcomes>-0.5);
%             p_correct=sum(outcomes(temp_o))/length(temp_o);
%             attempts=length(temp_o)
%             statusUpdate(['Pecentage correct...',num2str(p_correct*100)])
%             statusUpdate(['Actual attempts...',num2str(attempts)])
% 
%         else
%             % FOR TIMEOUTS
%             temp_o=0;
%             t_video_drop=15;
%             outcomes=[outcomes temp_o];
%             temp_o=find(outcomes>-0.5);
%             p_correct=sum(outcomes(temp_o))/length(temp_o);
%             attempts=length(temp_o);
%             statusUpdate(['Pecentage correct...',num2str(p_correct*100)])
%             statusUpdate(['Actual attempts...',num2str(attempts)])
%         end
%         
%         if temp_o > -0.5 %save and advance
% 
%             path_f='C:\Users\TDT3\Desktop\Extended_reach_trials\';
%             f_name=[subJ_name,'-(',f_date,')-',f_time,'-',num2str(trial)];
%             f_name2=[f_name,'.mat'];
%             statusUpdate(f_name2);
%             save([path_f f_name2],'im_lat','t_lat','t_video_drop','temp_o','outcomes','hold_outcomes');
%             statusUpdate('File saved');
%             
%             real_trial=real_trial+1;
%         end
% 
%         %dispenses pellet and NO check for drop
%         if PELLET_DROP==1  || PELLET_DROP==3
%             ARD_BOARD.digitalWrite(8,1)
%             pause(0.05);
%             ARD_BOARD.digitalWrite(8,0);  % real dispense
%         else
%             %dispense3(2); %only make noise
%         end
%         
%         m=floor(single(toc(TTIME))/60);
%         s=round(rem(single(toc(TTIME)),60));
%         set(fh.trial_time,'String',['T  ',num2str(m),'m ',num2str(s),'s']);
%            
%         m=floor(single(toc(TTIME))/60);
%         s=round(rem(single(toc(TTIME)),60));
%         set(fh.trial_time,'String',['T  ',num2str(m),'m ',num2str(s),'s']);
%         trial=trial+1;
% 
%         while (toc(INTERVAL_TIME) < startWait)
%         	set(fh.tick,'String',num2str(floor(toc(INTERVAL_TIME)))); 
%             drawnow;
%         end   
%         
%     end
% end
% 
% statusUpdate('Stopped and servos detached...')
% 
% set(fh.pelLoc,'Enable','On')
% set(fh.start,'Value',0)
% stopState = 1;
% set(fh.start,'String','START')
