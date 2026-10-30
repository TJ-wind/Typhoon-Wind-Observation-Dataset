%% Paper figures. Change figureNumbers to draw selected figures, e.g. [3 5].
% Wind figures read hourly observation CSVs directly from the main data folder.
% Ten-minute means, quality counts and profiles are calculated when this runs.
% The field photograph and relief raster are reused unchanged.
% All coordinates are in degrees; wind speeds are in m/s; heights are in m.
% Figure dimensions are in cm. Text: Microsoft YaHei, 8 pt; titles: 9.5 pt.
figureNumbers = 1:9;
root = fileparts(mfilename('fullpath'));
dataFolder = fullfile(root, 'data');
assetFolder = fullfile(root, 'paper_figures', 'assets');
outputFolder = fullfile(root, 'paper_figures', 'output');
if ~isfolder(outputFolder), mkdir(outputFolder); end
blue = [60 84 136]/255; green = [0 160 135]/255; red = [230 75 53]/255;
phaseColors = [blue; red; green];

%% 1. Complete tracks and observation coordinates.
if ismember(1, figureNumbers)
    tracks = readtable(fullfile(assetFolder, 'best_tracks.csv'), 'TextType', 'string');
    sites = readtable(fullfile(assetFolder, 'observation_coordinates.csv'), 'TextType', 'string');
    geometry = readtable(fullfile(assetFolder, 'map_geometry.csv'), 'TextType', 'string');
    relief = imread(fullfile(assetFolder, 'regional_relief.png'));
    groups = findgroups(geometry.kind, geometry.feature_index, geometry.part_index);
    parts = cell(max(groups), 1);
    for k = 1:numel(parts), parts{k} = geometry(groups == k, :); end
    f = newFigure(18, 17.6);
    ax = axes(f, 'Position', [1/18 7.75/17.6 16.35/18 (16.35*64/114)/17.6]);
    drawMap(ax, [70 184 -8 56], [80 100 120 140 160 180], [0 20 40], parts, relief);
    panelTitle(ax, '(a) Complete typhoon tracks');
    handles = drawTracks(ax, tracks, [1720 1822 1909 2004 2007 2209 2212 2421]);
    drawSites(ax, sites, true);
    rectangle(ax, 'Position', [108.5 19.3 6.7 5.2], 'LineStyle', '--', 'LineWidth', .65);
    rectangle(ax, 'Position', [117 26 8 6.3], 'LineStyle', '--', 'LineWidth', .65);
    text(ax, 107.7, 25.5, 'b'); text(ax, 116.2, 33.3, 'c');
    names = {'Khanun (2017)','Mangkhut (2018)','Lekima (2019)','Hagupit (2020)', ...
        'Higos (2020)','Ma-on (2022)','Muifa (2022)','Kong-rey (2024)'};
    lg = legend(ax, handles, names, 'NumColumns', 2, 'Location', 'southwest', 'Box', 'off');
    lg.Color = 'white'; lg.FontSize = 8; lg.FontName = 'Microsoft YaHei';
    ax = axes(f, 'Position', [1/18 .95/17.6 7/18 (7*5.2/6.7)/17.6]);
    drawMap(ax, [108.5 115.2 19.3 24.5], [110 112 114], [20 22 24], parts, relief);
    panelTitle(ax, '(b) Southern coast'); drawTracks(ax, tracks, [1720 1822 2007 2209]); drawSites(ax, sites, false);
    siteLabel(ax, sites, 'Khanun', [108.75 19.8], 'Khanun / Mangkhut');
    siteLabel(ax, sites, 'Higos', [108.75 22.7], 'Higos'); siteLabel(ax, sites, 'Ma-on', [111.2 24.0], 'Ma-on');
    ax = axes(f, 'Position', [10.35/18 .95/17.6 7/18 (7*6.3/8)/17.6]);
    drawMap(ax, [117 125 26 32.3], [118 120 122 124], [26 28 30 32], parts, relief);
    panelTitle(ax, '(c) Eastern coast'); drawTracks(ax, tracks, [1909 2004 2212 2421]); drawSites(ax, sites, false);
    for item = {'Kong-rey',31.3; 'Muifa',30.0; 'Lekima',28.6; 'Hagupit',27.15}'
        siteLabel(ax, sites, item{1}, [117.25 item{2}], item{1});
    end
    labelBox(f, [.28 .005 .6 .025], 'Circles: observation coordinates; diamonds: rounded field coordinates', 8, 'normal');
    saveFigure(f, outputFolder, 'china_typhoon_map');
end

%% 2. Field photograph and three-dimensional scanning geometries.
if ismember(2, figureNumbers)
    f = newFigure(18, 9.5);
    ax = axes(f, 'Position', [.015 .255 .295 .64]);
    image(ax, imread(fullfile(assetFolder, 'lidar_photograph.png'))); axis(ax, 'image'); axis(ax, 'off');
    for j = 1:2
        ax = axes(f, 'Position', [.325+(j-1)*.335 .245 .335 .66]); scanGeometry(ax, j, blue, green);
    end
    labelBox(f, [.025 .91 .31 .07], '(a) Field instrument', 9.5, 'bold');
    labelBox(f, [.345 .91 .31 .07], '(b) Conical scan', 9.5, 'bold');
    labelBox(f, [.685 .91 .31 .07], '(c) Five-beam DBS', 9.5, 'bold');
    labelBox(f, [.025 .15 .28 .09], 'Scanning Doppler lidar', 8, 'normal');
    labelBox(f, [.345 .15 .30 .09], sprintf('36 azimuths; 10° steps\nAbout 36 s per cycle'), 8, 'normal');
    labelBox(f, [.685 .15 .30 .09], sprintf('Inclined: 75° elevation\nVertical: 90° elevation'), 8, 'normal');
    labelBox(f, [.35 .065 .64 .06], 'Blue: inclined beams / gates     Green: vertical beam / gates', 8, 'normal');
    labelBox(f, [.35 .01 .64 .06], 'ρ = z cot 75°; equal scale. Illustrative gates; enlarged instruments.', 8, 'normal');
    saveFigure(f, outputFolder, 'fig00_lidar_combined');
