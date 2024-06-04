function startStop_callback(hObject,eventdata)     
% SHAKTHI VISAGAN

global fh
global stopState

if get(fh.start,'Value')
    set(fh.start,'String','STOP')
    stopState = 0;
    
    if get(fh.status2,'value') == 1
        sleep_block;
    end
    
    if get(fh.status2,'value') == 2
        reach_block;
    end
    
    if get(fh.status2,'value') == 3
        reach_block_back;
    end
    
    if get(fh.status2,'value') == 4
        reach_block_no_save;
    end
    
    if get(fh.status2,'value') == 6
        reach_block_Basler_2Cams_Stim;
    end
    
    if get(fh.status2,'value') == 7
        reach_block_Basler_2Cams;
    end    

else
    stopState = 1;
    set(fh.start,'String','START')
    statusUpdate('ENDING...')
end

end