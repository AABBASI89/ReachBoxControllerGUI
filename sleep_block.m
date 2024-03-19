function sleep_block()

global fh
global stopState
global vid_back
global f_name
global f_path

% imaqmem(4e9)

f_path='C:\Users\DanielsenN\Desktop\NewBoxScripts\START_shakthi_copy\Sleep_videos\';

% Test sleep vid frame rate
set(vid_back,'loggingmode','memory');
set(vid_back,'FramesPerTrigger',inf);
set(vid_back,'FrameGrabInterval',1);
sleep_vid = VideoWriter('test_file');

start(vid_back);
pause(1);
trigger(vid_back);
test = tic;
while toc(test) < 3.1
end
stop(vid_back)
[~,time,~] = getdata(vid_back, vid_back.FramesAvailable);
tmp_1 = find(time==min(time(time>1)));
tmp_2 = find(time==min(time(time>3)));
frame_rate = (tmp_2-tmp_1)/2;
statusUpdate(['SLEEP CAMERA frame rate: ' num2str(frame_rate)])

min_sleep = str2num(get(fh.sleep ,'String'));

f = figure; set(f,'Position',[686   183   300   90]);
set(f,'Menubar','none'); set(f,'NumberTitle','off');
set(f,'Name','Type in valid subject name...')
h = uicontrol('Position',[20 20 250 40],'Style','edit',...
    'Callback','save_vid=0;uiresume(gcbf)');
set(h,'String','Txxx');
set(h,'FontSize',20);
uiwait(gcf);
temp_filename=get(h,'String');
close(f);
set(fh.NAME,'String',temp_filename)
pause(0.1);
subJ_name=get(fh.NAME,'String')

f = figure; set(gcf,'Position',[1329  20  521 209]);
h = uicontrol('Position',[100 70 300 120],'String','Continue',...
    'Callback','uiresume(gcbf)');
set(h,'ForegroundColor',[1 1 1],'BackgroundColor',[1 0 0], 'FontSize',20)
uiwait(gcf);
close(f);

% f_date= [num2str(year(date)),'_',num2str(month(date)),'_',num2str(day(date))];
[y,m,d]=ymd(datetime('now'));
f_date = [num2str(y),...
    '_',num2str(m),...
    '_',num2str(d)];
f_temp=clock;
f_time=['(',num2str(f_temp(4)),'h',num2str(f_temp(5)),'m)'];

clearvars frame_times t time
global frame_times
global time
frame_times = [];
time = [];

    while (~stopState)

        f_name=[subJ_name,'-(',f_date,')-',f_time,'-SPONT'];
        statusUpdate(f_name);
        statusUpdate(['Start ',num2str(min_sleep),' min spont. period']);

        get_long_vid_autobox(min_sleep,frame_rate,frame_rate);

        stopState = 1;

    end

    [~, time] = getdata(vid_back,vid_back.FramesAvailable);
    flushdata(vid_back);
    frame_times = [frame_times time'];
    save([f_path,f_name], 'frame_times')

end