end

%% 3-4. Wind-speed histories for the eight events.
if any(ismember([3 4], figureNumbers))
    eventIndices = [];
    if ismember(3,figureNumbers), eventIndices=[eventIndices 1:4]; end
    if ismember(4,figureNumbers), eventIndices=[eventIndices 5:8]; end
    H = observationHistories(dataFolder,eventIndices);
    events = {'khanun','mangkhut','lekima','hagupit','higos','maon','muifa','kongrey'};
    labels = {'Khanun 2017','Mangkhut 2018','Lekima 2019','Hagupit 2020','Higos 2020','Ma-on 2022','Muifa 2022','Kong-rey 2024'};
    for group = 1:2
        if ~ismember(group+2,figureNumbers), continue; end
        f = newFigure(18, 12);
        for j = 1:4
            k = (group-1)*4+j; T = H(H.event == events{k}, :);
            ax = axes(f, 'Position', [.10+mod(j-1,2)*.49 .64-floor((j-1)/2)*.48 .38 .26]); hold(ax,'on');
            origin = min(datetime(T.bin_start_recorded, 'InputFormat', 'yyyy-MM-dd HH:mm:ss'));
            targets = [100 300]; if k==5, targets=[100 300 200]; end
            colors = [blue;green;red]; heights=zeros(1,numel(targets));
            for m = 1:numel(targets)
                R = T(T.target_height_m == targets(m), :);
                dt = datetime(R.bin_start_recorded, 'InputFormat', 'yyyy-MM-dd HH:mm:ss');
                [dt,idx] = sort(dt); R=R(idx,:); x=hours(dt+minutes(5)-origin);
                style='-'; if m==3, style='--'; end
                handles(m) = plot(ax,x,R.plot_speed_mps,style,'Color',colors(m,:),'LineWidth',1); %#ok<SAGROW>
                q=R.open_marker==1; plot(ax,x(q),R.plot_speed_mps(q),'o','MarkerSize',3, ...
                    'MarkerFaceColor','w','MarkerEdgeColor',colors(m,:),'LineWidth',.65);
                heights(m)=median(R.actual_height_m,'omitnan');
            end
            panelTitle(ax,sprintf('(%c) %s',char(96+j),labels{k}));
            ax.Title.Position(2)=1.20;
            text(ax,0,1.04,['Origin: ' char(string(origin,'yyyy-MM-dd HH:mm'))], 'Units','normalized','FontSize',8);
            xlabel(ax,'Elapsed time (h)');ylabel(ax,'Horizontal speed (m/s)');
            upperSpeed=5*ceil(1.05*max(T.plot_speed_mps,[],'omitnan')/5);
            ylim(ax,[0 upperSpeed]);xlim(ax,[0 max(x)+1/12]);
            ypos=.05; if ismember(k,[2 6]),ypos=.90;end
            text(ax,.025,ypos,sprintf('z ≈ %.1f / %.1f m',heights(1),heights(2)), 'Units','normalized','FontSize',8);
            if j==1
                legendHandles=handles(1:numel(targets));
            end
        end
        if group==1, names={'Near 100 m','Near 300 m'}; stem='fig05_full_records_early';
        else, names={'Near 100 m','Near 300 m','Near 200 m (Higos)'};stem='fig06_full_records_late';end
        lg=legend(legendHandles,names,'Orientation','horizontal','Box','off','FontName','Microsoft YaHei','FontSize',8);
        lg.Position=[.28 .015 .67 .05];saveFigure(f,outputFolder,stem);
    end
end

%% Read the shared Hagupit records used by Figures 5-9.
if any(ismember(5:9,figureNumbers))
    [T,P]=hagupitStatistics(dataFolder);
    [times,~,ti]=unique(T.bin_start_recorded);[z,~,zi]=unique(T.height_m);
    x=hours(datetime(times,'InputFormat','yyyy-MM-dd HH:mm:ss')-datetime(2020,8,3))+1/12;
    idx=sub2ind([numel(z) numel(times)],zi,ti); variables={'mean_speed_mps','mean_eastward_mps','mean_northward_mps', ...
        'circular_direction_deg','accepted_fraction','qualified','accepted_count','finite_count'};
    M=struct();
    for k=1:numel(variables), a=nan(numel(z),numel(times));a(idx)=T.(variables{k});M.(variables{k})=a;end
    j100=find(z==100);j300=find(z==300); phaseHours=[15+55/60 17+45/60 18+45/60];phaseNames={'A','B','C'};
    phaseLabels={'A: 15:50–16:00','B: 17:40–17:50','C: 18:40–18:50'};phaseIndex=zeros(1,3);
    for k=1:3,[~,phaseIndex(k)]=min(abs(x-phaseHours(k)));end
end

