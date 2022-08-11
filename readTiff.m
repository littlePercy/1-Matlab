%% ***************************************************************
% Function: Read TIFF stack image from graphics file
%   Input:
%             the file name.
%   Output:
%             struct(image_array,width,height,bit_depth,channels,slices,frames,spacing,resolution,unit,voxel_size);
% Author: Ziliang He 
% Date: 2021/7/26
% *************************************************************************

%% 
function [tiffStack] = readTiff(filename)
    tiffInfo = imfinfo(filename); % return tiff structure, one element per image
    channels = 1;
    slices  = 1;
    frames = 1;
    spacing = [];
    voxel_size=[];
    unit =[];
    try 
        descri = tiffInfo(1).ImageDescription;         %read the image description
        if contains(descri,'spacing')
            endpoint = strfind(descri,'spacing')+8;
            while isstrprop(descri(endpoint+1),'digit') || descri(endpoint+1)=='.'
                endpoint = endpoint + 1;
            end
            spacing = str2double(descri(strfind(descri,'spacing')+8:endpoint));
        end
        if contains(descri,'unit')
            endpoint = strfind(descri,'unit')+5;
            while isstrprop(descri(endpoint+1),'alpha') 
                endpoint = endpoint + 1;
            end
            unit = descri(strfind(descri,'unit')+5:endpoint);
        end              
        
        if contains(descri,'channels')
            channels = str2num(descri(strfind(descri,'channels')+9));
        end
        if contains(descri,'slices')
            endpoint = strfind(descri,'slices')+7;
            while isstrprop(descri(endpoint+1),'digit') 
                endpoint = endpoint + 1;
            end
            slices = str2num(descri(strfind(descri,'slices')+7:endpoint));
        end
        if contains(descri,'frames')
            endpoint = strfind(descri,'frames')+7;
            while isstrprop(descri(endpoint+1),'digit') 
                endpoint = endpoint + 1;
            end
            frames = str2num(descri(strfind(descri,'frames')+7:endpoint));
        end
        if channels == 1 && slices  == 1 &&  frames == 1
            slices= size(tiffInfo,1);
        end
    catch 
        slices= size(tiffInfo,1);
    end
    tiffStack = imread(filename, 1) ; % read in first image
    %concatenate each successive tiff to tiff_stack
    for idx = 2 : size(tiffInfo, 1)
        tiffTemp = imread(filename, idx);
        tiffStack = cat(3 , tiffStack, tiffTemp);
    end
    tiffStack = reshape(tiffStack,size(tiffStack,1),size(tiffStack,2),channels,slices,frames); 
    if channels == 1
        tiffStack = permute(tiffStack,[1 2 4 5 3]); %Change the order of dimensions
    elseif slices == 1
        tiffStack = permute(tiffStack,[1 2 3 5 4]);
    end
    try
        resolution = tiffInfo(1).XResolution;
    catch
        resolution = [];
    end
    if ~isempty(resolution) && ~isempty(unit) && ~isempty(spacing)
        voxel_size = [num2str(1/tiffInfo(1).XResolution),'×',num2str(1/tiffInfo(1).XResolution),'×',num2str(spacing),unit,'^3'];
    end
    tiffStack = struct('image',tiffStack,'width',tiffInfo(1).Width,'height',tiffInfo(1).Height,'bit_depth',tiffInfo(1).BitDepth,'channels',channels,'slices',slices,'frames',frames, ...
        'spacing',spacing,'resolution',resolution,'unit',unit,'voxel_size',voxel_size);
end
