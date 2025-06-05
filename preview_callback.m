function preview_callback(hObject,eventdata)

global fh;
global vid_back;
global vid_lat;
global vid_lat2;
global hand;

if fh.cbk1.Value == 1
    src = getselectedsource(vid_lat);
    src.TriggerMode = 'Off';
    src2 = getselectedsource(vid_lat2);
    src2.TriggerMode = 'Off';
end

if fh.cbk1.Value == 1 || fh.cbk2.Value == 1 || fh.cbk3.Value == 1
    preview (vid_back);
    if hand == 2
        preview (vid_lat);
    end
else
    msgbox('First initialize the reach boxes by checking on the appropiate box');
end

if fh.cbk1.Value == 1
    if hand == 1
        preview (vid_lat2);
    end
end

end