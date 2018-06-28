function [ motionData, region, RunMC, RunSeg, RunIntAnl, quickIntensityAnalysis, FileName, PathName] = initialGUI( )
%INITIALGUI Summary of this function goes here
%   Detailed explanation goes here
% Help goes here.

% Code running parameters
brainRegions = {'DG';'CA1';'CA3';'Hilus';'DG s';'DG l'};
programOptions = {'Run from Motion Correction';'Run from Segmentation';'Only run Intensity Analysis';....
    'Only run Motion Correction';'Only run Segmentation';};
motionData = true;
program = 'Run from Motion Correction';
region = 'DG';
RunMC  = 1;
RunSeg = 1;
RunIntAnl = 1;
quickIntensityAnalysis = 0;
% File name
FileName = '';
PathName = '';
filePathRootPC = 'C:\Users\LOG-G\Desktop\Alex\';
filePathRootPC = 'C:\Users\LOG-G\Desktop\shannon\Pilo\';
filePathRootMAC = '~/Desktop/Salk Current Projects/test/';

guiHeight = 320;
guiWidth = 600;

% 'position', all distance units in pixels: [xdist ydist width height]
S.fh = figure('units','pixels',...
            'position',[300 300 guiWidth guiHeight],...
         	'menubar','none',...
          	'name','Ca Code',...
         	'numbertitle','off',...
        	'resize','off');
S.title = uicontrol('Style','text','fontsize',16,...
            'fontweight','bold',...
            'String','Calcium Imaging Parameter Selection',...
            'Position',[5 260 600 50]);
S.horozontalLine = uicontrol('Style','text','fontsize',12,...
            'fontweight','bold',...
            'String','',...
            'Position',[0 270 600 2],'backgroundcolor','k');
S.verticalLine = uicontrol('Style','text','fontsize',12,...
            'fontweight','bold',...
            'String','',...
            'Position',[guiWidth/2 0 2 guiHeight-50],'backgroundcolor','k');
%%% Where to Start the Program
S.dropdownText2 = uicontrol('Style','text','fontsize',12,...
            'fontweight','bold',...
            'String','Select which part of the program to run.',...
            'Position',[2 guiHeight-100 295 40]);
S.dropdownPrograms = uicontrol('style','pop',...
            'unit','pix',...
            'position',[10 guiHeight-120 280 20],...
           	'fontsize',12,...
           	'fontweight','bold',... 
         	'string',programOptions,...
           	'value',1);
%%% Region of Brain Selection
S.dropdownText1 = uicontrol('Style','text','fontsize',12,...
            'fontweight','bold',...
            'String','Select the region of the brain to analyze',...
            'Position',[2 guiHeight-200 295 50]);
S.dropdownRegion = uicontrol('style','pop',...
          	'unit','pix',...
        	'position',[10 guiHeight-215 280 20],...
         	'fontsize',12,...
           	'fontweight','bold',... 
         	'string',brainRegions,...
          	'value',1);
%%% Running Data Checkbox
S.checkbox1 = uicontrol('style','checkbox',...
          	'unit','pix',...
           	'position',[18 60 280 20],...
         	'fontsize',12,...
           	'fontweight','bold',... 
         	'callback',@checkbox1_Callback,...
          	'value',1);
S.checkboxText1 = uicontrol('Style','text','fontsize',12,...
            'fontweight','bold',...
            'String','< There is a .mat file of running data.',...
            'Position',[35 40 210 40]);
%%% File Selection
S.fileButton = uicontrol('style','push',...
            'unit','pix',...
         	'position',[guiWidth/2+5 guiHeight-100 20 20],...
            'fontsize',12,...
            'fontweight','bold',... 
          	'string','...',...
           	'callback',@button_file_call);
S.fileSelectText = uicontrol('Style','text','fontsize',12,...
            'fontweight','bold',...
            'String','Select file:',...
            'Position',[guiWidth/2+5 guiHeight-75 80 20]);
S.fileButtonText = uicontrol('Style','text','fontsize',11,...
            'String','NO FILE SELECTED',...
            'position',[guiWidth/2+25 guiHeight-100 270 20],...
            'backgroundcolor',[.8 .8 .8]);
%%% START Button
S.buttonStart = uicontrol('style','push',...
            'unit','pix',...
         	'position',[10 15 280 20],...
            'fontsize',12,...
            'fontweight','bold',... 
          	'string','START',...
           	'callback',@button_start_call);


guidata(S.fh,S)
movegui('center')

function [] = button_start_call(varargin)
    % Callback for pushbutton.
    S = guidata(gcbf);
    
    contents = get(S.dropdownRegion,'String'); 
    region = contents{get(S.dropdownRegion,'Value')}; % Sets value of region

    contents = get(S.dropdownPrograms,'String'); 
    program = contents{get(S.dropdownPrograms,'Value')}; % Sets program start point
    
    motionData = get(S.checkbox1,'Value'); % Sets binary motion data

    if strcmp(program,programOptions(1))
    % Run from Motion Correction
        % Default
    elseif strcmp(program,programOptions(2))
    % Run from Segmentation
        RunMC  = 0;
    elseif strcmp(program,programOptions(3))
    % Only run Intensity Analysis
        quickIntensityAnalysis = 1;
    elseif strcmp(program,programOptions(4))
    % Only run Motion Correction
        RunMC  = 1;
        RunSeg = 0;
        RunIntAnl = 0;
    elseif strcmp(program,programOptions(5))
    % Only run Segmentation
        RunMC  = 0;
        RunSeg = 1;
        RunIntAnl = 0;
    end

    close all force
end

function [] = button_file_call(varargin)
    %%%%%%%%%%%%%%%%%% User Selects File, different root path for each OS
    if ispc
        %%% For PC %%%
        [FileName, PathName] = uigetfile([filePathRootPC,'*.tif'],'TIFF Files');
    else
        %%% For Mac %%%
        [FileName,PathName] = uigetfile([filePathRootMAC,'*.tif'], 'TIFF files');
    end
    
    FileName = extractBetween(FileName,1,length(FileName)-4); % Removes the file extension (assumes ".tif")
    set(S.fileButtonText,'String', FileName)
    
end

function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1
%   NOT USED, AL DONE IN ABOVE FUNCTION. LEFT FOR REFERENCE
end

%%% Pauses the program until the figure 'S.fh' closes
waitfor(S.fh)

end

