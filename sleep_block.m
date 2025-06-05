function sleep_block()

global fh;
global stopState;
global vid_back;
global sDOOR;
global sDOOR_close_position;

writePosition(sDOOR,sDOOR_close_position);

if fh.cbk1.Value == 1
    f_path='F:\Sleep_Videos\';
else
    bfr = strsplit(currentFile,'\');
    f_path = [bfr{1},'\',bfr{2},'\',bfr{3},'\Desktop\Sleep_Vids'];
    if ~isfolder(path_f)
        mkdir(f_path);
    end
    addpath(genpath(f_path));
end

% Test sleep vid frame rate
set(vid_back,'loggingmode','memory');
set(vid_back,'FramesPerTrigger',inf);
set(vid_back,'FrameGrabInterval',1);

start(vid_back);
pause(0.1);
trigger(vid_back);
test = tic;
while toc(test) < 5
end
stop(vid_back)
[~,time,~] = getdata(vid_back, vid_back.FramesAvailable);
tmp_1 = find(time==min(time(time>1)));
tmp_2 = find(time==min(time(time>3)));
frame_rate = (tmp_2-tmp_1)/2;
statusUpdate(['SLEEP CAMERA frame rate: ' num2str(frame_rate)])
min_sleep = str2num(get(fh.sleep ,'String'));

% get subject name
subJ_name = fh.NAME.String;
disp(subJ_name);

% start
[y,m,d]=ymd(datetime('now'));
f_date = [num2str(y),...
    '_',num2str(m),...
    '_',num2str(d)];
f_temp=clock;
f_time=['(',num2str(f_temp(4)),'h',num2str(f_temp(5)),'m)'];

frame_times = [];
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
