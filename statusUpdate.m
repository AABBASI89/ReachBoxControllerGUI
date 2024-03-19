function statusUpdate(string)
% Shakthi Visagan

global fh

statuses = get(fh.status,'String');
statuses = {statuses{:}, string};
set(fh.status,'String',statuses)
set(fh.status,'Value',length(statuses))
drawnow

end