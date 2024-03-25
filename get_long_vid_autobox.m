function get_long_vid_autobox (vidLen, frame_rate, interval)
% base_name --> file base name
% vidLen --> minutes of video
% interval --> every INTERVAL frame is saved

global stopState;
global vid_back;
global f_path;
global f_name;

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

sav=tic;
while toc(sav) < (vidLen*60) && (~stopState)
    pause(5);
    statusUpdate(num2str([toc(sav)]));
    m=floor(single(toc(sav))/60);
end
TDTsig(2) 
close(avi);
stop(vid_back)
statusUpdate('VIDEO DONE')

end

function timelapse_timer(vid,event)

global vid_back;
global f_path;
global f_name;
global frame_times;
global time;

[~, time] = getdata(vid_back,vid_back.FramesAvailable);
frame_times = [frame_times time'];
save([f_path,f_name], 'frame_times')
statusUpdate('time triggered event');
TDTsig(1) % 1 pulse for nose

end



