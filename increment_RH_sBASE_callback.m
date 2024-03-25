function increment_RH_sBASE_callback (hObject,eventData)
% Author - Aamir Abbasi

global subF;

step = 0.01;
currentpos = str2num(subF.editB_RH.String);
if currentpos < 1
    currentpos = currentpos + step;
    subF.editB_RH.String = num2str(currentpos);
elseif currentpos >= 1
    errordlg('Motor position values must be between 0 and 1');
    subF.editB_RH.String = num2str(1);
end

end