%% 5. Strong wind, lull, renewed strong wind, and the retained-record counts.
if ismember(5,figureNumbers)
    f=newFigure(18,13);
    titles={'(a) Strong wind, lull, and renewed strong wind','(b) Wind-direction change at 100 m','(c) Data retained in each 10-min interval'};
    for j=1:3
        ax=axes(f,'Position',[.11 .72-(j-1)*.29 .86 .20]);hold(ax,'on');panelTitle(ax,titles{j});
        if j==1
            for level=[j100 j300]
                y=M.mean_speed_mps(level,:);y(~M.qualified(level,:))=nan;
                color=blue;style='-';if level==j300,color=[.45 .45 .45];style='--';end
                plot(ax,x,y,style,'Color',color,'LineWidth',1.1);
            end
            ylim(ax,[0 46]);ylabel(ax,'Horizontal speed (m/s)');
            lg=legend(ax,{'100 m','300 m'},'Location','northwest','Box','off','NumColumns',2);lg.AutoUpdate='off';
            values=M.mean_speed_mps(j100,:);
        elseif j==2
            values=M.circular_direction_deg(j100,:);q=M.qualified(j100,:)==1;y=values;y(~q)=nan;y([false abs(diff(y))>180])=nan;
            plot(ax,x,y,'Color',blue,'LineWidth',1.1);ylim(ax,[0 280]);yticks(ax,[0 90 180 270]);ylabel(ax,'Recorded direction (deg)');
        else
            plot(ax,x,M.accepted_fraction(j100,:),'Color',blue,'LineWidth',1.1);
            plot(ax,x,M.accepted_fraction(j300,:),'--','Color',[.45 .45 .45],'LineWidth',1.1);
            yline(ax,.8,':','Color',[.55 .55 .55]);ylim(ax,[-.05 1.16]);ylabel(ax,'Accepted / finite');values=M.accepted_fraction(j100,:);
        end
        for k=1:3
            i=phaseIndex(k);plot(ax,x(i),values(i),'o','MarkerFaceColor',phaseColors(k,:),'MarkerEdgeColor','w','MarkerSize',5);
            if j==3,label=sprintf('%s: %d/%d',phaseNames{k},M.accepted_count(j100,i),M.finite_count(j100,i));dy=-.18;
            elseif j==2,label=sprintf('%s  %.1f°',phaseNames{k},values(i));dy=22;
            else,label=sprintf('%s  %.2f',phaseNames{k},values(i));dy=5;end
            text(ax,x(i)-.55,values(i)+dy,label,'Color',phaseColors(k,:),'FontSize',8,'BackgroundColor','white');
        end
        clockAxis(ax,j==3);
    end
    saveFigure(f,outputFolder,'fig10_hagupit_passage');
end

%% 6. Native height-time grids: wind speed, direction, and availability.
if ismember(6,figureNumbers)
    f=newFigure(18,14);keys={'mean_speed_mps','circular_direction_deg','accepted_fraction'};
    titles={'(a) Hagupit: horizontal wind speed','(b) Rotation of the wind direction','(c) Height-dependent data availability'};
    limits={[0 45],[0 360],[0 1]};labels={'Speed (m/s)','Direction (deg)','Accepted / finite'};
    for j=1:3
        ax=axes(f,'Position',[.11 .73-(j-1)*.30 .73 .20]);hold(ax,'on');q=z<=500;values=M.(keys{j})(q,:);
        if j<3,ok=M.qualified(q,:)==1;values(~ok)=nan;end
        img=imagesc(ax,x,z(q),values);img.AlphaData=isfinite(values);set(ax,'YDir','normal','Color','w');
        if j==1,colormap(ax,paperMap('speed'));elseif j==2,colormap(ax,paperMap('direction'));else,colormap(ax,flipud(gray(256)));end
        clim(ax,limits{j});ylim(ax,[45 505]);yticks(ax,[100 300 500]);ylabel(ax,'Height (m)');panelTitle(ax,titles{j});
        cb=colorbar(ax);cb.Position=[.865 ax.Position(2) .015 .20];cb.Label.String=labels{j};cb.FontSize=8;
        ax.YLabel.Units='normalized';ax.YLabel.Position=[-.10 .5 0];
        for k=1:3,xline(ax,phaseHours(k),'--','Color',phaseColors(k,:),'LineWidth',.8);end
        clockAxis(ax,j==3);
    end
    saveFigure(f,outputFolder,'fig07_event_evolution');
end

%% 7. Representative vertical profiles and a power-law fit.
if ismember(7,figureNumbers)
    f=newFigure(18,10);ax=axes(f,'Position',[.09 .30 .36 .58]);hold(ax,'on');
    profileLine(ax,P,'P',[.45 .45 .45],'s','15:10–15:40 (30 min)');profileLine(ax,P,'A',blue,'o',phaseLabels{1});
    R=P(P.phase=='P',:);q=R.qualified==1 & R.height_m>=50 & R.height_m<=300;u100=R.mean_speed_mps(R.height_m==100);
    xx=log(R.height_m(q)/100);yy=log(R.mean_speed_mps(q)/u100);alpha=(xx'*yy)/(xx'*xx);r2=1-sum((yy-alpha*xx).^2)/sum((yy-mean(yy)).^2);
    zz=(50:300)';plot(ax,u100*(zz/100).^alpha,zz,'--','Color',[.45 .45 .45],'LineWidth',1,'DisplayName','50–300 m power-law fit');
    text(ax,.035,.96,sprintf('α = %.3f\nR² = %.3f',alpha,r2),'Units','normalized','VerticalAlignment','top');
    panelTitle(ax,'(a) Deep strong-wind profiles');profileAxes(ax);lg=legend(ax,'Location','southoutside','Box','off');lg.FontSize=8;
    ax=axes(f,'Position',[.60 .30 .36 .58]);hold(ax,'on');markers={'o','s','^'};
    for k=1:3,profileLine(ax,P,phaseNames{k},phaseColors(k,:),markers{k},phaseLabels{k});end
    panelTitle(ax,'(b) Profiles through the wind lull');profileAxes(ax);lg=legend(ax,'Location','southoutside','Box','off');lg.FontSize=8;
    saveFigure(f,outputFolder,'fig11_representative_profiles');
end

