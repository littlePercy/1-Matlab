%%
img_path = 'C:\Users\m1360\Desktop\Mesh\img512_0';
save_path = 'C:\Users\m1360\Desktop\Mesh\img512';
dirs = dir(img_path );
for kk = 3:length(dirs)
    imgName = [img_path,'\',dirs(kk).name];
    fullImage = imread(imgName);
    % 获取图像尺寸
    [height, width, ~] = size(fullImage);
    % 定义裁剪尺寸
    cropSize = 512;
    % 计算比例
    ratio = height/512;
    % 初始化存储裁剪后的图像块
    croppedImages = cell(ratio, ratio);
    % 循环裁剪
    num = 0;
    for i = 1:ratio
        for j = 1:ratio
            num = num+1;
            % 计算裁剪的起始位置
            startRow = (i - 1) * cropSize + 1;
            startCol = (j - 1) * cropSize + 1;
            % 裁剪图像块
            croppedImages{i, j} = fullImage(startRow:startRow+cropSize-1, startCol:startCol+cropSize-1, :);
            % 保存裁剪后的图像块
            saveName = [save_path,'\',dirs(kk).name(1:end-4),'-crop',num2str(num),'.tif'];
            imwrite(croppedImages{i, j}, saveName);
        end
    end
end
