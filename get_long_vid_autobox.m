function get_long_vid_autobox (vidLen, frame_rate, interval)
% base_name --> file base name
% vidLen --> minutes of video
% interval --> every INTERVAL frame is saved

global fh
global stopState
global vid_back
global f_path
global f_name
global frame_times
global time

if ~exist('f_name')
    f_name='temp';
end

if ~exist('vidLen')
    vidLen=120; %sec
end

if ~exist('interval') %how many frames kep; i.e. per interval, 1 saved
    interval=30;
end

if ~exist('frame_rate') %how many frames kep; i.e. per interval, 1 saved
    frame_rate=30;
end

disp('-------------------------------------------------------');

% time lapse by only getting subset of frames
secs=round(60*vidLen); %5 hz acquisition
disp(['total vid time...',num2str(secs),' seconds'])
tot_frames=frame_rate/interval * secs;
disp(['total frames...',num2str(tot_frames)])
mov_fps=frame_rate/interval;
disp(['saved movie frame rate...',num2str(mov_fps)])

set(vid_back,'FramesPerTrigger',tot_frames);
set(vid_back,'FrameGrabInterval',interval);

% TIMER EVENTS
set(vid_back,'TimerPeriod',10);
set(vid_back,'TimerFcn',@timelapse_timer);

%Saving as a AVI file
set(vid_back,'LoggingMode','disk&memory');


avi = VideoWriter([f_path f_name]);
avi.FrameRate = mov_fps;
avi.Quality = 100;

set(vid_back,'DiskLogger',avi);

start(vid_back);
pause(1)
trigger(vid_back);
TDTsig_n(2) % 1 pulse for start
disp('start vid');
%end
global t
t=tic;

%f_total=0;

sav=tic;
set(fh.tick,'String',num2str(round((vidLen))));

while toc(sav) < (vidLen*60) && (~stopState)
    pause(5);
    statusUpdate(num2str([toc(sav)]));
    m=floor(single(toc(sav))/60);
    set(fh.tick,'String',num2str(vidLen-m));
end

TDTsig(2) 
close(avi);
stop(vid_back)

statusUpdate('VIDEO DONE')

set(fh.tick,'String', '0');

%display_avi([base_name '.avi'],10);

end

function timelapse_timer(vid,event)

global vid_back
global fh
global t
global f_path
global f_name
global frame_times
global time

[~, time] = getdata(vid_back,vid_back.FramesAvailable);
frame_times = [frame_times time'];
set(fh.tick,'String', num2str(round(toc(t)/60)));
save([f_path,f_name], 'frame_times')

statusUpdate('time triggered event');
TDTsig(1) % 1 pulse for nose

%
end