%% 8. Measured horizontal sampling positions and the horizontal wind path.
if ismember(8,figureNumbers)
    R=higosSampling(dataFolder);f=newFigure(18,10.4);
    ax=axes(f,'Position',[.09 .25 .34 .59]);hold(ax,'on');axis(ax,'equal');theta=linspace(0,2*pi,181);
    plot(ax,134*cos(theta),134*sin(theta),'--','Color',[.8 .8 .8]);xline(ax,0,'Color',[.85 .85 .85]);yline(ax,0,'Color',[.85 .85 .85]);
    cm=[linspace(.2,1,128)' linspace(.4,1,128)' ones(128,1);ones(128,1) linspace(1,.2,128)' linspace(1,.2,128)'];
    colormap(ax,cm);clim(ax,[-10 10]);offsets=[10 -25;-10 36;10 22;10 36;10 -25];
    for k=1:height(R)
        value=R.radial_wind_speed_mps(k);color=cm(max(1,min(256,round((value+10)/20*255)+1)),:);
        face=color;if R.source_status(k)~=1,face='w';end
        plot(ax,R.eastward_offset_m(k),R.northward_offset_m(k),'o','MarkerFaceColor',face,'MarkerEdgeColor',color,'MarkerSize',5);
        if R.source_status(k)~=1,plot(ax,R.eastward_offset_m(k),R.northward_offset_m(k),'x','Color',[.3 .3 .3]);end
        name=sprintf('LOS %d',R.los_id(k));if R.los_id(k)==4,name='Vertical';end
        align='left';if R.los_id(k)==1,align='right';end
        text(ax,R.eastward_offset_m(k)+offsets(k,1),R.northward_offset_m(k)+offsets(k,2),sprintf('%s\n%+.2f',name,value),'HorizontalAlignment',align);
    end
    xlim(ax,[-190 190]);ylim(ax,[-190 190]);xticks(ax,[-150 0 150]);yticks(ax,[-150 0 150]);
    panelTitle(ax,'(a) Measured DBS sampling positions');text(ax,.02,.98,'Higos; height ≈ 500 m','Units','normalized','VerticalAlignment','top');
    acceptedSymbol=plot(ax,nan,nan,'o','MarkerFaceColor',[.3 .3 .3],'MarkerEdgeColor',[.3 .3 .3],'MarkerSize',4);
    rejectedSymbol=plot(ax,nan,nan,'x','Color',[.3 .3 .3],'MarkerSize',4);
    lg=legend(ax,[acceptedSymbol rejectedSymbol],{'Status 1','Status 0'},'Location','southwest','Box','off');lg.AutoUpdate='off';
    xlabel(ax,'Eastward offset (m)');ylabel(ax,'Northward offset (m)');cb=colorbar(ax,'southoutside');cb.Position=[.095 .12 .33 .02];cb.Label.String='Recorded radial wind speed (m/s)';
    ax=axes(f,'Position',[.61 .25 .34 .59]);hold(ax,'on');axis(ax,'equal');xline(ax,0,'Color',[.8 .8 .8]);yline(ax,0,'Color',[.8 .8 .8]);
    for radius=[10 20 30],plot(ax,radius*cos(theta),radius*sin(theta),':','Color',[.85 .85 .85]);end
    u=M.mean_eastward_mps(j100,:);v=M.mean_northward_mps(j100,:);u(~M.qualified(j100,:))=nan;v(~M.qualified(j100,:))=nan;
    plot(ax,u,v,'Color',[.65 .65 .65],'LineWidth',.65);scatter(ax,u,v,15,x-(10+40/60),'filled');colormap(ax,paperMap('speed'));clim(ax,[0 9]);
    for k=1:3
        i=phaseIndex(k);plot(ax,u(i),v(i),'o','MarkerFaceColor',phaseColors(k,:),'MarkerEdgeColor','w','MarkerSize',6);
        offset=[2 2];if k==1,offset=[-3 -5];end
        text(ax,u(i)+offset(1),v(i)+offset(2),phaseNames{k},'Color',phaseColors(k,:),'FontWeight','bold');
    end
    xlim(ax,[-40 40]);ylim(ax,[-40 40]);xticks(ax,-40:20:40);yticks(ax,-40:20:40);
    panelTitle(ax,'(b) Hagupit: horizontal wind path');text(ax,.02,.98,'Height 100 m; 10-min means','Units','normalized','VerticalAlignment','top');
    xlabel(ax,'Eastward wind (m/s)');ylabel(ax,'Northward wind (m/s)');cb=colorbar(ax,'southoutside');cb.Position=[.615 .12 .33 .02];cb.Label.String='Elapsed recorded time (h)';
    saveFigure(f,outputFolder,'fig08_horizontal_wind');
end

%% 9. Three-dimensional wind vectors and direction with height.
if ismember(9,figureNumbers)
    f=newFigure(18,11);ax=axes(f,'Position',[.08 .24 .46 .63]);hold(ax,'on');ad=axes(f,'Position',[.71 .28 .25 .57]);hold(ad,'on');markers={'o','s','^'};
    for k=1:3
        R=P(P.phase==phaseNames{k},:);q=R.qualified==1 & R.height_m<=350;u=R.mean_eastward_mps;v=R.mean_northward_mps;u(~q)=nan;v(~q)=nan;
        plot3(ax,u,v,R.height_m,'Color',phaseColors(k,:),'LineWidth',1.3,'Marker',markers{k},'MarkerIndices',1:3:height(R),'MarkerSize',3,'MarkerFaceColor','w');
        i=find(R.height_m==100);quiver3(ax,0,0,100,u(i),v(i),0,0,'Color',phaseColors(k,:),'LineWidth',.9);
        it=find(q,1,'last');text(ax,u(it),v(it),R.height_m(it)+13,phaseNames{k},'Color',phaseColors(k,:),'FontWeight','bold');
        direction=R.component_mean_direction_deg;direction(~q)=nan;
        dh(k)=plot(ad,direction,R.height_m,'Color',phaseColors(k,:),'LineWidth',1.2,'Marker',markers{k},'MarkerIndices',1:3:height(R),'MarkerSize',3,'MarkerFaceColor','w'); %#ok<SAGROW>
    end
    xlim(ax,[-40 40]);ylim(ax,[-40 40]);zlim(ax,[40 350]);xticks(ax,[-40 0 40]);yticks(ax,[-40 0 40]);zticks(ax,[50 100 200 300]);
    xlabel(ax,'Eastward wind (m/s)');ylabel(ax,'Northward wind (m/s)');zlabel(ax,'Height (m)');view(ax,34,22);pbaspect(ax,[1 1 1.15]);grid(ax,'on');ax.GridAlpha=.15;
    xlim(ad,[0 270]);ylim(ad,[40 350]);xticks(ad,[0 90 180 270]);yticks(ad,[50 100 200 300]);xlabel(ad,'Wind-from direction (deg)');ylabel(ad,'Height (m)');
    labelBox(f,[.025 .90 .59 .07],'(a) Hagupit: 3D wind-vector profiles',9.5,'bold');labelBox(f,[.70 .90 .29 .07],'(b) Direction with height',9.5,'bold');
    lg=legend(ad,dh,phaseLabels,'Orientation','horizontal','Box','off');lg.Position=[.23 .025 .74 .06];
    saveFigure(f,outputFolder,'fig09_wind_vector_profiles');
