function preview_callback(hObject,eventdata)

global fh;
global vid_back;
global vid_lat;
global vid_lat2;

if fh.cbk1 == 1
    src = getselectedsource(vid_lat);
    src.TriggerMode = 'Off';
    src2 = getselectedsource(vid_lat2);
    src2.TriggerMode = 'Off';
end
preview (vid_back);
preview (vid_lat);

if fh.chbk1 == 1
    preview (vid_lat2);
end

end