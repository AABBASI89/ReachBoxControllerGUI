function calibrate_callback (hObject,eventData)
% SHAKTHI VISAGAN

global ARD_BOARD
global fh
global thresh_back

if fh.cbk1.Value == 1 || fh.cbk2.Value == 1 || fh.cbk3.Value == 1
    fh.sens_ax=subplot('Position',[0.55 0.1 0.4 0.2]);
    cla reset;
    set(fh.sens_ax,'XTickLabel',[]);
    %set(fh.sens_ax,'YTickLabel',[]);
    %set(gca,'YTick',[]);
    set(gca,'XTick',[]);
    set(gca,'Color',[0 0 0]);
    xlim([0 50]);
    ylim([0 0.25]);
    hold on
    back_IR = zeros(50,1);
    for n=1:length(back_IR)
        back_IR(n) = readVoltage(ARD_BOARD,'A0');
        fh.sens_data = plot(fh.sens_ax,back_IR(1:n),'r','LineWidth',2);
    end
    thresh_back = mean(back_IR)*0.5;
    plot(fh.sens_ax,ones(50,1)*thresh_back(:),'r:','LineWidth',2)
    hold off
    
else
    msgbox('First initialize the reach boxes by checking on the appropiate box');
end

end