end
fprintf('Paper figures saved in %s\n',outputFolder);

%% Local drawing helpers.
function f=newFigure(w,h)
f=figure('Units','centimeters','Position',[2 2 w h],'Color','w','Visible','off', ...
 'DefaultAxesFontName','Microsoft YaHei','DefaultTextFontName','Microsoft YaHei', ...
 'DefaultAxesFontSize',8,'DefaultTextFontSize',8,'DefaultAxesLineWidth',.7, ...
 'DefaultAxesLabelFontSizeMultiplier',1, ...
 'DefaultAxesTickDir','in','DefaultAxesBox','on','DefaultTextInterpreter','none', ...
 'DefaultLegendInterpreter','none','DefaultAxesTickLabelInterpreter','none');
end
function panelTitle(ax,s)
t=title(ax,s,'FontName','Microsoft YaHei','FontSize',9.5,'FontWeight','bold','Interpreter','none');
t.HorizontalAlignment='left';t.Units='normalized';t.Position(1)=0;
end
function labelBox(f,p,s,size,weight)
annotation(f,'textbox',p,'String',s,'LineStyle','none','FontName','Microsoft YaHei','FontSize',size, ...
 'FontWeight',weight,'Interpreter','none','Margin',0,'VerticalAlignment','top');
end
function saveFigure(f,folder,stem)
set(findall(f,'Type','legend'),'FontName','Microsoft YaHei','FontSize',8);
bars=findall(f,'Type','colorbar');
for k=1:numel(bars),bars(k).FontName='Microsoft YaHei';bars(k).FontSize=8;bars(k).Label.FontSize=8;end
drawnow;exportgraphics(f,fullfile(folder,[stem '.pdf']),'ContentType','vector','BackgroundColor','white');
exportgraphics(f,fullfile(folder,[stem '.png']),'Resolution',800,'BackgroundColor','white');
if ~strcmp(stem,'china_typhoon_map')
    exportgraphics(f,fullfile(folder,[stem '_preview.png']),'Resolution',150,'BackgroundColor','white');
end
fprintf('Saved %s\n',stem);close(f);
end
function clockAxis(ax,last)
xlim(ax,[10+40/60 19+40/60]);xticks(ax,11:19);xticklabels(ax,compose('%02d:00',11:19));
if last,xlabel(ax,'3 August 2020 (recorded clock)');else,xticklabels(ax,{});end
end
function profileAxes(ax)
xlim(ax,[0 45]);ylim(ax,[40 350]);yticks(ax,[50 100 200 300]);xlabel(ax,'Horizontal speed (m/s)');ylabel(ax,'Height (m)');
end
function profileLine(ax,P,phase,color,marker,label)
R=P(P.phase==phase,:);u=R.mean_speed_mps;u(~R.qualified)=nan;
plot(ax,u,R.height_m,'Color',color,'LineWidth',1.2,'Marker',marker,'MarkerIndices',1:3:height(R), ...
 'MarkerSize',3,'MarkerFaceColor','w','DisplayName',label);
end
function drawMap(ax,extent,xt,yt,parts,relief)
hold(ax,'on');image(ax,[70 184],[56 -8],relief);set(ax,'YDir','normal','Color',[.61 .77 .86]);
for j=1:numel(parts)
 R=parts{j};x=R.longitude_deg;y=R.latitude_deg;
 if max(x)<extent(1)||min(x)>extent(2)||max(y)<extent(3)||min(y)>extent(4),continue;end
 switch R.kind(1)
  case 'lakes',fill(ax,x,y,[.57 .72 .86],'EdgeColor','none');
  case 'rivers',plot(ax,x,y,'Color',[.57 .72 .86],'LineWidth',.38);
 end
end
xlim(ax,extent(1:2));ylim(ax,extent(3:4));daspect(ax,[1 1 1]);xticks(ax,xt);yticks(ax,yt);
xticklabels(ax,compose('%g°E',xt));yticklabels(ax,compose('%g°N',yt));
if ~isempty(xt),grid(ax,'on');ax.GridLineStyle='--';ax.GridColor='k';ax.GridAlpha=.35;end
end
function handles=drawTracks(ax,T,ids)
allIds=[1720 1822 1909 2004 2007 2209 2212 2421];colors=[0 114 178;0 158 115;213 94 0;204 121 167;230 159 0;86 180 233;51 34 136;85 85 85]/255;
styles={'-','-','-','-','--','--','-.',':'};handles=gobjects(1,numel(ids));
for j=1:numel(ids)
 k=find(allIds==ids(j));R=T(T.jma_id==ids(j),:);
 handles(j)=plot(ax,R.longitude_e,R.latitude_n,'Color',colors(k,:),'LineStyle',styles{k},'LineWidth',1.05,'Marker','.','MarkerSize',2);
 plot(ax,R.longitude_e(1),R.latitude_n(1),'o','MarkerSize',3,'MarkerFaceColor','w','MarkerEdgeColor',colors(k,:));
