function increment_LH_sARM_callback (hObject,eventData)
% Author - Aamir Abbasi

global subF;

step = 0.01;
currentpos = str2num(subF.editA_LH.String);
if currentpos < 1
    currentpos = currentpos + step;
    subF.editA_LH.String = num2str(currentpos);
elseif currentpos >= 1
    errordlg('Motor position values must be between 0 and 1');
    subF.editA_LH.String = num2str(1);
end

end