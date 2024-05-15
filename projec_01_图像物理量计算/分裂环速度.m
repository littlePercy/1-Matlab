file_path = '0002/ROI';
file_dir = dir(file_path);
intensity_list = [];
for i = 3:length(file_dir)
    img = imread([file_path, '\', file_dir(i).name]);
    img_8bit = any_to_8bit(img);
    area = size(img_8bit,1)*size(img_8bit,2);
    intensity = sum(img_8bit(:)) / area; 
    intensity_list = [intensity_list; intensity];
end
%% ==============================================
Data = intensity_list;
x = 0:1:(size(Data,1)-1);
y_1 = Data(:,1); y_1=y_1'; %信号数目
figure,plot(x, y_1, 'r-', 'LineWidth', 2)
hold on
box off; % 去除右上坐标标记
xlabel('Frame'),ylabel('Intensity (A.U.)')
set(gca,'linewidth',2) % 设置坐标轴线宽
set(gca,'FontSize',16);
saveas(gca,'ROI_2.png');
%% ==============================================
kyimg = any_to_8bit(imread...
 ('0002/YY071-ATc40pM-0.5mW488-50ms_preThz-001.tif (Projected Kymograph).tif'));
kyimg_flip = zeros(size(kyimg,2),size(kyimg,1));
for i = 1:size(kyimg_flip, 1)
    for j = 1:size(kyimg_flip, 2)
        kyimg_flip(i,j) =  kyimg(j, size(kyimg,2)-i+1);
    end
end
kyimg_flip = uint8(kyimg_flip);
imwrite(kyimg_flip, 'ROI_2_profile.png')
%% -----------------------------------------------------------------------------------------------------------------------
%% ==============================================
kyimg = any_to_8bit(imread...
 ('0005/YY071-ATc40pM-0.5mW488-50ms_preThz-001.tif (Projected Kymograph).tif'));
intensity_list = [];
for i = 1:size(kyimg,1)
    intensity = sum(kyimg(i,:)) / size(kyimg,2); 
    intensity_list = [intensity_list; intensity];
end
%% ==============================================
Data = intensity_list;
x = 0:1:(size(Data,1)-1);
y_1 = Data(:,1); y_1=y_1'; %信号数目
figure,plot(x, y_1, 'r-', 'LineWidth', 2)
hold on
% box off; % 去除右上坐标标记
xlabel('Frame'),ylabel('Intensity (A.U.)')
set(gca,'linewidth',2) % 设置坐标轴线宽
set(gca,'FontSize',16);
axis off
saveas(gca,'ROI_5.png');
% %% ==============================================
% kyimg_flip = zeros(size(kyimg,2),size(kyimg,1));
% for i = 1:size(kyimg_flip, 1)
%     for j = 1:size(kyimg_flip, 2)
%         kyimg_flip(i,j) =  kyimg(j, size(kyimg,2)-i+1);
%     end
% end
% kyimg_flip = uint8(kyimg_flip);
% imwrite(kyimg_flip, 'ROI_5_profile.png')