end
end
function drawSites(ax,S,overview)
colors=[0 114 178;0 158 115;213 94 0;204 121 167;230 159 0;86 180 233;51 34 136;85 85 85]/255;
size=5.5;if overview,size=3.5;end
for k=1:height(S)
 marker='o';face=colors(k,:);edge=[.2 .2 .2];
 if S.map_position_role(k)=='rounded_deployment_coordinate',marker='d';face='w';edge=colors(k,:);end
 plot(ax,S.map_longitude_deg(k),S.map_latitude_deg(k),marker,'MarkerSize',size,'MarkerFaceColor',face,'MarkerEdgeColor',edge,'LineWidth',.8);
end
end
function siteLabel(ax,S,event,xy,label)
r=find(strcmp(S.event_name,event),1);assert(~isempty(r));
plot(ax,[xy(1) S.map_longitude_deg(r)],[xy(2) S.map_latitude_deg(r)],'-','Color',[.3 .3 .3],'LineWidth',.65);
text(ax,xy(1),xy(2),label,'FontSize',8,'BackgroundColor','w','Margin',1,'Clipping','on');
end
function scanGeometry(ax,kind,blue,green)
hold(ax,'on');cot75=cotd(75);levels=[.35 .65 1];t=linspace(0,2*pi,121);
patch(ax,[-.36 .36 .36 -.36],[-.36 -.36 .36 .36],[-.065 -.065 -.065 -.065],[.96 .96 .96],'EdgeColor',[.85 .85 .85]);
for z=levels,plot3(ax,z*cot75*sin(t),z*cot75*cos(t),z*ones(size(t)),':','Color',[.75 .75 .75],'LineWidth',.5);end
if kind==1
 [aa,zz]=meshgrid(t,linspace(0,1,24));surf(ax,zz*cot75.*sin(aa),zz*cot75.*cos(aa),zz,'FaceColor',blue,'FaceAlpha',.06,'EdgeColor','none');
 for az=0:10:350,plot3(ax,[0 cot75*sind(az)],[0 cot75*cosd(az)],[0 1],'Color',[.75 .77 .79],'LineWidth',.3);end
 angles=[0 120 240];
else,angles=[0 90 180 270];end
for az=angles
 plot3(ax,[0 cot75*sind(az)],[0 cot75*cosd(az)],[0 1],'Color',blue,'LineWidth',1);
 scatter3(ax,levels*cot75*sind(az),levels*cot75*cosd(az),levels,9,blue,'filled');
 text(ax,1.2*cot75*sind(az),1.2*cot75*cosd(az),1.02,sprintf('%d°',az),'HorizontalAlignment','center','Color',blue);
end
if kind==2,plot3(ax,[0 0],[0 0],[0 1.04],'Color',green,'LineWidth',1.2);scatter3(ax,zeros(1,3),zeros(1,3),levels,10,green,'s','filled');end
quiver3(ax,0,0,-.065,.4,0,0,0,'Color',[.3 .3 .3]);quiver3(ax,0,0,-.065,0,.4,0,0,'Color',[.3 .3 .3]);
text(ax,.44,0,-.065,'E');text(ax,0,.44,-.065,'N');plot3(ax,[0 0],[0 0],[0 1.11],'--','Color',[.3 .3 .3]);text(ax,0,0,1.17,'Height','HorizontalAlignment','center');
v=[-.033 -.033 -.065;.033 -.033 -.065;.033 .033 -.065;-.033 .033 -.065;-.033 -.033 0;.033 -.033 0;.033 .033 0;-.033 .033 0];
patch(ax,'Vertices',v,'Faces',[1 2 3 4;1 2 6 5;2 3 7 6;3 4 8 7;4 1 5 8;5 6 7 8],'FaceColor',[.83 .85 .87],'EdgeColor',[.3 .3 .3],'LineWidth',.35);
a=linspace(0,75,80);plot3(ax,.19*cosd(a),zeros(size(a)),.19*sind(a),'Color',[.3 .3 .3]);text(ax,.24,-.04,.25,'75°');
xlim(ax,[-.42 .42]);ylim(ax,[-.42 .42]);zlim(ax,[-.12 1.2]);daspect(ax,[1 1 1]);view(ax,36,19);camproj(ax,'orthographic');axis(ax,'off');
end
function colors=paperMap(quantity)
% Sequential wind-speed colours and a cyclic wind-direction scale.
if strcmp(quantity,'speed')
    anchors=[.267 .005 .329;.279 .175 .483;.230 .322 .546;.173 .449 .558; ...
        .128 .567 .551;.158 .684 .502;.369 .789 .383;.678 .864 .190;.993 .906 .144];
else
    anchors=[.886 .850 .888;.583 .708 .779;.384 .461 .731;.350 .165 .561; ...
        .185 .079 .213;.453 .116 .309;.698 .338 .322;.800 .640 .537;.886 .850 .888];
end
colors=interp1(linspace(0,1,size(anchors,1)),anchors,linspace(0,1,256));
end

%% Observation statistics calculated from the main data directory.
function data = readObservationColumns(filename, columns)
% Use the same public reader, selecting only the fields needed here.
data = main_function(filename, columns);
end

function H = observationHistories(dataFolder, eventIndices)
% Calculate 10-minute histories directly from the hourly observation CSVs.
% Read only the requested events, one file at a time.
ids = {'2017_20_Khanun','2018_22_Mangkhut','2019_09_Lekima', ...
    '2020_04_Hagupit','2020_07_Higos','2022_09_Maon', ...
    '2022_12_Muifa','2024_21_Kongrey'};
