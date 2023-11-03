lines = findobj(gcf, 'Type', 'Line');

if(exist('MFC') & exist('MEC'))
    for i = 1:numel(lines)
        lines(i).MarkerEdgeColor = MEC;
        lines(i).MarkerFaceColor = MFC;
        lines(i).MarkerSize = 6;
    end
else
    for i = 1:numel(lines)
        lines(i).MarkerEdgeColor = 'k';
        lines(i).MarkerFaceColor = 'r';
        lines(i).MarkerSize = 6;
    end
end