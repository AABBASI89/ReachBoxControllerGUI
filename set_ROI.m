function set_ROI(hObject,eventdata)
% AAMIR ABBASI 2024

global fh;
global ROI_mask;
global base_image;
global vid_lat;
global rest_position;
global reach_position_R;
global sBASE;
global sARM;

if fh.cbk2.Value == 1 || fh.cbk3.Value == 1
    
    doorClose_callback;
    
    for step = 1:30
        writePosition(sBASE,rest_position(1) + step*((reach_position_R(1)-rest_position(1))/30));
        writePosition(sARM,rest_position(2) + step*((reach_position_R(2)-rest_position(2))/30)); %right handed
    end
    
    pause(1);
    
    set(vid_lat,'loggingmode','memory');
    start(vid_lat);
    trigger(vid_lat);
    pause(0.5);
    stop(vid_lat);
    set(vid_lat,'loggingmode','disk');
    f_avail=get(vid_lat,'FramesAvailable');
    [im_lat t_lat] = getdata(vid_lat,f_avail);
    base_image=im_lat(:,:,:,end);
    
    f1=figure;
    im_s1=size(base_image,1);
    im_s2=size(base_image,2);
    imshow(base_image);
    [x, y]=ginput;
    close(f1);
    
    fh.ROI_ax=subplot('Position',[0.53 0.41 0.43 0.2]);
    x=round(x);y=round(y);
    ROI_mask=poly2mask(x,y,im_s1,im_s2);
    temp=base_image;
    temp(ROI_mask)=-100; %create mask
    imshow(temp);
    
elseif fh.cbk1.Value == 1
    msgbox('This step is not required for Box 1');
    
elseif fh.cbk2.Value == 0 || fh.cbk3.Value == 0
    msgbox('First initialize either reach box 1 or 2 by checking on the appropiate box');
end
end