names = {'khanun','mangkhut','lekima','hagupit','higos','maon','muifa','kongrey'};
years = [2017 2018 2019 2020 2020 2022 2022 2024];
branches = {'observations/component_profiles','observations/component_profiles', ...
    'observations/reconstructed_unfiltered','observations/reconstructed', ...
    'derived/horizontal_profiles','observations/storm_subset', ...
    'observations/reconstructed','observations/reconstructed'};
columns = {'timestamp','height_m','horizontal_wind_speed_mps','wind_status'};
H = table();
for eventIndex = reshape(unique(eventIndices, 'stable'), 1, [])
    folder = fullfile(dataFolder, ids{eventIndex}, branches{eventIndex});
    files = dir(fullfile(folder, '**', '*.csv'));
    assert(~isempty(files), 'No observation CSVs found in %s.', folder);
    [~, order] = sort(string({files.folder}) + "/" + string({files.name}));
    files = files(order);
    targets = [100 300];
    if eventIndex == 5, targets = [100 200 300]; end
    selected = cell(numel(files), numel(targets));
    firstBin = inf; lastBin = -inf;
    fprintf('Reading %s: %d hourly CSVs\n', ids{eventIndex}, numel(files));
    for fileIndex = 1:numel(files)
        D = readObservationColumns(fullfile(files(fileIndex).folder, files(fileIndex).name), columns);
        if isempty(D), continue; end
        % A profile ends when its timestamp changes or its height sequence restarts.
        start = [true; D.timestamp(2:end) ~= D.timestamp(1:end-1) | ...
            D.height_m(2:end) < D.height_m(1:end-1)];
        group = cumsum(start);
        time = datetime(D.timestamp(start), 'InputFormat', 'yyyy-MM-dd HH:mm:ss.SSSSSS');
        bin = floor(seconds(time - datetime(1970,1,1)) / 600);
        firstBin = min(firstBin, min(bin)); lastBin = max(lastBin, max(bin));
        for targetIndex = 1:numel(targets)
            % One nearest gate per profile; ties retain the first native gate.
            distance = abs(D.height_m - targets(targetIndex));
            distance(~isfinite(distance)) = inf;
            closest = accumarray(group, distance, [], @min);
            eligible = find(distance == closest(group) & distance <= 15);
            chosen = accumarray(group(eligible), eligible, [numel(time) 1], @min, 0);
            chosen = chosen(chosen > 0);
            speed = D.horizontal_wind_speed_mps(chosen);
            finite = isfinite(speed);
            accepted = finite;
            if eventIndex > 2, accepted = finite & D.wind_status(chosen) == 1; end
            selected{fileIndex,targetIndex} = [bin(group(chosen)), ...
                repmat(targetIndex,numel(chosen),1), D.height_m(chosen), speed, finite, accepted];
        end
    end
    S = vertcat(selected{:});
    assert(~isempty(S), 'No measurement heights near the selected targets in %s.', folder);
    keys = (firstBin:lastBin)';
    nTargets = numel(targets); nRows = numel(keys) * nTargets;
    row = (S(:,1) - firstBin) * nTargets + S(:,2);
    candidate = accumarray(row, 1, [nRows 1]);
    finite = accumarray(row, S(:,5), [nRows 1]);
    accepted = accumarray(row, S(:,6), [nRows 1]);
    ok = S(:,6) == 1;
    speedSum = accumarray(row(ok), S(ok,4), [nRows 1]);
    speed = speedSum ./ accepted;
    heightMask = ok;
    if eventIndex == 5, heightMask = true(size(ok)); end
    heightSum = accumarray(row(heightMask), S(heightMask,3), [nRows 1]);
    heightCount = accumarray(row(heightMask), 1, [nRows 1]);
    actualHeight = heightSum ./ heightCount;
    denominator = finite;
    if eventIndex <= 2, denominator = candidate; end
    fraction = accepted ./ denominator;
    plotSpeed = speed;
    marker = isfinite(speed) & (fraction < .8 | accepted < 5);
    if eventIndex == 5
        plotSpeed(accepted < 5) = NaN;
        marker = isfinite(plotSpeed) & fraction < .8;
        candidate = finite;
    end
    binTime = datetime(1970,1,1) + seconds(repelem(keys, nTargets) * 600);
    R = table(repmat(string(names{eventIndex}),nRows,1), ...
        repmat(years(eventIndex),nRows,1), string(binTime,'yyyy-MM-dd HH:mm:ss'), ...
        repmat(targets(:),numel(keys),1), actualHeight, speed, accepted, finite, ...
        candidate, fraction, plotSpeed, double(marker), 'VariableNames', ...
        {'event','year','bin_start_recorded','target_height_m','actual_height_m', ...
        'mean_speed_mps','accepted_count','finite_count','candidate_count', ...
        'accepted_fraction','plot_speed_mps','open_marker'});
    H = [H; R]; %#ok<AGROW>
end
end

function [T, P] = hagupitStatistics(dataFolder)
% Read the primary Hagupit observations and calculate the paper statistics.
% Each bin is 10 minutes on the recorded clock. Native levels span 50-600 m.
folder = fullfile(dataFolder, '2020_04_Hagupit', 'observations', 'reconstructed');
files = dir(fullfile(folder, '**', '*.csv'));
assert(~isempty(files), 'No Hagupit observation CSVs found in %s.', folder);
paths = sort(string(fullfile({files.folder}, {files.name})));
names = {'timestamp', 'height_m', 'horizontal_wind_speed_mps', ...
    'wind_direction_deg', 'wind_status'};
pieces = cell(numel(paths), 1);
for k = 1:numel(paths)
    D = readObservationColumns(paths(k), names);
    pieces{k} = D(D.height_m >= 50 & D.height_m <= 600, :);
end
D = vertcat(pieces{:});
assert(~isempty(D), 'Hagupit has no observations between 50 and 600 m.');
[z, ~, heightIndex] = unique(D.height_m);
% Parse each ray time once rather than once for every measurement height.
[timeText, ~, timeIndex] = unique(D.timestamp);
times = datetime(timeText, 'InputFormat', 'yyyy-MM-dd HH:mm:ss.SSSSSS');
epoch = datetime(1970, 1, 1);
rayBin = floor(seconds(times - epoch) / 600);
firstBin = min(rayBin); lastBin = max(rayBin);
binIndex = rayBin(timeIndex) - firstBin + 1;
nz = numel(z); nb = lastBin - firstBin + 1;
group = heightIndex + nz * (binIndex - 1);

speed = D.horizontal_wind_speed_mps;
direction = D.wind_direction_deg;
finite = isfinite(speed);
accepted = finite & D.wind_status == 1;
paired = accepted & isfinite(direction);
% Keep sums so a 30-minute profile is weighted by its actual record counts.
moments = zeros(nz * nb, 8);
moments(:, 1) = accumarray(group, double(accepted), [nz * nb 1], @sum, 0);
moments(:, 2) = accumarray(group, double(finite), [nz * nb 1], @sum, 0);
moments(:, 3) = accumarray(group, double(paired), [nz * nb 1], @sum, 0);
moments(:, 4) = accumarray(group(accepted), speed(accepted), [nz * nb 1], @sum, 0);
values = [-speed(paired).*sind(direction(paired)), ...
          -speed(paired).*cosd(direction(paired)), ...
          sind(direction(paired)), cosd(direction(paired))];
for k = 1:4
    moments(:, k + 4) = accumarray(group(paired), values(:, k), [nz * nb 1], @sum, 0);
end
moments = reshape(moments, nz, nb, 8);
starts = epoch + seconds((firstBin:lastBin)' * 600);
T = hagupitSummary(moments, z, starts, starts + minutes(10), repmat("", nb, 1));

phaseNames = ["P"; "A"; "B"; "C"];
phaseStart = datetime(2020, 8, 3) + minutes([15*60+10; 15*60+50; 17*60+40; 18*60+40]);
phaseEnd = datetime(2020, 8, 3) + minutes([15*60+40; 16*60; 17*60+50; 18*60+50]);
phaseMoments = zeros(nz, 4, 8);
for k = 1:4
    take = starts >= phaseStart(k) & starts < phaseEnd(k);
    phaseMoments(:, k, :) = sum(moments(:, take, :), 2);
end
P = hagupitSummary(phaseMoments, z, phaseStart, phaseEnd, phaseNames);
end

function T = hagupitSummary(moments, z, starts, stops, labels)
% Scalar means, paired vector means, circular directions and quality flags.
n = moments(:, :, 1); nf = moments(:, :, 2); nv = moments(:, :, 3);
speed = moments(:, :, 4) ./ n;
east = moments(:, :, 5) ./ nv;
north = moments(:, :, 6) ./ nv;
direction = mod(atan2d(moments(:, :, 7)./nv, moments(:, :, 8)./nv), 360);
vectorDirection = mod(atan2d(-east, -north), 360);
fraction = n ./ nf;
typicalCount = median(nf(z >= 50 & z <= 300, :), 1);
qualified = n >= 5 & fraction >= .8 & nf >= .5 * typicalCount & nv >= .8 * nf;
nz = numel(z);
phase = repelem(string(labels(:)), nz);
startText = repelem(string(starts(:), 'yyyy-MM-dd HH:mm:ss'), nz);
stopText = repelem(string(stops(:), 'yyyy-MM-dd HH:mm:ss'), nz);
height = repmat(z, numel(starts), 1);
T = table(phase, startText, stopText, height, speed(:), east(:), north(:), ...
    direction(:), vectorDirection(:), n(:), nf(:), nv(:), fraction(:), qualified(:), ...
    'VariableNames', {'phase', 'bin_start_recorded', 'bin_end_recorded', 'height_m', ...
    'mean_speed_mps', 'mean_eastward_mps', 'mean_northward_mps', ...
    'circular_direction_deg', 'component_mean_direction_deg', 'accepted_count', ...
    'finite_count', 'paired_direction_count', 'accepted_fraction', 'qualified'});
end

function R = higosSampling(dataFolder)
% Read one five-beam scan and select the gate nearest 500 m on each beam.
filename = fullfile(dataFolder, '2020_07_Higos', 'observations', 'radial', ...
    '2020-08-18', '2020-08-18_17.csv');
columns = {'timestamp','height_m','range_m','azimuth_deg','elevation_deg', ...
    'radial_wind_speed_mps','radial_status','cnr_db'};
D = readObservationColumns(filename, columns);
scanStart = "2020-08-18 17:59:46.579000";
first = find(D.timestamp == scanStart, 1);
assert(~isempty(first), 'The selected Higos scan is missing from %s.', filename);
% Hourly files retain complete scans, including the final ray after 18:00.
D = D(first:end, :);
rayTimes = unique(D.timestamp, 'stable');
assert(numel(rayTimes) >= 5, 'The selected Higos scan has fewer than five rays.');
rows = zeros(5, 1);
for k = 1:5
    candidates = find(D.timestamp == rayTimes(k));
    [~, j] = min(abs(D.height_m(candidates) - 500));
    rows(k) = candidates(j);
end
D = D(rows, :);
horizontalRange = D.range_m .* cosd(D.elevation_deg);
eastwardOffset = horizontalRange .* sind(D.azimuth_deg);
northwardOffset = horizontalRange .* cosd(D.azimuth_deg);
R = table((0:4)', D.timestamp, D.azimuth_deg, D.elevation_deg, ...
    D.range_m, D.height_m, eastwardOffset, northwardOffset, ...
    D.radial_wind_speed_mps, D.radial_status, D.cnr_db, ...
    'VariableNames', {'los_id','timestamp','azimuth_deg','elevation_deg', ...
    'range_m','height_m','eastward_offset_m','northward_offset_m', ...
    'radial_wind_speed_mps','source_status','cnr_db'});
end

